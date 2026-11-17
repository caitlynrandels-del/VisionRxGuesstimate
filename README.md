# VisionRx Guesstimate (Complete Prototype)

A more complete Apple Vision Pro (visionOS) app for rough contact / glasses prescription guesstimation using only the device display and user responses.

## What’s included

- **Acuity Test** — Proper Landolt C shape with progressive sizes and threshold scoring. Estimates Snellen, logMAR, and a rough spherical power.
- **Blur Match** — Interactive digital defocus slider. Match the blur to your uncorrected vision for a second sphere estimate.
- **Astigmatism Fan** — Select the sharpest meridian for a rough axis (cylinder magnitude is intentionally limited).
- **Results list** — Stores estimates by eye and method. Local only.

## How to build

1. Open Xcode and create a new **visionOS App** (SwiftUI).
2. Replace the generated Swift files with the ones in this folder (or copy the code).
3. Build and run on Apple Vision Pro or the visionOS Simulator.

## Files

```
VisionRxGuesstimate/
├── VisionRxGuesstimateApp.swift
├── Models/
│   └── PrescriptionModels.swift
└── Views/
    ├── ContentView.swift          (includes Start / Disclaimer)
    ├── AcuityTestView.swift       (includes LandoltCShape)
    ├── BlurMatchingView.swift
    ├── AstigmatismTestView.swift
    └── ResultsView.swift
```

## Notes

- All heuristics are simplified for a self-contained prototype.
- Interaction is gaze + pinch or buttons.
- Results never leave the device.
- Extend as needed (better psychophysics, monocular occlusion prompts, Oroboro integration, etc.).

This version is substantially more complete than the first draft and ready for iterative refinement on-device.
