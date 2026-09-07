# GQYOS 配置参考

## 配置文件位置

安装后所有配置在 `~/.config/`：

| 路径 | 内容 |
|------|------|
| `~/.config/hypr/` | Hyprland 桌面 (6 个模块化 conf) |
| `~/.config/waybar/` | 状态栏 |
| `~/.config/kitty/` | 终端 |
| `~/.config/fuzzel/` | 启动器 |
| `~/.config/mako/` | 通知 |
| `~/.config/hyprlock/` | 锁屏 |
| `~/.config/hypridle/` | 电源管理 |
| `~/.config/hyprpaper/` | 壁纸 |
| `~/.config/tmux/` | Tmux |
| `~/.config/nvim/` | Neovim |
| `~/.config/yazi/` | 文件管理器 |
| `~/.config/git/` | Git 全局配置 |
| `~/.zshrc` | Zsh 别名/函数 |
| `~/.zshenv` | Zsh 环境变量 |

## Hyprland 模块化

```conf
# hyprland.conf 主文件
source = ~/.config/hypr/monitors.conf   # 显示器
source = ~/.config/hypr/theme.conf      # 主题/字体
source = ~/./config/hypr/keybindings.conf # 快捷键
source = ~/.config/hypr/windowrules.conf  # 窗口规则
source = ~/.config/hypr/autostart.conf    # 自启动
```

## 主题

全部使用 Catppuccin Mocha：

```bash
# 应用主题色到终端
export TERM=xterm-256color
```

## 自定义

编辑对应配置文件后重新加载：

```bash
# Hyprland
hyprctl reload

# Waybar
killall waybar && waybar &

# Tmux
tmux source ~/.config/tmux/tmux.conf
```
