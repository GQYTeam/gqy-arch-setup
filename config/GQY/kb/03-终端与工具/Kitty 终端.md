# Kitty 终端配置

## 配置文件

`~/.config/kitty/kitty.conf`

## 常用配置

```conf
# 字体
font_family      JetBrainsMono Nerd Font
font_size        13.0
bold_font        auto
italic_font      auto

# 光标
cursor_shape     block
cursor_blink_interval 0

# 滚动
scrollback_lines 10000

# 窗口
remember_window_size yes
initial_window_width  120c
initial_window_height 36c

# Tab 栏
tab_bar_edge     bottom
tab_bar_style    powerline
tab_powerline_style round
```

## 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Shift+T` | 新建标签页 |
| `Ctrl+Shift+Q` | 关闭标签页 |
| `Ctrl+Shift+→` | 下一个标签页 |
| `Ctrl+Shift+←` | 上一个标签页 |
| `Ctrl+Shift+Enter` | 新建窗口 |
| `Ctrl+Shift+C` | 复制到剪贴板 |
| `Ctrl+Shift+V` | 从剪贴板粘贴 |
| `Ctrl+Shift+F5` | 重新加载配置 |
| `Ctrl+Shift+Equal` | 字体增大 |
| `Ctrl+Shift+Minus` | 字体减小 |

## 图片显示

```bash
# Kitty 支持终端内显示图片
kitty +kitten icat image.png

# 查看文件
kitty +kitten diff file1 file2
```

## 故障排查

```bash
# 检查配置
kitty --config NONE  # 使用默认配置

# 查看日志
cat ~/.cache/kitty/kitty-*.log
```
