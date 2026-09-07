# GQYOS 安装指南

## 从 ISO 安装

### 准备

1. 下载 GQYOS ISO 从 GitHub Releases
2. 写入 U盘：`sudo dd if=GQYOS-*.iso of=/dev/sdX bs=4M status=progress`
3. 从 U盘启动 (UEFI 模式)

### 安装步骤

```bash
# 1. 确认网络
ping archlinux.org

# 2. 运行安装器
sudo gqyos-install

# 3. 选择安装模式
#    - Hyprland Workstation (推荐)
#    - Minimal CLI
#    - VirtualBox Workstation

# 4. 等待安装完成，重启

# 5. 登录后部署桌面
install.sh  # 位于 gqy-arch-setup/
```

### 安装后配置

```bash
# Ollama (本地 LLM)
ollama pull qwen3:14b

# GQY AI Agent
docker compose up -d  # 在 gqy-arch-setup/config/GQY/
```

## 注意事项

- 安装器会**清空整块目标磁盘**
- LUKS2 加密密码丢失 = 数据丢失
- 不支持双系统
- 建议先在 VirtualBox 测试
