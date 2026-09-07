# Arch Linux 包管理

## pacman 常用命令

```bash
# 同步并更新系统
sudo pacman -Syu

# 安装包
sudo pacman -S <package>

# 搜索包
pacman -Ss <keyword>

# 查看已安装包
pacman -Qs <keyword>

# 查看包信息
pacman -Qi <package>

# 删除包
sudo pacman -Rns <package>

# 清理无用依赖
sudo pacman -Rns $(pacman -Qtdq)

# 查看文件属于哪个包
pacman -Qo <file>

# 搜索本地文件
pacman -F <file>
```

## AUR (yay)

```bash
# 安装 yay
sudo pacman -S yay

# 搜索 AUR
yay -Ss <keyword>

# 安装 AUR 包
yay -S <package>

# 更新 AUR 包
yay -Sua
```

## 仓库配置

```bash
# /etc/pacman.conf
# 取消注启用 multilib (32位库)
[multilib]
Include = /etc/pacman.d/mirrorlist

# 添加 archlinuxcn 社区仓库
[archlinuxcn]
Server = https://mirrors.aliyun.com/archlinuxcn/$arch
```

## 镜像源

```bash
# 生成最优镜像列表
sudo pacman -S reflector
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```
