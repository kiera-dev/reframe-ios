//
//  Theme.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/27/26.
//

import SwiftUI

// MARK: - Palette

extension Color {
    static let midnightDeep = Color(red: 0.04, green: 0.07, blue: 0.18)
    static let softTeal = Color(red: 0.45, green: 0.73, blue: 0.71)
    static let calmSage = Color(red: 0.65, green: 0.75, blue: 0.68)

    static let dawnInk = Color(red: 0.22, green: 0.25, blue: 0.30)
    static let dawnSage = Color(red: 0.40, green: 0.56, blue: 0.49)
}

// MARK: - App Theme

enum AppTheme: String, CaseIterable, Identifiable {
    case twilight
    case dawn

    var id: String { rawValue }

    var label: String {
        switch self {
        case .twilight: return "Twilight"
        case .dawn: return "Dawn"
        }
    }

    var icon: String {
        switch self {
        case .twilight: return "moon.stars.fill"
        case .dawn: return "sun.and.horizon.fill"
        }
    }

    var textPrimary: Color {
        switch self {
        case .twilight: return .white
        case .dawn: return .dawnInk
        }
    }

    var textSecondary: Color { textPrimary.opacity(0.65) }

    var accent: Color {
        switch self {
        case .twilight: return .softTeal
        case .dawn: return .dawnSage
        }
    }

    var cardFill: Color {
        switch self {
        case .twilight: return .white.opacity(0.08)
        case .dawn: return .white.opacity(0.55)
        }
    }

    var cardStroke: Color {
        switch self {
        case .twilight: return .white.opacity(0.10)
        case .dawn: return .white.opacity(0.85)
        }
    }

    /// 3x3 grid of mesh colors, row by row, top to bottom.
    var meshColors: [Color] {
        switch self {
        case .twilight:
            return [
                Color(red: 0.08, green: 0.09, blue: 0.22), Color(red: 0.18, green: 0.13, blue: 0.34), Color(red: 0.06, green: 0.08, blue: 0.20),
                Color(red: 0.08, green: 0.22, blue: 0.28), Color(red: 0.14, green: 0.12, blue: 0.30), Color(red: 0.08, green: 0.09, blue: 0.22),
                Color(red: 0.03, green: 0.05, blue: 0.14), Color(red: 0.07, green: 0.10, blue: 0.24), Color(red: 0.08, green: 0.20, blue: 0.26)
            ]
        case .dawn:
            return [
                Color(red: 0.96, green: 0.92, blue: 0.85), Color(red: 0.82, green: 0.89, blue: 0.87), Color(red: 0.96, green: 0.84, blue: 0.75),
                Color(red: 0.95, green: 0.83, blue: 0.74), Color(red: 0.96, green: 0.91, blue: 0.84), Color(red: 0.68, green: 0.80, blue: 0.70),
                Color(red: 0.63, green: 0.77, blue: 0.66), Color(red: 0.80, green: 0.88, blue: 0.85), Color(red: 0.95, green: 0.91, blue: 0.83)
            ]
        }
    }

    func orbColor(for type: StepType) -> Color {
        switch (self, type) {
        case (.twilight, .inhale), (.twilight, .exhale):
            return Color(red: 0.45, green: 0.73, blue: 0.71)
        case (.twilight, .tense):
            return Color(red: 1.00, green: 0.65, blue: 0.35)
        case (.twilight, .release):
            return Color(red: 0.55, green: 0.85, blue: 0.65)
        case (.twilight, .neutral):
            return Color(red: 0.60, green: 0.60, blue: 0.80)
        case (.dawn, .inhale), (.dawn, .exhale):
            return Color(red: 0.30, green: 0.56, blue: 0.54)
        case (.dawn, .tense):
            return Color(red: 0.82, green: 0.48, blue: 0.32)
        case (.dawn, .release):
            return Color(red: 0.38, green: 0.60, blue: 0.42)
        case (.dawn, .neutral):
            return Color(red: 0.50, green: 0.50, blue: 0.54)
        }
    }
}

