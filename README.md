# OneKee

> 🔒 Privacy-first, locally-stored, end-to-end encrypted cross-platform password manager.
>
> 🌏 [简体中文](./README.zh.md)

OneKee is a privacy-first, locally-stored, end-to-end encrypted cross-platform password manager. All data is encrypted and stored on your own device. The desktop apps, mobile clients, and CLI tool all share a single Rust core to guarantee consistent encryption and sync semantics.

This repository is the **official release hub for OneKee**, used only for:
- 📦 Distributing pre-built binaries for every platform (macOS / Windows / Linux / Android / iOS / CLI)
- 📖 Project introduction and documentation entry points
- 🔒 Privacy commitments

> Source code lives in a separate private repository. This repo contains no source.

## ✨ Features

- 🔐 **End-to-end encryption** built on the mature KeePass database format
- 🖥 **Cross-platform**: macOS, iOS, Android, Windows, Linux, command line
- 🛰 **Local-first**: data always stays on device, with optional WebDAV / iCloud / self-hosted sync
- 🔌 **Browser extension** that talks to your machine only via a local Native Host for autofill
- ⌨️ **CLI tool `onekee`** for scripting, SSH, and CI scenarios

## 📥 Get OneKee

Pick the channel that matches your device. Different platforms ship through different stores — choose the one for yours.

### 🍎 macOS & iOS — TestFlight

Join the beta on TestFlight (covers both macOS and iOS):

[**Join OneKee on TestFlight**](https://testflight.apple.com/join/7QU6Tj9Y)

### 🤖 Android

- **Play Store** — coming soon.
- **APK direct install** — download from [Releases](https://github.com/kaich/OneKee/releases/latest) and sideload.

### 🪟 Windows & 🐧 Linux — GitHub Releases

Download the installer for your platform from the [Releases](https://github.com/kaich/OneKee/releases/latest) page:

- **Windows**: `.exe` installer / portable `.zip`
- **Linux**: `.AppImage` / `.deb` / `.rpm`

> The first stable build for these platforms has not been published yet. Watch the Releases page for updates.

### 🧩 Browser extension — Chrome Web Store

Install the official Chrome extension:

[**OneKee on Chrome Web Store**](https://chromewebstore.google.com/detail/onekee/hdniebnhlafllklljcaehhoopdaahpob)

The extension connects to the OneKee desktop app via a local Native Host — no third-party servers involved.

### ⌨️ CLI (`onekee`) — install script

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/kaich/OneKee/main/install.ps1 | iex
```

Per-platform binaries are also available in [Releases](https://github.com/kaich/OneKee/releases/latest).

## 🔒 Privacy Commitment

**OneKee collects zero user data.**

- ❌ No usage analytics, no telemetry, no error reporting
- ❌ No analytics SDK, no ad SDK, no tracking SDK
- ❌ No online activation (connections are only made for sync, browser extension, and CLI access that you explicitly initiate)
- ✅ All password data is encrypted at rest on your device
- ✅ Sync is fully under your control (iCloud / WebDAV / self-hosted)
- ✅ The browser extension talks to your machine only via a local Native Host — never through third-party servers
- ✅ Core features are fully offline-capable; you can disconnect from the network at any time

If you observe any unexpected network activity during packet capture, please report it in [Issues](https://github.com/kaich/OneKee/issues). Every report will be investigated and answered publicly.

## 📚 Documentation

- CLI usage: `onekee --help`
- Browser extension setup: see the docs attached to each release
- Sync configuration: see the in-app help on each platform

## 💬 Feedback

- General issues: [Issues](https://github.com/kaich/OneKee/issues)
- Security vulnerabilities: do not open a public issue; contact the maintainer privately

## 📄 License

OneKee is released under the [MIT License](./LICENSE).
