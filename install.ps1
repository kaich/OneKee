# OneKee CLI (`onekee`) Windows 安装脚本
# Usage (PowerShell):
#   irm https://raw.githubusercontent.com/kaich/OneKee/main/install.ps1 | iex

$ErrorActionPreference = 'Stop'

$Owner = 'kaich'
$Repo  = 'OneKee'
$BinaryName = 'onekee'

function Write-Info($msg)  { Write-Host "[info] $msg" -ForegroundColor Cyan }
function Write-Warn($msg)  { Write-Host "[warn] $msg" -ForegroundColor Yellow }
function Write-Err($msg)   { Write-Host "[error] $msg" -ForegroundColor Red }

# ---------- 解析最新版本 ----------
try {
  $apiUrl = "https://api.github.com/repos/$Owner/$Repo/releases/latest"
  $release = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
  $version = $release.tag_name
} catch {
  Write-Err "无法获取最新版本号，请检查网络"
  exit 1
}
Write-Info "最新版本: $version"

# ---------- 构造下载地址 ----------
$arch = if ([Environment]::Is64BitOperatingSystem) { 'x64' } else { 'x86' }
$assetName = "$BinaryName-windows-$arch.exe"
$assetUrl  = "https://github.com/$Owner/$Repo/releases/download/$version/$assetName"

# ---------- 下载 ----------
$tmp = New-TemporaryFile
$tmpPath = "$tmp.exe"
Remove-Item $tmp -ErrorAction SilentlyContinue

Write-Info "下载: $assetUrl"
try {
  Invoke-WebRequest -Uri $assetUrl -OutFile $tmpPath -UseBasicParsing
} catch {
  Write-Err "下载失败: $_"
  exit 1
}

# ---------- 安装 ----------
$installDir = "$env:LOCALAPPDATA\Programs\OneKee"
if (-not (Test-Path $installDir)) {
  New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

$dest = Join-Path $installDir "$BinaryName.exe"
Move-Item $tmpPath $dest -Force

# ---------- 加入 PATH ----------
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath -notlike "*$installDir*") {
  [Environment]::SetEnvironmentVariable('Path', "$userPath;$installDir", 'User')
  Write-Info "已将 $installDir 加入用户 PATH"
}

Write-Info "✅ 安装完成: $dest"

# 自动注册 Chrome native messaging host（release 版自带商店扩展 id，零配置）。
# onekee connect chrome 复制 native host 可执行文件 + 写 NMH json + 写注册表（HKCU，无需管理员）。
if ($env:ONEKEE_SKIP_CHROME_CONNECT) {
  Write-Info "已跳过 Chrome NMH 注册（ONEKEE_SKIP_CHROME_CONNECT 已设置）"
} else {
  Write-Info "注册 Chrome native messaging host..."
  try {
    & $dest connect chrome | Out-Null
    Write-Info "✅ Chrome NMH 已注册（重启 Chrome 后 OneKee 扩展可连接桌面 app）"
  } catch {
    Write-Warn "Chrome NMH 自动注册失败，可稍后手动运行: $dest connect chrome"
  }
}

Write-Host ''
Write-Host '请重新打开 PowerShell / 终端使 PATH 生效，然后运行:'
Write-Host "  $BinaryName --help" -ForegroundColor Green
