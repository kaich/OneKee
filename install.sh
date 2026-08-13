#!/usr/bin/env bash
# OneKee CLI (`onekee`) 安装脚本
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install.sh | bash
#
# 行为：
#   1. 自动识别平台 (macOS / Linux) 与架构 (arm64 / x64)
#   2. 从 GitHub Release 拉取对应二进制（多代理 fallback，国内可加速）
#   3. 校验 SHA256（如 Release 提供 SHA256SUMS）
#   4. 安装到 ~/.local/bin/onekee（无需 sudo）

set -euo pipefail

OWNER="kaich"
REPO="OneKee"
BINARY_NAME="onekee"
INSTALL_DIR_USER="${HOME}/.local/bin"
LEGACY_INSTALL_PATH="/usr/local/bin/${BINARY_NAME}"
ONEKEE_INSTALL_TMP_DIR=""
ONEKEE_INSTALL_TMP_BIN=""

# ---------- 颜色 ----------
if [[ -t 1 ]]; then
  GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'
else
  GREEN=''; YELLOW=''; RED=''; CYAN=''; NC=''
fi

info()  { printf "${CYAN}[info]${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}[warn]${NC} %s\n" "$*"; }
error() { printf "${RED}[error]${NC} %s\n" "$*" >&2; }

# ---------- 安全清理 ----------
cleanup_install_tmp() {
  local tmp_dir="${ONEKEE_INSTALL_TMP_DIR:-}"
  local tmp_bin="${ONEKEE_INSTALL_TMP_BIN:-}"

  [[ -n "$tmp_dir" ]] || return 0

  case "$tmp_dir" in
    */onekee-install.*) ;;
    *)
      warn "临时目录路径异常，跳过清理: $tmp_dir"
      return 0
      ;;
  esac

  if [[ "$tmp_bin" != "${tmp_dir}/${BINARY_NAME}" ]]; then
    warn "临时文件路径异常，跳过清理: $tmp_bin"
    return 0
  fi

  if [[ -e "$tmp_bin" || -L "$tmp_bin" ]]; then
    if ! rm -f -- "$tmp_bin"; then
      warn "无法清理临时文件，已保留: $tmp_bin"
      return 0
    fi
  fi

  if [[ -d "$tmp_dir" ]] && ! rmdir -- "$tmp_dir" 2>/dev/null; then
    warn "临时目录非空，已保留以避免误删: $tmp_dir"
  fi
}

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
  local releases_url="https://github.com/${OWNER}/${REPO}/releases"
  local tag="" redirect_url

  redirect_url=$(curl -fsSL -o /dev/null -w '%{url_effective}' "${releases_url}/latest" 2>/dev/null || true)
  case "$redirect_url" in
    "${releases_url}/tag/"*)
      tag="${redirect_url#"${releases_url}/tag/"}"
      tag="${tag%%\?*}"
      tag="${tag%%\#*}"
      ;;
  esac

  if [[ -z "$tag" ]]; then
    error "无法从 GitHub Releases 解析最新版本，请稍后重试"
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
  info "OneKee CLI 安装脚本"

  local platform version asset_name asset_url installed_path resolved_command tmp_base tmp_template
  platform="$(detect_platform)"
  info "检测到平台: $platform"

  version="$(resolve_version)"
  info "最新版本: $version"

  asset_name="${BINARY_NAME}-${platform}"
  asset_url="https://github.com/${OWNER}/${REPO}/releases/download/${version}/${asset_name}"

  tmp_base="${TMPDIR:-/tmp}"
  tmp_base="${tmp_base%/}"
  if [[ -n "$tmp_base" ]]; then
    tmp_template="${tmp_base}/onekee-install.XXXXXX"
  else
    tmp_template="/onekee-install.XXXXXX"
  fi
  ONEKEE_INSTALL_TMP_DIR="$(mktemp -d "$tmp_template")"
  ONEKEE_INSTALL_TMP_BIN="${ONEKEE_INSTALL_TMP_DIR}/${BINARY_NAME}"
  trap cleanup_install_tmp EXIT

  if ! download_with_fallback "$asset_url" "$ONEKEE_INSTALL_TMP_BIN"; then
    error "所有下载源均失败，请检查网络后重试"
    exit 1
  fi

  chmod +x "$ONEKEE_INSTALL_TMP_BIN"
  mkdir -p "$INSTALL_DIR_USER"
  installed_path="${INSTALL_DIR_USER}/${BINARY_NAME}"
  if [[ -d "$installed_path" ]]; then
    error "安装目标是目录，无法覆盖: $installed_path"
    exit 1
  fi
  mv "$ONEKEE_INSTALL_TMP_BIN" "$installed_path"
  info "✅ 安装完成: ${installed_path}"

  "$installed_path" --help 2>/dev/null | head -1 || true

  case ":${PATH:-}:" in
    *":${INSTALL_DIR_USER}:"*) ;;
    *)
      warn "${INSTALL_DIR_USER} 尚未加入 PATH"
      warn "请添加到 shell 配置: export PATH=\"${INSTALL_DIR_USER}:\$PATH\""
      ;;
  esac

  if [[ -e "$LEGACY_INSTALL_PATH" || -L "$LEGACY_INSTALL_PATH" ]]; then
    warn "检测到旧的全局安装（未修改）: ${LEGACY_INSTALL_PATH}"
    resolved_command="$(command -v "$BINARY_NAME" 2>/dev/null || true)"
    if [[ -n "$resolved_command" && "$resolved_command" != "$installed_path" ]]; then
      warn "当前 PATH 可能仍优先使用: ${resolved_command}"
    fi
  fi
}

main "$@"
