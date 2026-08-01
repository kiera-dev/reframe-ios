#!/usr/bin/env python3
"""
Generates the ReFrame app icon appearance variants.

The mark is a chirped waveform: chaotic on the left, settling into one smooth
swell on the right — anxiety resolving into calm. Palettes match the in-app
Twilight / Dawn mesh gradients in ReFrame/Theme.swift.

Outputs (1024x1024, next to this script):
    Icon-Light.png    Dawn palette, opaque      -> asset catalog "Any" slot
    Icon-Dark.png     Twilight palette, opaque  -> asset catalog "Dark" slot
    Icon-Tinted.png   grayscale on transparent  -> asset catalog "Tinted" slot

Usage:
    pip install pillow numpy
    python3 generate_app_icons.py
"""

import math
import os

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

SS = 2048   # supersample, downscaled to OUT for clean edges
OUT = 1024
HERE = os.path.dirname(os.path.abspath(__file__))


# --- background -------------------------------------------------------------

def mesh_bg(size, corners, center_pull=0.45):
    """Bilinear corner blend with a soft radial pull toward a centre colour,
    approximating the SwiftUI MeshGradient used for the app background.
    corners: (top_left, top_right, bottom_left, bottom_right, centre) as RGB 0-1.
    """
    yy, xx = np.mgrid[0:size, 0:size].astype(np.float32)
    u = xx / (size - 1)
    v = yy / (size - 1)
    tl, tr, bl, br, centre = corners
    img = np.zeros((size, size, 3), np.float32)
    for c in range(3):
        top = tl[c] + (tr[c] - tl[c]) * u
        bot = bl[c] + (br[c] - bl[c]) * u
        base = top + (bot - top) * v
        d = np.sqrt((u - 0.5) ** 2 + (v - 0.5) ** 2)
        w = np.clip(1 - d / 0.8, 0, 1) ** 1.6
        img[..., c] = base * (1 - center_pull * w) + centre[c] * (center_pull * w)
    return img


# --- the mark ---------------------------------------------------------------

def wave_mask(size, width_frac=0.052, margin_frac=0.115, amp_frac=0.132, cy=0.5):
    """White stroke on black. Frequency decays left-to-right, so the line starts
    jagged and ends as a single smooth swell.
    """
    margin = margin_frac * size
    points = []
    samples = 3000
    for i in range(samples):
        u = i / (samples - 1)
        x = margin + u * (size - 2 * margin)
        # integral of a linearly decaying frequency -> monotonic phase
        phase = 2 * math.pi * (5.0 * u - 2.225 * u * u)
        amp = (amp_frac + 0.030 * (1 - u) ** 1.5) * size
        points.append((x, cy * size - math.sin(phase) * amp))

    img = Image.new("L", (size, size), 0)
    draw = ImageDraw.Draw(img)
    width = int(width_frac * size)
    radius = width // 2
    draw.line(points, fill=255, width=width, joint="curve")
    for (px, py) in (points[0], points[-1]):   # round caps
        draw.ellipse([px - radius, py - radius, px + radius, py + radius], fill=255)
    return img


def as_array(img):
    return np.asarray(img).astype(np.float32) / 255.0


def composite(bg, mask, halo, core, halo_strength, core_strength):
    """Lay the glowing stroke over an opaque background."""
    g_wide = as_array(mask.filter(ImageFilter.GaussianBlur(SS * 0.045)))
    g_mid = as_array(mask.filter(ImageFilter.GaussianBlur(SS * 0.016)))
    g_core = as_array(mask.filter(ImageFilter.GaussianBlur(SS * 0.0035)))
    glow = np.clip(g_wide * 0.85 + g_mid * 0.9, 0, 1)

    out = bg.copy()
    for c in range(3):
        out[..., c] = out[..., c] + glow * halo[c] * halo_strength
        out[..., c] = out[..., c] * (1 - g_core * core_strength) + core[c] * (g_core * core_strength)
    return np.clip(out, 0, 1)


def save_rgb(array, filename):
    img = Image.fromarray((array * 255).astype(np.uint8), "RGB").resize((OUT, OUT), Image.LANCZOS)
    img.save(os.path.join(HERE, filename))
    print("wrote", filename)


# --- variants ---------------------------------------------------------------

def build_light(mask):
    """Dawn palette. On a pale ground the stroke is a solid deeper sage — a
    glowing white core would simply disappear.
    """
    bg = mesh_bg(SS, [
        (0.96, 0.93, 0.86),   # sand
        (0.83, 0.90, 0.88),   # misty teal
        (0.66, 0.79, 0.68),   # sage
        (0.96, 0.85, 0.76),   # blush
        (0.95, 0.92, 0.86),
    ], center_pull=0.35)
    save_rgb(composite(bg, mask,
                       halo=(0.28, 0.50, 0.44), core=(0.20, 0.42, 0.38),
                       halo_strength=0.30, core_strength=0.92),
             "Icon-Light.png")


def build_dark(mask):
    """Twilight palette, with the neon core the dark ground can carry."""
    bg = mesh_bg(SS, [
        (0.09, 0.10, 0.24),   # indigo
        (0.15, 0.12, 0.31),   # violet
        (0.04, 0.06, 0.16),   # deepest
        (0.08, 0.21, 0.28),   # teal
        (0.13, 0.12, 0.30),
    ])
    save_rgb(composite(bg, mask,
                       halo=(0.45, 0.80, 0.78), core=(0.88, 0.99, 0.97),
                       halo_strength=0.62, core_strength=0.95),
             "Icon-Dark.png")


def build_tinted(mask):
    """Grayscale glyph on transparency — iOS supplies the backdrop and the tint,
    so any background of our own would just muddy the result.
    """
    g_wide = as_array(mask.filter(ImageFilter.GaussianBlur(SS * 0.040)))
    g_mid = as_array(mask.filter(ImageFilter.GaussianBlur(SS * 0.014)))
    g_core = as_array(mask.filter(ImageFilter.GaussianBlur(SS * 0.0035)))

    alpha = np.clip(g_wide * 0.45 + g_mid * 0.65 + g_core * 1.0, 0, 1)
    lum = np.clip(g_wide * 0.30 + g_mid * 0.55 + g_core * 1.0, 0, 1)

    rgba = np.zeros((SS, SS, 4), np.float32)
    for c in range(3):
        rgba[..., c] = lum
    rgba[..., 3] = alpha

    img = Image.fromarray((np.clip(rgba, 0, 1) * 255).astype(np.uint8), "RGBA")
    img = img.resize((OUT, OUT), Image.LANCZOS)
    img.save(os.path.join(HERE, "Icon-Tinted.png"))
    print("wrote Icon-Tinted.png")


if __name__ == "__main__":
    mark = wave_mask(SS)
    build_light(mark)
    build_dark(mark)
    build_tinted(mark)
