#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
installer_copy="$(mktemp)"
trap 'rm -f "$installer_copy"' EXIT

# Load the real installer functions without executing its main entry point.
sed '/^main "\$@"$/d' "$repo_dir/install.sh" > "$installer_copy"
# shellcheck source=/dev/null
source "$installer_copy"

curl() {
  case "$*" in
    *"api.github.com/repos/kaich/OneKee/releases/latest"*)
      printf '%s' '{"tag_name":"cli-v9.9.9"}'
      ;;
    *"github.com/kaich/OneKee/releases/latest"*)
      printf '%s' 'https://github.com/kaich/OneKee/releases/tag/cli-v0.1.0'
      ;;
    *)
      printf 'unexpected curl invocation: %s\n' "$*" >&2
      return 1
      ;;
  esac
}

actual="$(resolve_version)"

if [[ "$actual" != "cli-v0.1.0" ]]; then
  printf 'expected cli-v0.1.0, got %s\n' "$actual" >&2
  exit 1
fi

printf 'install.sh tests passed\n'
