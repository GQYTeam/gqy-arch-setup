# GQYOS Shell Environment
# 为顾清影而造

# XDG 基础目录
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# 编辑器
export EDITOR="nvim"
export VISUAL="nvim"

# 语言
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Wayland / Hyprland
export XDG_SESSION_TYPE="wayland"
export XDG_CURRENT_DESKTOP="Hyprland"
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM="wayland"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export ELECTRON_OZONE_PLATFORM_HINT="auto"

# Fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi-height=20 --layout=reverse --border rounded"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

# Bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_THEME="Catppuccin Mocha"

# Zoxide
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"

# 重新定义家目录
export DOTFILES_DIR="$HOME/src/dotfiles"

# 本地 bin
export PATH="$HOME/.local/bin:$PATH"
