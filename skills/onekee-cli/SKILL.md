---
name: onekee-cli
description: 通过 OneKee CLI（onekee 命令）为用户查询和填充密码库条目。当用户要求"查一下 XX 的密码"、"我的 GitHub 密码是多少"、"帮我打开 XX 的登录页"、"把这个 secret 给我"等涉及凭证查询的操作时使用。前置：用户已安装 OneKee 桌面端、Chrome 扩展与 onekee CLI，并完成配对。
---

# OneKee CLI 密码查询

## 前置条件（缺一不可，先检查再操作）

本 skill 依赖 OneKee 三件套协同工作：

1. **OneKee 桌面端 App** — 密码库本体与本地 Broker，必须保持运行；关联数据库需已解锁，或其 Access Key 已开启**自动解锁数据库**（支持该功能的桌面版本）
2. **OneKee Chrome 扩展** — 浏览器自动填充入口：
   https://chromewebstore.google.com/detail/onekee/hdniebnhlafllklljcaehhoopdaahpob
3. **onekee CLI** — 命令行访问入口

> ⚠️ **浏览器自动填充功能必须三者全部安装才能工作**：桌面端提供数据，CLI 注册为 Native Host（`onekee connect chrome`），扩展负责在网页里填充。只装其中一或两个，浏览器填充不可用。

安装与配对方法见公开仓 README：
https://github.com/kaich/OneKee

## 什么时候用什么命令

| 用户意图 | 命令 |
|---|---|
| "查 XX 的密码条目" / "我有哪些 XX 的账号" | `onekee resolve --query <关键词> --access-key <key>` |
| "把 XX 的密码给我" / "取这个条目的 secret/token" | `onekee get-secret --entry-id <id> --fields password --access-key <key>` |
| "打开 XX 的登录页" | `onekee open-url --entry-id <id> --access-key <key>` |
| "看看主程序在不在线" | `onekee discover` |
| 首次使用 / CLI 未配对 | `onekee pair` |

## 标准工作流

### 1. 检查连通性

```bash
onekee discover
```

- 有输出（endpoint 列表）→ 桌面端 Broker 在线，继续
- 无输出 → 提示用户：**先启动 OneKee 桌面端 App 并检查服务状态**

### 2. 搜索条目

用户说"查 GitHub 的密码"时，先 resolve 拿到条目列表，把条目信息展示给用户确认：

```bash
onekee resolve --query github --access-key <用户的AccessKey>
```

输出格式（每行一个条目）：

```
- <entry-id> | <标题> | <用户名> | <网址>
```

**多个匹配时，列出候选让用户选，不要猜。**

### 3. 取密钥字段

用户确认条目后，用 entry-id 取字段：

```bash
onekee get-secret --entry-id <id> --fields password --access-key <key>
```

多字段（如同时要用户名和密码）：

```bash
onekee get-secret --entry-id <id> --fields username,password --access-key <key>
```

### 4. 打开登录页（可选）

```bash
onekee open-url --entry-id <id> --access-key <key>
```

## 后台解锁与等待时间

首次后台解锁可能比读取已缓存会话慢。CLI 默认等待 60 秒，可为慢库显式设置 `--timeout <秒数>`（1–3600）：

```bash
onekee resolve --query github --access-key <key> --timeout 120
```

连接与 TLS 握手分别有较短的等待上限；延长读取等待不会绕过连接、身份或条目权限检查。超时后先检查设备与数据库状态，再重新发起操作。

## 协议版本检查

CLI 在发送 AccessKey 前会在同一连接内协商协议版本；本机 socket 和局域网 TLS 都会检查。软件版本不必完全相同，只要双方支持的协议范围有交集即可。

- `CLI_UPDATE_REQUIRED`：更新 CLI。
- `APP_UPDATE_REQUIRED`：更新作为密码库 host 的 OneKee 客户端。
- `PROTOCOL_NEGOTIATION_FAILED`：对端不支持握手、响应异常或连接中断；检查服务状态及双方版本，不能据此确定哪一端过旧。

这些错误不会继续发送 AccessKey。不要跳过协议或服务端身份校验，也不要尝试使用旧版明文连接。

## AccessKey 从哪来

AccessKey 在 **OneKee 桌面端 App 内生成**（设置 → 密钥管理 → 创建 Access Key）。如果用户不知道 AccessKey：

1. 让用户打开 OneKee 桌面端
2. 进入「设置 → 密钥管理」，点击「创建 Access Key」
3. 关联一个数据库并选择允许访问的条目；桌面端无人值守访问需在 Key 详情开启「自动解锁数据库」
4. 让用户把 Access Key 提供给你，查询命令通过 `--access-key <key>` 参数传入

