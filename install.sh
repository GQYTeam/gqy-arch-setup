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

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([+-][0-9A-Za-z.-]+)?$ ]]; then
	printf '错误：版本号不是有效的 SemVer：%s\n' "$version" >&2
	exit 1
fi

printf 'GQY Arch Setup %s\n' "$version"



# ========= 克隆当前仓库到 tmp ========= #
git clone https://github.com/GQYTeam/gqy-arch-setup /tmp
cd tmp
