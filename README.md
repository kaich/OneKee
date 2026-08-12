# FantasyPass · OneKee

> 🌏 [简体中文](#简体中文) · [English](#english)

---

## 简体中文

**FantasyPass** 是一款开源理念、本地优先、端到端加密的跨平台密码管家。所有数据加密存储在你的设备本地，主程序、移动端、桌面端、命令行工具通过统一的 Rust 核心保证一致的加密与同步语义。

本仓库是 **FantasyPass 的官方发布中心（Release Hub）**，仅用于：
- 📦 提供各平台预编译产物下载（macOS / Windows / Linux / Android / iOS / CLI）
- 📖 项目介绍与使用文档入口
- 🔒 隐私承诺说明

> 源代码与开发文档存放在独立的私有仓库中，本仓库不包含源码。

### ✨ 特性

- 🔐 **端到端加密**：基于 Keepass 数据库格式，使用业界成熟的加密算法
- 🖥 **多端覆盖**：macOS、iOS、Android、Windows、Linux、命令行
- 🛰 **本地优先**：数据始终在本地，可选 WebDAV / iCloud / 自建服务同步
- 🔌 **浏览器扩展**：通过 Native Host 与本机通信，支持自动填充
- ⌨️ **命令行工具 `onekee`**：脚本化、SSH、CI 场景的密码访问

### 📥 下载

前往 [Releases](https://github.com/kaich/OneKee/releases/latest) 页面选择对应平台：

| 平台 | 产物 |
|------|------|
| macOS (Apple Silicon) | `OneKee-darwin-arm64.dmg` |
| macOS (Intel) | `OneKee-darwin-x64.dmg` |
| Windows | `OneKee-setup.exe` / `OneKee-portable.zip` |
| Linux | `OneKee-linux-x64.AppImage` / `.deb` / `.rpm` |
| Android | `OneKee-android.apk` |
| 命令行工具 | `onekee-*` 各平台二进制 |

> 部分平台尚未发布首个稳定版本，请关注 Releases 页面更新。

#### 命令行工具（CLI）安装

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/kaich/OneKee/main/install.ps1 | iex
```

### 🔒 隐私承诺

**FantasyPass 不收集任何用户信息。**

- ❌ 不上传、不统计、不上报任何使用数据
- ❌ 不内置任何分析 SDK、广告 SDK、追踪 SDK
- ❌ 不联网验证（除同步、浏览器扩展、CLI 访问主程序等用户主动发起的连接外）
- ✅ 所有密码数据加密存储在本地设备
- ✅ 同步功能完全由用户掌控（iCloud / WebDAV / 自建服务器）
- ✅ 浏览器扩展与本机通信仅通过本地 Native Host，不经过任何第三方服务器
- ✅ 你可以随时断网使用，FantasyPass 的核心功能完全离线可用

如果你在抓包过程中发现任何疑似联网行为，欢迎在 [Issues](https://github.com/kaich/OneKee/issues) 中提出，我们会逐一核实并公开说明。

### 📚 文档

- 命令行使用：`onekee --help`
- 浏览器扩展配置：见 Releases 附带的说明文档
- 数据同步配置：见各平台 App 内置帮助页面

### 💬 反馈

- 问题反馈：[Issues](https://github.com/kaich/OneKee/issues)
- 安全漏洞：请勿公开 Issue，通过私有渠道联系维护者

### 📄 License

FantasyPass 软件本体采用 [MIT License](./LICENSE)。

---

## English

**FantasyPass** is a privacy-first, locally-stored, end-to-end encrypted cross-platform password manager. All data is encrypted and stored on your own device. The desktop apps, mobile clients, and CLI tool all share a single Rust core to guarantee consistent encryption and sync semantics.

This repository is the **official release hub for FantasyPass**, used only for:
- 📦 Distributing pre-built binaries for every platform (macOS / Windows / Linux / Android / iOS / CLI)
- 📖 Project introduction and documentation entry points
- 🔒 Privacy commitments

> Source code lives in a separate private repository. This repo contains no source.

### ✨ Features

- 🔐 **End-to-end encryption** built on the mature KeePass database format
- 🖥 **Cross-platform**: macOS, iOS, Android, Windows, Linux, command line
- 🛰 **Local-first**: data always stays on device, with optional WebDAV / iCloud / self-hosted sync
- 🔌 **Browser extension** communicating via local Native Host for autofill
- ⌨️ **CLI tool `onekee`** for scripting, SSH, and CI scenarios

### 📥 Download

Visit the [Releases](https://github.com/kaich/OneKee/releases/latest) page and pick your platform:

| Platform | Artifact |
|----------|----------|
| macOS (Apple Silicon) | `OneKee-darwin-arm64.dmg` |
| macOS (Intel) | `OneKee-darwin-x64.dmg` |
| Windows | `OneKee-setup.exe` / `OneKee-portable.zip` |
| Linux | `OneKee-linux-x64.AppImage` / `.deb` / `.rpm` |
| Android | `OneKee-android.apk` |
| CLI | `onekee-*` per-platform binaries |

> Some platforms have not yet published a stable release. Watch the Releases page for updates.

#### CLI install

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/kaich/OneKee/main/install.ps1 | iex
```

### 🔒 Privacy Commitment

**FantasyPass collects zero user data.**

- ❌ No usage analytics, no telemetry, no error reporting
- ❌ No analytics SDK, no ad SDK, no tracking SDK
- ❌ No online activation (connections are only made for sync, browser extension, and CLI access that you explicitly initiate)
- ✅ All password data is encrypted at rest on your device
- ✅ Sync is fully under your control (iCloud / WebDAV / self-hosted)
- ✅ The browser extension talks to your machine only via a local Native Host — never through third-party servers
- ✅ Core features are fully offline-capable; you can disconnect from the network at any time

If you observe any unexpected network activity during packet capture, please report it in [Issues](https://github.com/kaich/OneKee/issues). Every report will be investigated and answered publicly.

### 📚 Documentation

- CLI usage: `onekee --help`
- Browser extension setup: see the docs attached to each release
- Sync configuration: see the in-app help on each platform

### 💬 Feedback

- General issues: [Issues](https://github.com/kaich/OneKee/issues)
- Security vulnerabilities: do not open a public issue; contact the maintainer privately

### 📄 License

FantasyPass is released under the [MIT License](./LICENSE).