桌面端后台自动解锁不会解锁主界面；CLI 只读取该 Key 授权的条目。不要向用户索取数据库主密码来替代 Access Key。移动端仍需手动解锁。

> 除 `discover` / `pair` 外，所有查询命令都必须带 `--access-key` 参数；CLI 不支持环境变量等其他传入方式。

**不要把 AccessKey 写进任何文件、提交或日志。**

## 首次配对（仅一次）

CLI 第一次使用时需要跟桌面端配对：

```bash
onekee pair
```

首次局域网配对：CLI 发起 → 用户在 **OneKee「设置 > 设备管理」**复制完整的 SHA-256 服务端指纹 → 按 CLI 提示输入指纹 → 输入同页的 6 位配对码 → 完成。只使用主程序显示的指纹，不把网络发现结果或 CLI 自己显示的未知指纹当成信任依据。配对成功后 CLI 会固定服务端身份，后续局域网连接使用 TLS 加密并验证该身份。

指定局域网设备：

```bash
onekee pair --endpoint tcp://host:52145
```

分步配对时必须保留 `pair-start` 返回的会话 ID：

```bash
onekee pair-start --client-label <设备名> --endpoint tcp://host:52145
onekee pair-confirm --session-id <会话ID> --pair-code <6位码> --server-fingerprint <主程序显示的完整指纹> --endpoint tcp://host:52145
```

访客配对可在 `pair-confirm` 加 `--guest --guest-ttl <秒数>`。`--server-fingerprint` 接受完整 64 位十六进制 SHA-256，可包含冒号或空格；必须从主程序获取。本机 socket 使用操作系统访问权限；局域网身份未知或发生变化时不能读取凭据，不能通过跳过校验或改用明文连接绕过。重新配对前先让用户核对主程序身份。移动端必须由用户手动解锁关联数据库。

## 浏览器填充设置（通常已自动完成）

官方安装脚本（install.sh / install.ps1）装完 CLI 时会**自动**执行 `onekee connect chrome`，把 CLI 注册为 Chrome Native Messaging Host，之后**重启 Chrome** 即可让扩展与桌面端通信。

只有当安装时注册失败（日志提示）或扩展连不上时，才需要手动执行：

```bash
onekee connect chrome
```

前提同样是：桌面端 + 扩展 + CLI 三件套齐全。

## 错误处理对照

| 报错关键词 | 含义 | 处理 |
|---|---|---|
| `missing required flag --access-key` | 没带 AccessKey | 引导用户从桌面端获取 |
| `failed to connect broker` / ConnectFailed | 桌面端或 Broker 未运行 | 让用户启动桌面端并检查服务 |
| `DATABASE_LOCKED` / `LOCKED` / `locked` | 关联库已锁定，未允许后台解锁 | 让用户手动解锁，或在支持的桌面端 Key 详情开启自动解锁 |
| `DATABASE_NOT_BOUND` | Key 尚未绑定数据库 | 让用户在 Key 详情关联数据库并选择授权条目 |
| `AUTO_UNLOCK_FAILED` | 保存的凭据无法解锁数据库 | 让用户手动解锁后重新关闭并开启该 Key 的自动解锁 |
| `DATABASE_UNAVAILABLE` / `DATABASE_CHANGED` | 文件暂不可访问或读取期间发生变化 | 检查文件授权后重试；不要改用其他库或越过授权 |
| `NOT_FOUND` | 条目不存在 | 换关键词重新 resolve |
| 服务端身份未知或指纹不匹配 | 尚未配对，或服务端身份发生变化 | 请用户从主程序核对完整指纹并重新配对；不要静默接受新身份 |
| 请求超时 | 连接或后台解锁未在等待时间内完成 | 检查设备在线及关联库状态后重试；不要改读其他数据库 |
| `CLI_UPDATE_REQUIRED` | CLI 协议过旧 | 更新 CLI，再重试 |
| `APP_UPDATE_REQUIRED` | host 协议过旧 | 更新 OneKee 客户端，再重试 |
| `PROTOCOL_NEGOTIATION_FAILED` | 无法确认协议兼容性 | 检查连接和双方版本；不要绕过握手 |
| `REPLAY_DETECTED` | 请求被重复发送 | 重新发起操作生成新请求，不能重复使用旧签名 |

## 安全红线

- 密码/secret 字段**只在用户明确要求时**读取，读出后仅展示给用户本人
- 不要把 secret 写入文件、git、日志或发送到任何外部服务
- 用户只是随口提到某网站时，不要主动去查它的密码——先确认用户意图