// MARK: - Theme Toggle

struct ThemeToggleButton: View {
    @AppStorage("appTheme") private var themeRaw = AppTheme.twilight.rawValue
    private var theme: AppTheme { AppTheme(rawValue: themeRaw) ?? .twilight }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 1.2)) {
                themeRaw = (theme == .twilight ? AppTheme.dawn : .twilight).rawValue
            }
        } label: {
            Image(systemName: theme.icon)
                .font(.system(size: 16, weight: .light))
                .foregroundStyle(theme.textPrimary.opacity(0.8))
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial, in: Circle())
                .overlay(Circle().stroke(theme.cardStroke, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Switch to \(theme == .twilight ? "Dawn" : "Twilight") theme")
    }
}

// MARK: - Backgrounds

struct CalmingBackground: View {
    var theme: AppTheme = .twilight

    var body: some View {
        Group {
            if #available(iOS 18.0, *) {
                AnimatedMeshBackground(theme: theme)
            } else {
                DriftingAuraBackground(theme: theme)
            }
        }
        .ignoresSafeArea()
    }
}

// Slowly undulating mesh gradient. Control points drift on ~30-60s cycles so
// the movement is felt more than seen. Renders statically when Reduce Motion
// is enabled.
@available(iOS 18.0, *)
private struct AnimatedMeshBackground: View {
    let theme: AppTheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private static let restingPoints: [SIMD2<Float>] = [
        [0, 0], [0.5, 0], [1, 0],
        [0, 0.5], [0.5, 0.5], [1, 0.5],
        [0, 1], [0.5, 1], [1, 1]
    ]

    var body: some View {
        if reduceMotion {
            MeshGradient(
                width: 3,
                height: 3,
                points: Self.restingPoints,
                colors: theme.meshColors
            )
        } else {
            TimelineView(.animation(minimumInterval: 1.0 / 12.0)) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: [
                        [0, 0], [Float(0.5 + 0.10 * sin(t * 0.11)), 0], [1, 0],
                        [0, Float(0.5 + 0.09 * sin(t * 0.13))],
                        [Float(0.5 + 0.14 * sin(t * 0.19)), Float(0.5 + 0.14 * cos(t * 0.15))],
                        [1, Float(0.5 + 0.08 * cos(t * 0.12))],
                        [0, 1], [Float(0.5 + 0.08 * cos(t * 0.09)), 1], [1, 1]
                    ],
                    colors: theme.meshColors
                )
            }
        }
    }
}

// Pre-iOS 18 fallback: layered gradient with two large drifting blurred blobs.
private struct DriftingAuraBackground: View {
    let theme: AppTheme
    @State private var drifting = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var gradientColors: [Color] {
        switch theme {
        case .twilight:
            return [Color(red: 0.08, green: 0.09, blue: 0.22), .midnightDeep, Color(red: 0.14, green: 0.12, blue: 0.30)]
        case .dawn:
            return [Color(red: 0.96, green: 0.92, blue: 0.85), Color(red: 0.82, green: 0.89, blue: 0.87), Color(red: 0.95, green: 0.83, blue: 0.74)]
        }
    }

    private var blobA: Color {
        theme == .twilight ? Color.softTeal.opacity(0.20) : Color(red: 0.63, green: 0.77, blue: 0.66).opacity(0.7)
    }

    private var blobB: Color {
        theme == .twilight ? Color(red: 0.18, green: 0.13, blue: 0.34).opacity(0.55) : Color(red: 0.95, green: 0.80, blue: 0.70).opacity(0.8)
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle()
                .fill(blobA)
                .frame(width: 420, height: 420)
                .blur(radius: 90)
                .offset(x: drifting ? -80 : -160, y: drifting ? -260 : -180)
            Circle()
                .fill(blobB)
                .frame(width: 480, height: 480)
                .blur(radius: 100)
                .offset(x: drifting ? 140 : 60, y: drifting ? 240 : 330)
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                drifting = true
            }
        }
    }
}
