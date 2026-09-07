#!/usr/bin/env bash

# ========== 脚本当前版本号 ========== #
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
VERSION_FILE="${GQY_VERSION_FILE:-$SCRIPT_DIR/version.json}"

if [[ ! -f "$VERSION_FILE" ]]; then
	printf '错误：找不到版本文件：%s\n' "$VERSION_FILE" >&2
	exit 1
fi

version="$(awk -F '"' '/"version"[[:space:]]*:/ { print $4; exit }' "$VERSION_FILE")"
if [[ -z "$version" ]]; then
	printf '错误：版本文件中缺少 version 字段：%s\n' "$VERSION_FILE" >&2
	exit 1
fi

if [[ ! "$version" =~ ^v[0-9]{2}\.(0[1-9]|1[0-2])\.(0[1-9]|[12][0-9]|3[01])$ ]]; then
	printf '错误：版本号不是有效的日期版本（vYY.MM.DD）：%s\n' "$version" >&2
	exit 1
fi

# ===== GQYOS 炫彩 logo（为顾清影而造）===== #
_GQYOS_LOGO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/asses"
if [[ -f "${_GQYOS_LOGO_DIR}/gqyos-logo-sunset.ansi" ]]; then
  cat "${_GQYOS_LOGO_DIR}/gqyos-logo-sunset.ansi"
else
  printf '  ____  _____   _____  ____\n / ___|/ _ \ \ / / _ \/ ___|\n| |  _| | | \ V / | | \___ \ \
| |_| | |_| || || |_| |___) |\n \____|\__\_\|_| \___/|____/\n'
fi

printf 'GQY Arch Setup %s\n' "$version"

if [[ "${1:-}" == "--version" ]]; then
	exit 0
fi



# ========= 克隆当前仓库到 tmp ========= #
git clone https://github.com/GQYTeam/gqy-arch-setup /tmp
cd tmp
