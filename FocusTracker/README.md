# FocusTracker iOS MVP

This directory contains a minimal SwiftUI project skeleton for the FocusTracker app described in the project documentation. The code is designed for iOS 15.0 or later and includes placeholders for HealthKit and CoreMotion integration as well as a basic widget.

The project structure follows the design outlined in `implementplan.md` and `systemdesign.md`.

```
FocusTracker/
├── Models/
│   └── FocusSession.swift
├── Services/
│   ├── HealthKitManager.swift
│   ├── MotionManager.swift
│   └── LocalStorage.swift
├── Views/
│   └── MainView.swift
├── Widgets/
│   ├── FocusWidget.swift
│   └── FocusWidgetBundle.swift
└── FocusTrackerApp.swift
```

## Building

Open `FocusTracker.xcodeproj` in Xcode 15 or later and select the **FocusTracker**
scheme. The project targets iOS 15 and should build with the iOS 17 SDK.
Additional implementation is required for production use.
