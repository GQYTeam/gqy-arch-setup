#!/usr/bin/env bash
# GQYOS Desktop Setup - 安装脚本
# 为顾清影而造
#
# 在已安装的 Arch Linux 系统上运行，配置 Hyprland 桌面环境。
# 前提：已通过 live-setup 安装器完成基础系统安装。
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
VERSION_FILE="${GQY_VERSION_FILE:-$SCRIPT_DIR/version.json}"

# ========== 版本检查 ========== #
if [[ -f "$VERSION_FILE" ]]; then
  version="$(awk -F '"' '/"version"[[:space:]]*:/ { print $4; exit }' "$VERSION_FILE")"
  if [[ -n "$version" ]]; then
    printf 'GQYOS Desktop Setup %s\n' "$version"
  fi
fi

if [[ "${1:-}" == "--version" ]]; then
  exit 0
fi

# ========== 前提检查 ========== #
if [[ $EUID -eq 0 ]]; then
  printf '错误：请不要以 root 身份运行此脚本。\n' >&2
  exit 1
fi

if ! command -v hyprctl >/dev/null 2>&1; then
  printf '错误：未检测到 Hyprland。请先通过安装器安装桌面模式。\n' >&2
  exit 1
fi

# ========== 颜色输出 ========== #
info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()    { printf '\033[1;32m ==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m警告：\033[0m %s\n' "$*" >&2; }

