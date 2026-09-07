# Tmux 配置

## 配置文件

`~/.config/tmux/tmux.conf`

## GQYOS 默认配置

```conf
# 前缀键改为 Ctrl+a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Vim 风格导航
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# 鼠标支持
set -g mouse on

# 状态栏
set -g status-position bottom
set -g status-style 'bg=#1e1e2e fg=#cdd6f4'
```

## 常用命令

| 命令 | 功能 |
|------|------|
| `tmux new -s name` | 新建会话 |
| `tmux attach -t name` | 恢复会话 |
| `tmux ls` | 列出会话 |
| `tmux kill-session -t name` | 删除会话 |
| `Ctrl+a + d` | 断开会话 |
| `Ctrl+a + c` | 新建窗口 |
| `Ctrl+a + n/p` | 下/上一个窗口 |
| `Ctrl+a + ,` | 重命名窗口 |

## 快捷键 (GQYOS)

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+a + \|` | 水平分割 |
| `Ctrl+a + -` | 垂直分割 |
| `Ctrl+a + 方向键` | 切换面板 |
| `Ctrl+a + r` | 重新加载配置 |

## 插件管理

```bash
# TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 安装插件
Ctrl+a + I

# 常用插件
# tmux-resurrect: 会话持久化
# tmux-continuum: 自动保存/恢复
```
