# Arch Linux 系统管理

## systemd 服务

```bash
# 列出服务
systemctl list-units --type=service

# 启用/启动服务
sudo systemctl enable --now <service>

# 查看状态
systemctl status <service>

# 查看日志
journalctl -u <service> -f

# 查看启动时间
systemd-analyze
```

## 用户管理

```bash
# 创建用户
sudo useradd -m -G wheel,docker,audio,video -s /bin/zsh username

# 设置密码
sudo passwd username

# sudo 权限
sudo visudo
# 取消注释: %wheel ALL=(ALL:ALL) ALL
```

## 文件系统

```bash
# 查看磁盘
lsblk
df -h

# 挂载
mount /dev/sdX1 /mnt

# LUKS
cryptsetup luksFormat /dev/sdX2
cryptsetup open /dev/sdX2 name
cryptsetup close name

# LVM
pvdisplay
vgdisplay
lvdisplay
```

## 启动管理

```bash
# GRUB 配置
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 重新安装 GRUB
sudo grub-install --target=x86_64-efi --efi-directory=/boot

# initramfs
sudo mkinitcpio -P
```

## 日志

```bash
# 实时日志
journalctl -f

# 查看本次启动
journalctl -b

# 查看上次启动
journalctl -b -1

# 按优先级过滤
journalctl -p err

# 按时间过滤
journalctl --since "2026-09-07"
```
