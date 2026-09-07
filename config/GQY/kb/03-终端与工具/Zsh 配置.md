# Zsh 配置

## 配置文件

- `~/.zshenv` — 环境变量 (最先加载)
- `~/.zshrc` — 别名、插件、提示符

## GQYOS 默认配置

```bash
# .zshenv
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export EDITOR="nvim"
export VISUAL="nvim"
export BAT_THEME="Catppuccin Mocha"
export FZF_DEFAULT_OPTS="..."
```

## 常用别名 (GQYOS)

```bash
ls="eza --icons --group-directories-first"
ll="eza -la --icons --group-directories-first"
cat="bat --style=plain"
find="fd"
grep="rg"
top="btop"
editor="nvim"
```

## 插件

GQYOS 使用 Oh My Zsh + 以下插件：

| 插件 | 功能 |
|------|------|
| zsh-autosuggestions | 命令建议 |
| zsh-syntax-highlighting | 语法高亮 |
| zsh-completions | 补全增强 |

## 重新加载

```bash
source ~/.zshrc
```

## 故障排查

```bash
# 查看当前 shell
echo $SHELL

# 重新安装插件
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
```
