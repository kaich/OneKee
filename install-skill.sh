#!/usr/bin/env bash
# OneKee AI 助手 Skill 安装脚本（Claude Code / Codex）
#
# 用法（必须显式指定装到哪个助手，脚本不会自动安装）：
#   curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install-skill.sh | bash -s -- --claude
#   curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install-skill.sh | bash -s -- --codex
#   curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install-skill.sh | bash -s -- --claude --codex
#
# 重复执行会覆盖旧版本，可用于升级。

set -euo pipefail

SKILL_URL="https://raw.githubusercontent.com/kaich/OneKee/main/skills/onekee-cli/SKILL.md"
SKILL_NAME="onekee-cli"

GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'
info() { printf "${CYAN}[info]${NC} %s\n" "$*"; }
ok()   { printf "${GREEN}[ok]${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}[warn]${NC} %s\n" "$*"; }
err()  { printf "${RED}[error]${NC} %s\n" "$*" >&2; }

usage() {
  cat <<'EOF'
OneKee AI 助手 Skill 安装脚本

必须显式指定目标助手（不会自动安装）：

  --claude   安装到 ~/.claude/skills/onekee-cli/   (Claude Code)
  --codex    安装到 ~/.codex/skills/onekee-cli/    (Codex)

示例：
  curl -fsSL https://raw.githubusercontent.com/kaich/OneKee/main/install-skill.sh | bash -s -- --claude
EOF
}

# ---------- 解析参数：不传参 = 只显示用法，不安装 ----------
install_claude=false
install_codex=false
for arg in "$@"; do
  case "$arg" in
    --claude) install_claude=true ;;
    --codex)  install_codex=true ;;
    -h|--help) usage; exit 0 ;;
    *) err "未知参数: $arg"; usage; exit 1 ;;
  esac
done

if [[ "$install_claude" == false && "$install_codex" == false ]]; then
  usage
  exit 1
fi

command -v curl >/dev/null 2>&1 || { err "需要 curl，请先安装"; exit 1; }

# ---------- 下载到临时文件 ----------
tmp_skill="$(mktemp)"
trap 'rm -f "$tmp_skill"' EXIT
info "下载 skill: $SKILL_URL"
if ! curl -fsSL --max-time 30 -o "$tmp_skill" "$SKILL_URL"; then
  err "下载失败，请检查网络后重试"
  exit 1
fi
[[ -s "$tmp_skill" ]] || { err "下载内容为空"; exit 1; }

# ---------- 安装（只装显式指定的目标） ----------
if [[ "$install_claude" == true ]]; then
  mkdir -p "$HOME/.claude/skills/$SKILL_NAME"
  cp "$tmp_skill" "$HOME/.claude/skills/$SKILL_NAME/SKILL.md"
  ok "Claude Code: $HOME/.claude/skills/$SKILL_NAME/SKILL.md"
fi

if [[ "$install_codex" == true ]]; then
  mkdir -p "$HOME/.codex/skills/$SKILL_NAME"
  cp "$tmp_skill" "$HOME/.codex/skills/$SKILL_NAME/SKILL.md"
  ok "Codex: $HOME/.codex/skills/$SKILL_NAME/SKILL.md"
fi

echo ""
ok "✅ 安装完成。现在可以对 AI 助手说："
echo "   「查一下我的 GitHub 密码」"
echo ""
info "前置条件：OneKee 桌面端 + Chrome 扩展 + onekee CLI 三件套（浏览器填充缺一不可）"
info "详见: https://github.com/kaich/OneKee"
