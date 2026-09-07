# GQYOS 日常运维

## 系统更新

```bash
# 滚动更新 Arch Linux
sudo pacman -Syu

# 更新 AUR 包
yay -Sua
```

## GQY AI Agent 管理

```bash
# 查看状态
docker ps | grep gqy

# 重启
docker compose restart

# 查看日志
docker compose logs -f

# 更新
docker compose pull && docker compose up -d
```

## 备份

```bash
# 备份配置
tar czf gqyos-config-backup.tar.gz ~/.config/

# 备份 GQY 数据
docker compose exec gqy tar czf /tmp/gqy-data.tar.gz /app/data
docker cp gqy:/tmp/gqy-data.tar.gz ./
```

## 诊断

```bash
# Hyprland 日志
hyprctl clients

# 系统日志
journalctl -b -p err

# 磁盘空间
df -h

# LUKS 状态
lsblk
```
