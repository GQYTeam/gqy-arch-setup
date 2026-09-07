# Neovim 配置

## 配置文件

`~/.config/nvim/init.vim`

## GQYOS 默认配置

- 主题: Catppuccin Mocha
- 插件管理: vim-plug
- 状态栏: lualine
- 模糊搜索: telescope
- Git 集成: gitsigns

## 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| `Space` | Leader 键 |
| `Space + ff` | 文件搜索 |
| `Space + fg` | 全局搜索 |
| `Space + /` | 当前文件搜索 |
| `Space + ee` | 文件浏览器 |
| `Space + gs` | Git 状态 |
| `K` | 悬浮文档 |
| `gd` | 跳转到定义 |
| `gr` | 查看引用 |
| `Ctrl+n` | 文件树切换 |

## 插件列表

```vim
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'lewis6991/gitsigns.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
```

## 重新加载

```vim
:source ~/.config/nvim/init.vim
```

## 故障排查

```bash
# 检查健康状态
nvim +checkhealth

# 查看日志
nvim ~/.local/state/nvim/log
```
