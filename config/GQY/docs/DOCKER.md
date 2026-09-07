# GQY 服务端 Docker 化与全平台瘦客户端

> 目标：把「整个 AI（顾清影）」跑在一个 Docker 容器里，终端 / 浏览器 /
> iOS / iPad / macOS / Windows / Linux / Android 都只做**瘦客户端**——
> 负责界面与收发消息，真正的智能（daemon + 回合循环 + 记忆 + 内置工具）全在
> 服务端。
>
> 架构：
> ```
>            ┌──────────────────────────────────────────┐
>            │  Docker 容器（GQY 服务端镜像）             │
>            │  ┌────────────────────────────────────┐  │
>            │  │  gqy __daemon  （AI 核心，前台）      │  │
>            │  │   · daemon / agent / LLM / 记忆     │  │
>            │  │   · SQLite + ~80 工具               │  │
>            │  │   · 内置 WebUI(HTTP + SSE/WS)       │  │
>            │  └────────────────────────────────────┘  │
>            └──────────────▲───────────────────────────┘
>                           │ HTTP :8300
>        ┌──────────────────┼──────────────────────────────┐
>        │                  │                              │
>   iOS/iPad  PWA    Android PWA    macOS / Windows / Linux
>   （添加到主屏幕）  （添加到主屏幕）   （浏览器 / 桌面 WebView 壳）
>   瘦客户端         瘦客户端          瘦客户端
> ```

## 为什么这样设计

GQY 本就是「单二进制 + daemon + 内置 HTTP/WebUI」的结构：

- `gqy __daemon --bind 0.0.0.0 --port 8300` 会在**前台**把 daemon、WebUI、
  IPC、平台传输全部拉起——这正是 Docker 容器要的**单进程模型**（配合 `tini`
  做 PID 1 信号转发与僵尸回收）。
- 内置 WebUI 使用**相对路径**的 `/api/*` 与 SSE/WebSocket 与后端通信，天然
  支持「浏览器 / PWA / 任意 WebView 从任意设备直连」。
- 因此无需在每台设备上装 LLM/记忆/工具——重活留在容器里，各端只做交互壳，
  这就是「AI 跑 Docker + 全平台瘦客户端」。

## 目录

| 文件 | 作用 |
| --- | --- |
| `Dockerfile` | 服务端镜像（多阶段：编译 → 精简运行） |
| `scripts/docker-entrypoint.sh` | 容器入口，转发 WebUI 密码等环境变量 |
| `docker-compose.yml` | 一键部署（持久化数据卷 + 健康检查） |
| `docs/CLIENTS.md` | 全平台瘦客户端落地路线（本阶段：PWA） |

## 构建镜像

```sh
# 本地
docker build -t gqy:latest .

# 或（CNB 流水线 v* tag 自动发布到制品库）
#   $CNB_DOCKER_REGISTRY/xynrin.ptt/GQY:<v*>
```

## 运行

### 方式一：docker run（单容器）

```sh
docker run -it --rm -p 8300:8300 \
  -e GQY_HOME=/data \
  -e GQY_WEB_PASSWORD='你的密码' \
  -v gqy-data:/data \
  gqy:latest
```

### 方式二：docker compose（推荐）

```sh
GQY_WEB_PASSWORD='你的密码' docker compose up -d
```

启动后，任意设备（手机 / 平板 / 电脑）浏览器打开
`http://<主机IP>:8300` 即得一个瘦客户端。

> 首次启动需在 WebUI「设置」里配置模型 API（OpenAI 兼容 / DeepSeek 等）。
> 数据（会话、记忆、日志、模型配置）持久化在 `gqy-data` 卷。

### 数据卷与备份

所有状态在 `$GQY_HOME`（默认 `/data`）。备份即备份该目录：

```sh
docker run --rm -v gqy-data:/data -v "$PWD":/backup alpine \
  tar -czf /backup/gqy-data.tar.gz -C /data .
```

## 环境变量

| 变量 | 默认 | 说明 |
| --- | --- | --- |
| `GQY_WEB_PASSWORD` | 空 | WebUI 登录密码（对外暴露务必设置） |
| `GQY_WEB_PORT` | 8300 | 监听端口 |
| `GQY_LANG` | auto | auto / zh / en |
| `GQY_HOME` | /data | 数据根目录 |

## 全平台瘦客户端（本阶段）

WebUI 已是标准的渐进式 Web 应用（PWA），自带 `manifest.webmanifest` 与图标：

- **iOS / iPad / Android**：Safari/Chrome 打开服务地址 → 分享/菜单 →
  「添加到主屏幕」，即以全屏 App 形态运行，等同瘦客户端；
- **macOS / Windows / Linux**：Chrome/Edge 打开后，地址栏安装按钮 →
  以窗口应用运行；也可用浏览器直接访问。

各平台原生壳（Tauri / Flutter / 系统 WebView 封装）的演进路线见
[`docs/CLIENTS.md`](CLIENTS.md)。
