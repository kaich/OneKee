---
name: onekee-cli
description: 通过 OneKee CLI（onekee 命令）为用户查询和填充密码库条目。当用户要求"查一下 XX 的密码"、"我的 GitHub 密码是多少"、"帮我打开 XX 的登录页"、"把这个 secret 给我"等涉及凭证查询的操作时使用。前置：用户已安装 OneKee 桌面端、Chrome 扩展与 onekee CLI，并完成配对。
---

# OneKee CLI 密码查询

## 前置条件（缺一不可，先检查再操作）

本 skill 依赖 OneKee 三件套协同工作：

1. **OneKee 桌面端 App** — 密码库本体与本地 Broker，必须处于**已解锁运行**状态
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
- 无输出 → 提示用户：**先启动并解锁 OneKee 桌面端 App**

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

## AccessKey 从哪来

AccessKey 在 **OneKee 桌面端 App 内生成**（设置中查看）。如果用户不知道 AccessKey：

1. 让用户打开 OneKee 桌面端
2. 在设置里找到 Access Key
3. 建议用户通过环境变量提供，避免明文留在会话记录里：
   ```bash
   export ONEKEE_ACCESS_KEY=<key>   # 用户自己执行
   ```

**不要把 AccessKey 写进任何文件、提交或日志。**

## 首次配对（仅一次）

CLI 第一次使用时需要跟桌面端配对：

```bash
onekee pair
```

流程：CLI 发起 → 用户在**桌面端「设置 > 设备管理」**查看 6 位配对码 → 按提示输入 → 完成。已受信设备重复配对会自动跳过。

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
| `failed to connect broker` / ConnectFailed | 桌面端没开或没解锁 | 让用户启动并解锁桌面端 |
| `LOCKED` / `locked` | 密码库锁定中 | 让用户在桌面端解锁 |
| `NOT_FOUND` | 条目不存在 | 换关键词重新 resolve |
| LAN 场景提示「应用并重启 Broker」 | 远程 Broker 需重启 | 让用户在桌面端点「应用并重启 Broker」 |

## 安全红线

- 密码/secret 字段**只在用户明确要求时**读取，读出后仅展示给用户本人
- 不要把 secret 写入文件、git、日志或发送到任何外部服务
- 用户只是随口提到某网站时，不要主动去查它的密码——先确认用户意图