# ========== 安装额外工具 ========== #
install_extras() {
  info "安装额外工具..."

  local extra_packages=(
    cliphist        # 剪贴板历史
    brightnessctl   # 亮度控制
    playerctl       # 媒体控制
    nm-applet       # 网络托盘
    blueman-applet  # 蓝牙托盘 (blueman)
    docker          # 容器运行时 (GQY)
    docker-compose  # Docker Compose
  )

  # 跳过已安装的
  local to_install=()
  for pkg in "${extra_packages[@]}"; do
    if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
      to_install+=("$pkg")
    fi
  done

  if [[ ${#to_install[@]} -gt 0 ]]; then
    info "安装: ${to_install[*]}"
    sudo pacman -S --needed --noconfirm "${to_install[@]}"
  fi

  ok "额外工具就绪"
}

# ========== 配置文件部署 ========== #
deploy_configs() {
  info "部署配置文件..."

  local config_dir="$SCRIPT_DIR/config"
  local home="${HOME}"
  local hypr_dir="$home/.config/hypr"

  # 创建目录
  mkdir -p "$hypr_dir/wallpaper"
  mkdir -p "$home/.config/waybar"
  mkdir -p "$home/.config/kitty"
  mkdir -p "$home/.config/fuzzel"
  mkdir -p "$home/.config/mako"
  mkdir -p "$home/.config/hyprlock"
  mkdir -p "$home/.config/hypridle"
  mkdir -p "$home/.config/hyprpaper"

  # Hyprland 配置
  cp -f "$config_dir/hypr/hyprland.conf"   "$hypr_dir/hyprland.conf"
  cp -f "$config_dir/hypr/monitors.conf"   "$hypr_dir/monitors.conf"
  cp -f "$config_dir/hypr/theme.conf"      "$hypr_dir/theme.conf"
  cp -f "$config_dir/hypr/keybindings.conf" "$hypr_dir/keybindings.conf"
  cp -f "$config_dir/hypr/windowrules.conf" "$hypr_dir/windowrules.conf"
  cp -f "$config_dir/hypr/autostart.conf"  "$hypr_dir/autostart.conf"

  # Waybar
  cp -f "$config_dir/waybar/config.jsonc" "$home/.config/waybar/config.jsonc"
  cp -f "$config_dir/waybar/style.css"    "$home/.config/waybar/style.css"

  # Kitty
  cp -f "$config_dir/kitty/kitty.conf" "$home/.config/kitty/kitty.conf"

  # Fuzzel
  cp -f "$config_dir/fuzzel/fuzzel.ini" "$home/.config/fuzzel/fuzzel.ini"

  # Mako
  cp -f "$config_dir/mako/config" "$home/.config/mako/config"

  # Hyprlock
  cp -f "$config_dir/hyprlock/hyprlock.conf" "$home/.config/hyprlock/hyprlock.conf"

  # Hypridle
  cp -f "$config_dir/hypridle/hypridle.conf" "$home/.config/hypridle/hypridle.conf"

  # Hyprpaper + 壁纸
  cp -f "$config_dir/hyprpaper/hyprpaper.conf" "$home/.config/hyprpaper/hyprpaper.conf"

  # Tmux
  mkdir -p "$home/.config/tmux"
  cp -f "$config_dir/tmux/tmux.conf" "$home/.config/tmux/tmux.conf"

  # Neovim
  mkdir -p "$home/.config/nvim"
  cp -f "$config_dir/nvim/init.vim" "$home/.config/nvim/init.vim"

  # Yazi
  mkdir -p "$home/.config/yazi"
  cp -f "$config_dir/yazi/yazi.toml" "$home/.config/yazi/yazi.toml"

  # Git
  cp -f "$config_dir/git/gitconfig" "$home/.gitconfig"

  # Shell
  cp -f "$config_dir/shell/zshrc"    "$home/.zshrc"
  cp -f "$config_dir/shell/zshenv"   "$home/.zshenv"

  # 壁纸文件
  local wallpaper_src="$SCRIPT_DIR/../../asses/wallpaper"
  if [[ -d "$wallpaper_src" ]]; then
    cp -f "$wallpaper_src"/*.png "$hypr_dir/wallpaper/" 2>/dev/null || true
  elif [[ -d "$SCRIPT_DIR/wallpaper" ]]; then
    cp -f "$SCRIPT_DIR/wallpaper"/*.png "$hypr_dir/wallpaper/" 2>/dev/null || true
  fi

  ok "配置文件已部署到 ~/.config/"
}

# ========== 字体安装 ========== #
install_fonts() {
  info "检查字体..."

  local font_packages=(
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ttf-jetbrains-mono-nerd
  )

  local to_install=()
  for pkg in "${font_packages[@]}"; do
    if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
      to_install+=("$pkg")
    fi
  done

  if [[ ${#to_install[@]} -gt 0 ]]; then
    info "安装字体: ${to_install[*]}"
    sudo pacman -S --needed --noconfirm "${to_install[@]}"
  fi

  ok "字体就绪"
}

# ========== 输入法 (可选) ========== #
setup_input_method() {
  if [[ "${INSTALL_FCTIX5:-}" == "1" ]]; then
    info "安装 Fcitx5 输入法..."
    sudo pacman -S --needed --noconfirm \
      fcitx5-im fcitx5-chinese-addons fcitx5-configtool
    ok "Fcitx5 已安装，请手动配置环境变量"
  fi
}

# ========== 主流程 ========== #
main() {
  printf '\n'
  printf '  ╔══════════════════════════════════╗\n'
  printf '  ║   GQYOS 桌面环境配置             ║\n'
  printf '  ║   为顾清影而造                   ║\n'
  printf '  ╚══════════════════════════════════╝\n'
  printf '\n'

  install_extras
  install_fonts
  deploy_configs
  setup_input_method

  # Neovim 插件管理器
  if [[ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]]; then
    info "安装 vim-plug..."
    curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null || true
    info "运行 :PlugInstall 安装 Neovim 插件"
  fi

  # AI 工具
  if ! command -v ollama >/dev/null 2>&1; then
    info "安装 Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
    ok "Ollama 已安装"
  else
    ok "Ollama 已存在"
  fi

  # GQY (AI Agent) — Docker 部署
  local gqy_src="$SCRIPT_DIR/config/GQY"
  if [[ -f "$gqy_src/docker-compose.yml" ]]; then
    if command -v docker >/dev/null 2>&1; then
      # 确保 Docker 服务运行
      systemctl is-active --quiet docker || sudo systemctl start docker
      systemctl is-enabled --quiet docker || sudo systemctl enable docker

      if ! docker ps -a --format '{{.Names}}' | grep -q '^gqy$'; then
        info "构建并启动 GQY 容器..."
        (cd "$gqy_src" && GQY_WEB_PASSWORD="" docker compose up -d) || warn "GQY 启动失败，跳过"
        ok "GQY 容器已启动，WebUI: http://localhost:8300"
      else
        ok "GQY 容器已存在"
      fi
    else
      warn "Docker 未安装，跳过 GQY 部署"
    fi
  fi

  printf '\n'
  ok "GQYOS 桌面配置完成！"
  printf '\n'
  info "运行 'Hyprland' 或注销后选择 Hyprland 会话启动桌面"
  info "默认快捷键：SUPER+Return 打开终端, SUPER+Space 启动器"
  printf '\n'
}

main "$@"
