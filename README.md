# Attention

This repository hosts the FocusTracker iOS prototype. To build the full iOS app you need Xcode on macOS, but the included Linux script installs a basic Swift environment so the command-line examples in the docs can run.

## Codex setup

Use `scripts/setup_codex.sh` to install Swift and build tools in the Codex environment:

```bash
sudo ./scripts/setup_codex.sh
```

After running the script you can compile individual Swift files with `swiftc`, though iOS-only frameworks like SwiftUI and HealthKit still require Xcode.
