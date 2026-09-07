#!/bin/sh
# GQY Docker 容器入口：以 daemon 前台形态启动整个 AI（WebUI + 回合循环），
# 供各平台瘦客户端接入。默认监听 0.0.0.0:8300。
#
# 环境变量：
#   GQY_WEB_PASSWORD   WebUI 登录密码（容器内建议必设，否则 LAN 内无鉴权）
#   GQY_WEB_PORT        监听端口，默认 8300
#   GQY_LANG            auto / zh / en
set -e

PORT="${GQY_WEB_PORT:-8300}"

# 确保数据目录可写
mkdir -p "${GQY_HOME:-/data}"
chmod 700 "${GQY_HOME:-/data}"

ARGS="__daemon --port ${PORT} --bind 0.0.0.0"

if [ -n "${GQY_WEB_PASSWORD}" ]; then
  # 用 password_file 传递，避免密码进入 ps 可见的命令行
  PWFILE="${GQY_HOME:-/data}/web.password"
  printf '%s' "${GQY_WEB_PASSWORD}" > "${PWFILE}"
  chmod 600 "${PWFILE}"
  ARGS="${ARGS} --password-file ${PWFILE}"
  echo "[gqy] WebUI 已启用密码鉴权，端口 ${PORT}，监听 0.0.0.0"
else
  echo "[gqy] 警告：未设置 GQY_WEB_PASSWORD，WebUI 无鉴权（仅适合可信内网/本机）"
fi

echo "[gqy] 启动 GQY AI 服务端（daemon 前台模式）..."
echo "[gqy] 瘦客户端接入地址：http://0.0.0.0:${PORT}/  （浏览器 / PWA / 各端 WebView）"
exec gqy ${ARGS}
