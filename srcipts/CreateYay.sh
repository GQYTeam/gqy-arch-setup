#====================================》
# 作者：github/yxxbc
# 邮箱：xynrin@163.com
# 作用：为用户构建安装 yay
#====================================》

#!/usr/bin/env bash
set -Eeuo pipefail

# 1. 安装编译依赖 git + base‑devel
if ! sudo pacman -S --needed git base-devel; then
	printf '%s\n' '错误：安装 yay 编译依赖失败。' >&2
	exit 1
fi

# 2. 进入家目录克隆 yay 的 AUR 构建脚本
if ! git clone https://aur.archlinux.org/yay.git "$HOME/yay"; then
	printf '%s\n' '错误：克隆 yay 构建脚本失败。' >&2
	exit 1
fi

# 3. 进入目录
cd "$HOME/yay"

# 4. 编译并安装（不要sudo！）
if ! makepkg -si; then
	printf '%s\n' '错误：yay 编译或安装失败。' >&2
	exit 1
fi

if ! command -v yay >/dev/null 2>&1; then
	printf '%s\n' '错误：安装命令已返回成功，但找不到 yay 可执行文件。' >&2
	exit 1
fi

printf 'yay 安装成功：%s\n' "$(command -v yay)"

while true; do
	read -r -p "Delete the yay build directory? [Y/n]: " check_use
	case "$check_use" in
		""|y|Y|yes|YES|Yes)
			rm -rf "$HOME/yay"
			break
			;;
		n|N|no|NO|No)
			break
			;;
		*)
			printf '%s\n' '请输入 y/yes 或 n/no。'
			;;
	esac
done
