# GQY AI Agent

## 概述

GQY 是用 Rust 编写的桌面 AI 助手，Docker 部署，内置 WebUI。

## Docker 部署

```bash
# 进入 GQY 目录
cd ~/.config/GQY

# 启动
docker compose up -d

# 查看状态
docker ps | grep gqy

# 查看日志
docker compose logs -f

# 停止
docker compose down

# 重启
docker compose restart

# 更新
docker compose pull && docker compose up -d
```

## WebUI

- 地址: http://localhost:8300
- 支持浏览器、PWA、WebView 访问

## 配置

```bash
# 配置文件
~/.config/GQY/config.toml

# 主要配置项
[llm]
default_provider = "openai"
api_key = "..."
model = "gpt-4"

[persona]
name = "GQY"
```

## 命令行

```bash
# 直接对话
gqy "你好"

# REPL 模式
gqy

# 启动 daemon
gqy __daemon
```

## 故障排查

```bash
# Docker 状态
docker ps -a

# 容器日志
docker logs gqy

# 进入容器
docker exec -it gqy bash

# 数据目录
~/.local/share/gqy/
```
