# OneKee

> 🔒 本地优先、端到端加密的跨平台密码管家。
>
> 🌏 English: [README.md](./README.md)

OneKee 是一款本地优先、端到端加密的跨平台密码管家。所有数据加密存储在你的设备本地，桌面端、移动端、命令行通过统一的 Rust 核心保证一致的加密与同步语义。

## ✨ 特性

- 🔐 **端到端加密** — 基于 KeePass 数据库格式，业界成熟加密算法
- 🖥 **多端覆盖** — macOS · iOS · Android · Windows · Linux · 命令行
- 🛰 **本地优先** — 数据始终在本地，可选 WebDAV / iCloud / 自建同步
- 🔌 **浏览器扩展** — 通过本地 Native Host 自动填充，不经过第三方服务器
- ⌨️ **CLI `onekee`** — 脚本化、SSH、CI 场景的密码访问

## 📥 获取 OneKee

### 商店渠道

| 平台 | 渠道 | 状态 |
|---|---|---|
| 🍎 macOS / iOS | [TestFlight](https://testflight.apple.com/join/7QU6Tj9Y) | 🧪 公测中 |
| 🍎 macOS / iOS | App Store | 🚧 即将上架 |
| 🤖 Android | Play 商店 | 🚧 即将上架 |

### GitHub Releases

从 [Releases](https://github.com/kaich/OneKee/releases/latest) 页面下载对应平台安装包：

| 平台 | 产物 |
|---|---|
| 🪟 Windows | `.exe` 安装包 / `.zip` 便携版 |
| 🐧 Linux | `.AppImage` / `.deb` / `.rpm` |
| 🤖 Android | `.apk` 直装 |

> 这些平台尚未发布首个稳定版本，请关注 Releases 页面更新。

### 🧩 浏览器扩展

[**在 Chrome 应用商店安装**](https://chromewebstore.google.com/detail/onekee/hdniebnhlafllklljcaehhoopdaahpob)

扩展通过本地 Native Host 连接 OneKee 桌面端，不经过任何第三方服务器。

### ⌨️ CLI `onekee`

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install.sh | bash
```

```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/kaich/OneKee/main/install.ps1 | iex
```

各平台二进制也可从 [Releases](https://github.com/kaich/OneKee/releases/latest) 直接下载。

## 🔒 隐私承诺

**OneKee 不收集任何用户信息。**

- ❌ 不上传、不统计、不上报任何使用数据
- ❌ 不内置任何分析 / 广告 / 追踪 SDK
- ❌ 不联网验证（除同步、扩展、CLI 等用户主动发起的连接外）
- ✅ 所有密码数据加密存储在本地设备
- ✅ 同步完全由用户掌控（iCloud / WebDAV / 自建服务器）
- ✅ 浏览器扩展仅通过本地 Native Host 通信，不经过第三方服务器
- ✅ 核心功能完全离线可用，可随时断网

抓包发现任何疑似联网行为，欢迎在 [Issues](https://github.com/kaich/OneKee/issues) 提出，我们会逐一核实并公开说明。

## 📚 文档

- **命令行使用**：`onekee --help`
- **浏览器扩展配置**：见 Releases 附带的说明文档
- **数据同步配置**：见各平台 App 内置帮助页面

## 💬 反馈

- **一般问题**：[Issues](https://github.com/kaich/OneKee/issues)
- **安全漏洞**：请勿公开 Issue，通过私有渠道联系维护者

## 📄 License

[MIT License](./LICENSE)
