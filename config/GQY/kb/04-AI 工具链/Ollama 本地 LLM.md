# Ollama 本地 LLM

## 安装

```bash
# 安装 Ollama
curl -fsSL https://ollama.com/install.sh | sh

# 验证
ollama --version
```

## 常用命令

```bash
# 拉取模型
ollama pull qwen3:14b
ollama pull deepseek-coder:6.7b

# 列出已下载模型
ollama list

# 运行模型
ollama run qwen3:14b

# 查看正在运行的模型
ollama ps

# 停止所有模型
ollama stop

# 删除模型
ollama rm qwen3:14b
```

## API

```bash
# Ollama 默认监听 http://localhost:11434

# 生成文本
curl http://localhost:11434/api/generate -d '{
  "model": "qwen3:14b",
  "prompt": "你好"
}'

# 聊天
curl http://localhost:11434/api/chat -d '{
  "model": "qwen3:14b",
  "messages": [
    {"role": "user", "content": "你好"}
  ]
}'
```

## GQYOS 推荐模型

| 模型 | 用途 | 显存需求 |
|------|------|----------|
| qwen3:14b | 通用对话 | 8GB |
| deepseek-coder:6.7b | 编程辅助 | 4GB |
| llama3.1:8b | 英文对话 | 4GB |
| qwen3:4b | 轻量对话 | 2GB |

## 故障排查

```bash
# 查看日志
journalctl -u ollama -f

# 重启服务
sudo systemctl restart ollama

# 检查 GPU
nvidia-smi  # NVIDIA
rocm-smi    # AMD
```
