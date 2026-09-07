# GQYOS ISO 构建

## 构建方式

### 本地构建

需要 Arch Linux 环境：

```bash
sudo pacman -S archiso
sudo ./iso/build-iso.sh
```

ISO 输出到 `iso/out/` 目录。

### CI 自动构建

推送 `v*` tag 触发 GitHub Actions：

```bash
git tag v26.09.07
git push origin v26.09.07
```

自动完成：archiso 构建 → SHA256 校验 → 上传 Artifact → 创建 Release

## ISO 内容

| 组件 | 说明 |
|------|------|
| 引导 | GRUB (UEFI) |
| 安装器 | gqyos-install → live-setup |
| Live 用户 | root (免密) |
| 网络 | NetworkManager + iwd |
| 字体 | Noto (中日韩 + Emoji) |

## archiso Profile 结构

```
iso/profile/
├── profiledef.sh       # ISO 元数据
├── packages.x86_64     # 包列表
├── grub/               # GRUB 引导配置
└── airootfs/           # 注入根文件系统的文件
    ├── usr/local/bin/  # gqyos-install, gqyos-docs
    ├── etc/            # sudoers, NetworkManager, systemd
    └── root/           # 登录欢迎脚本
```

## 写入 U盘

```bash
# dd
sudo dd if=out/GQYOS-*.iso of=/dev/sdX bs=4M status=progress

# Ventoy
# 直接拷贝 ISO 到 Ventoy U盘
```
