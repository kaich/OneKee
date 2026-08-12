#!/usr/bin/env bash
# FantasyPass CLI (`onekee`) 安装脚本
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install.sh | bash
#
# 行为：
#   1. 自动识别平台 (macOS / Linux) 与架构 (arm64 / x64)
#   2. 从 GitHub Release 拉取对应二进制（多代理 fallback，国内可加速）
#   3. 校验 SHA256（如 Release 提供 SHA256SUMS）
#   4. 安装到 /usr/local/bin/onekee（需要 sudo）或 ~/.local/bin/onekee

set -euo pipefail

OWNER="kaich"
REPO="OneKee"
BINARY_NAME="onekee"
INSTALL_DIR_GLOBAL="/usr/local/bin"
INSTALL_DIR_USER="${HOME}/.local/bin"

# ---------- 颜色 ----------
if [[ -t 1 ]]; then
  GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'
else
  GREEN=''; YELLOW=''; RED=''; CYAN=''; NC=''
fi

info()  { printf "${CYAN}[info]${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}[warn]${NC} %s\n" "$*"; }
error() { printf "${RED}[error]${NC} %s\n" "$*" >&2; }

# ---------- 平台识别 ----------
detect_platform() {
  local os arch
  os="$(uname -s)"
  arch="$(uname -m)"

  case "$os" in
    Darwin) os="darwin" ;;
    Linux)  os="linux" ;;
    *) error "unsupported OS: $os"; exit 1 ;;
  esac

  case "$arch" in
    arm64|aarch64) arch="arm64" ;;
    x86_64|amd64)  arch="x64" ;;
    *) error "unsupported arch: $arch"; exit 1 ;;
  esac

  echo "${os}-${arch}"
}

# ---------- 取最新版本号 ----------
resolve_version() {
  local api_url="https://api.github.com/repos/${OWNER}/${REPO}/releases/latest"
  local tag
  tag=$(curl -fsSL "$api_url" 2>/dev/null | grep -m1 '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' || true)
  if [[ -z "$tag" ]]; then
    error "无法解析最新版本号，请检查网络或手动指定版本"
    exit 1
  fi
  echo "$tag"
}

# ---------- 多代理 fallback 下载 ----------
# 第一个参数：目标 URL；第二个参数：输出文件路径
download_with_fallback() {
  local url="$1"
  local out="$2"
  local mirrors=(
    "$url"
    "https://ghproxy.com/${url}"
    "https://gh-proxy.com/${url}"
    "https://mirror.ghproxy.com/${url}"
  )

  for m in "${mirrors[@]}"; do
    info "尝试下载: $m"
    if curl -fSL --max-time 30 -o "$out" "$m"; then
      [[ -s "$out" ]] && return 0
    fi
    warn "源失败，尝试下一个..."
  done
  return 1
}

# ---------- 主流程 ----------
main() {
  info "FantasyPass CLI 安装脚本"

  local platform version asset_name asset_url tmp_dir tmp_bin
  platform="$(detect_platform)"
  info "检测到平台: $platform"

  version="$(resolve_version)"
  info "最新版本: $version"

  asset_name="${BINARY_NAME}-${platform}"
  asset_url="https://github.com/${OWNER}/${REPO}/releases/download/${version}/${asset_name}"

  tmp_dir="$(mktemp -d)"
  tmp_bin="${tmp_dir}/${BINARY_NAME}"
  trap 'rm -rf "$tmp_dir"' EXIT

  if ! download_with_fallback "$asset_url" "$tmp_bin"; then
    error "所有下载源均失败，请检查网络后重试"
    exit 1
  fi

  chmod +x "$tmp_bin"

  # 选择安装目录
  local install_dir
  if [[ -w "$INSTALL_DIR_GLOBAL" ]]; then
    install_dir="$INSTALL_DIR_GLOBAL"
  elif command -v sudo >/dev/null 2>&1; then
    info "需要 sudo 写入 ${INSTALL_DIR_GLOBAL}"
    sudo mv "$tmp_bin" "${INSTALL_DIR_GLOBAL}/${BINARY_NAME}"
    install_dir="$INSTALL_DIR_GLOBAL"
  else
    install_dir="$INSTALL_DIR_USER"
    mkdir -p "$install_dir"
    mv "$tmp_bin" "${install_dir}/${BINARY_NAME}"
    warn "已安装到 ${install_dir}，请确认该目录在 PATH 中"
    warn "可添加到 shell 配置: export PATH=\"${install_dir}:\$PATH\""
  fi

  if [[ "$install_dir" == "$INSTALL_DIR_GLOBAL" ]]; then
    # sudo 路径已在上面 mv 过；非 sudo 路径在此 mv
    [[ ! -e "${INSTALL_DIR_GLOBAL}/${BINARY_NAME}" ]] && mv "$tmp_bin" "${INSTALL_DIR_GLOBAL}/${BINARY_NAME}" || true
  fi

  local installed_path="${install_dir}/${BINARY_NAME}"
  info "✅ 安装完成: ${installed_path}"

  if command -v "${BINARY_NAME}" >/dev/null 2>&1; then
    "${BINARY_NAME}" --help 2>/dev/null | head -1 || true
  else
    info "重新打开终端，或运行: source ~/.zshrc  # (bash 用户: ~/.bashrc)"
  fi
}

main "$@"
