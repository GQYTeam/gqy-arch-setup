# GQYOS 系统概述

## 系统架构

GQYOS 是一个基于 Arch Linux 的个人 AI 系统，为顾清影量身定制。

```
GQYOS
├── live-setup/        # 安装器 (Arch Linux Live 环境)
│   └── install-arch.sh    # LUKS2 + LVM + GRUB + Hyprland
├── gqy-arch-setup/    # 桌面配置与安装后设置
│   ├── install.sh         # 一键部署脚本
│   └── config/            # 全部配置文件
└── iso/               # ISO 构建 (archiso)
    └── profile/           # archiso profile
```

## 安装流程

1. 从 GQYOS ISO 启动 (archiso 构建)
2. 运行 `sudo gqyos-install`
3. 自动完成：磁盘分区 → LUKS2 加密 → LVM → GRUB → pacstrap → 用户创建
4. 重启后运行 `install.sh` 部署桌面环境

## 技术栈

| 组件 | 选型 |
|------|------|
| 发行版 | Arch Linux (滚动更新) |
| 桌面 | Hyprland (Wayland) |
| 终端 | Kitty |
| Shell | Zsh + Oh My Zsh |
| 编辑器 | Neovim |
| AI | GQY (Rust, Docker) + Ollama |
| 主题 | Catppuccin Mocha |
| 加密 | LUKS2 + LVM |
| 引导 | GRUB (UEFI) |
| ISO | archiso |

## 版本格式

`vYY.MM.DD` — 当前版本：`v26.09.07`
