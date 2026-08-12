# OneKee

> 🔒 本地优先、端到端加密的跨平台密码管家。
>
> 🌏 English: [README.md](./README.md)

OneKee 是一款开源理念、本地优先、端到端加密的跨平台密码管家。所有数据加密存储在你的设备本地，主程序、移动端、桌面端、命令行工具通过统一的 Rust 核心保证一致的加密与同步语义。

本仓库是 **OneKee 的官方发布中心（Release Hub）**，仅用于：
- 📦 提供各平台预编译产物下载（macOS / Windows / Linux / Android / iOS / CLI）
- 📖 项目介绍与使用文档入口
- 🔒 隐私承诺说明

> 源代码与开发文档存放在独立的私有仓库中，本仓库不包含源码。

## ✨ 特性

- 🔐 **端到端加密**：基于 Keepass 数据库格式，使用业界成熟的加密算法
- 🖥 **多端覆盖**：macOS、iOS、Android、Windows、Linux、命令行
- 🛰 **本地优先**：数据始终在本地，可选 WebDAV / iCloud / 自建服务同步
- 🔌 **浏览器扩展**：通过本地 Native Host 与本机通信，支持自动填充
- ⌨️ **命令行工具 `onekee`**：脚本化、SSH、CI 场景的密码访问

## 📥 获取 OneKee

| 平台 | 渠道 | 获取 |
|---|---|---|
| ✅ 浏览器（Chrome/Edge） | Chrome 应用商店 | [安装](https://chromewebstore.google.com/detail/onekee/hdniebnhlafllklljcaehhoopdaahpob) |
| ✅ 命令行（`onekee`） | 脚本 | `curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install.sh \| bash` |
| 🚧 Android | APK · [Releases](https://github.com/kaich/OneKee/releases/latest) | 即将发布 |
| 🚧 Windows | 安装包 · [Releases](https://github.com/kaich/OneKee/releases/latest) | 即将发布 |
| 🚧 Linux | AppImage/deb/rpm · [Releases](https://github.com/kaich/OneKee/releases/latest) | 即将发布 |
| 🚧 macOS / iOS | App Store | 即将上架 |

> ✅ 已发布 · 🚧 即将发布

### 浏览器扩展

从 [Chrome 应用商店](https://chromewebstore.google.com/detail/onekee/hdniebnhlafllklljcaehhoopdaahpob) 安装。扩展通过本地 Native Host 连接 OneKee 桌面端，不经过任何第三方服务器。

### 命令行工具（CLI）安装

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/kaich/OneKee/main/install.ps1 | iex
```

各平台二进制也可从 [Releases](https://github.com/kaich/OneKee/releases/latest) 直接下载。

## 🔒 隐私承诺

**OneKee 不收集任何用户信息。**

- ❌ 不上传、不统计、不上报任何使用数据
- ❌ 不内置任何分析 SDK、广告 SDK、追踪 SDK
- ❌ 不联网验证（除同步、浏览器扩展、CLI 访问主程序等用户主动发起的连接外）
- ✅ 所有密码数据加密存储在本地设备
- ✅ 同步功能完全由用户掌控（iCloud / WebDAV / 自建服务器）
- ✅ 浏览器扩展与本机通信仅通过本地 Native Host，不经过任何第三方服务器
- ✅ 你可以随时断网使用，OneKee 的核心功能完全离线可用

如果你在抓包过程中发现任何疑似联网行为，欢迎在 [Issues](https://github.com/kaich/OneKee/issues) 中提出，我们会逐一核实并公开说明。

## 📚 文档

- 命令行使用：`onekee --help`
- 浏览器扩展配置：见 Releases 附带的说明文档
- 数据同步配置：见各平台 App 内置帮助页面

## 💬 反馈

- 问题反馈：[Issues](https://github.com/kaich/OneKee/issues)
- 安全漏洞：请勿公开 Issue，通过私有渠道联系维护者

## 📄 License

OneKee 软件本体采用 [MIT License](./LICENSE)。
