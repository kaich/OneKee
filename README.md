# OneKee

> 🔒 Privacy-first, locally-stored, end-to-end encrypted cross-platform password manager.
>
> 🌏 [简体中文](./README.zh.md)

OneKee is a privacy-first, locally-stored, end-to-end encrypted cross-platform password manager. All data is encrypted and stored on your own device. The desktop apps, mobile clients, and CLI tool all share a single Rust core to guarantee consistent encryption and sync semantics.

## ✨ Features

| | |
|---|---|
| 🔐 **End-to-end encryption** | Built on the mature KeePass database format |
| 🖥 **Cross-platform** | macOS · iOS · Android · Windows · Linux · CLI |
| 🛰 **Local-first** | Data stays on device; optional WebDAV / iCloud / self-hosted sync |
| 🔌 **Browser extension** | Autofill via a local Native Host — no third-party servers |
| ⌨️ **CLI `onekee`** | Scripting, SSH, and CI password access |

## 📥 Get OneKee

### Stores

| Platform | Channel | Status |
|---|---|---|
| 🍎 macOS / iOS | [TestFlight](https://testflight.apple.com/join/7QU6Tj9Y) | 🧪 Beta |
| 🍎 macOS / iOS | App Store | 🚧 Coming soon |
| 🤖 Android | Play Store | 🚧 Coming soon |

### GitHub Releases

Download the installer for your platform from the [Releases](https://github.com/kaich/OneKee/releases/latest) page:

| Platform | Artifact |
|---|---|
| 🪟 Windows | `.exe` installer / `.zip` portable |
| 🐧 Linux | `.AppImage` / `.deb` / `.rpm` |
| 🤖 Android | `.apk` sideload |

> The first stable build for these platforms has not been published yet. Watch the Releases page for updates.

### 🧩 Browser extension

[**Install on Chrome Web Store**](https://chromewebstore.google.com/detail/onekee/hdniebnhlafllklljcaehhoopdaahpob)

The extension connects to the OneKee desktop app via a local Native Host — no third-party servers involved.

### ⌨️ CLI `onekee`

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install.sh | bash
```

```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/kaich/OneKee/main/install.ps1 | iex
```

Per-platform binaries are also available in [Releases](https://github.com/kaich/OneKee/releases/latest).

## 🔒 Privacy Commitment

**OneKee collects zero user data.**

- ❌ No usage analytics, telemetry, or error reporting
- ❌ No analytics / ad / tracking SDKs
- ❌ No online activation (except sync, extension, and CLI connections you explicitly initiate)
- ✅ All password data is encrypted at rest on your device
- ✅ Sync is fully under your control (iCloud / WebDAV / self-hosted)
- ✅ The browser extension talks only to a local Native Host — never through third-party servers
- ✅ Core features are fully offline-capable; disconnect anytime

If you observe any unexpected network activity during packet capture, please report it in [Issues](https://github.com/kaich/OneKee/issues). Every report will be investigated and answered publicly.

## 📚 Documentation

- **CLI usage**: `onekee --help`
- **Browser extension setup**: see the docs attached to each release
- **Sync configuration**: see the in-app help on each platform

## 💬 Feedback

- **General issues**: [Issues](https://github.com/kaich/OneKee/issues)
- **Security vulnerabilities**: do not open a public issue; contact the maintainer privately

## 📄 License

[MIT License](./LICENSE)
