# App icon

The ReFrame icon is a chirped waveform — jagged on the left, settling into a
single smooth swell on the right. Anxiety resolving into calm, without words.

## Regenerating the artwork

```bash
pip install pillow numpy
python3 Design/generate_app_icons.py
```

That writes three 1024x1024 files next to the script:

| File              | Asset catalog slot | Notes                                        |
| ----------------- | ------------------ | -------------------------------------------- |
| `Icon-Light.png`  | Any (Light)        | Dawn palette, opaque                          |
| `Icon-Dark.png`   | Dark               | Twilight palette, opaque                      |
| `Icon-Tinted.png` | Tinted             | Grayscale on transparency — iOS supplies tint |

The palettes are kept in step with the in-app mesh gradients in
`ReFrame/Theme.swift`. If those colours change, update the corner values in
`build_light()` / `build_dark()` to match.

## Installing them in Xcode

1. Open `Assets.xcassets` and select **AppIcon**.
2. In the Attributes inspector, set **Appearances** to **Any, Dark, Tinted**.
   The single 1024 well becomes three.
3. Drag each PNG into its matching well.

No code is involved: on iOS 18 and later the system chooses the variant based
on the device's home screen appearance. There is no call to
`setAlternateIconName`, and therefore no "You have changed the icon" alert.

The PNGs themselves are not committed — they live in the asset catalog once
installed, and the script above reproduces them exactly.
