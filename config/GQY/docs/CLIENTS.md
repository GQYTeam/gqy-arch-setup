# 全平台瘦客户端落地路线（Roadmap）

> 「AI 跑在 Docker」之后，本仓库以**内置 WebUI 即 PWA** 为通用接入点，
> 各端均为指向服务端地址的瘦客户端。这里说明现状与本阶段的交付，以及后续
> 原生壳的演进方向。请结合实际发布约束（签名、商店、审核）分阶段推进。

## 交付现状（本阶段）

| 能力 | 状态 | 说明 |
| --- | --- | --- |
| AI 服务端 Docker 镜像 | ✅ 新增 | `Dockerfile` + `docker-compose.yml`，CNB `v*` tag 自动发布 |
| 发布 Docker 制品 | ✅ 新增 | `.cnb.yml` tag 事件构建推送镜像到 CNB 制品库 |
| WebUI 瘦客户端（通用） | ✅ 已有 | 相对路径 `/api/*` + SSE/WS，任意设备浏览器直连 |
| PWA 安装（iOS/iPad/Android/桌面） | ✅ 新增 | `manifest.webmanifest` + 图标，添加到主屏幕即全屏 App |
| macOS/Windows/Linux 二进制 | ✅ 已有 | CNB Release 现有双架构 macOS + Linux 预编译资产 |
| iOS / iPad 原生壳 | 🚧 规划 | 需 Apple 开发者签名 + App Store（见下） |
| Android 原生壳 | 🚧 规划 | 需 AAB 打包签名，Play 或侧载 |
| Windows / Linux 桌面壳 | 🚧 规划 | Tauri/Electron/系统 WebView 封装 |

## 全平台怎么连「瘦客户端」

所有瘦客户端本质上是同一件事：**打开一个指向 `http://<docker-host>:8300/`
的界面，并与之走 HTTP + SSE/WS**。GQY 的服务端 API 已是公开的 HTTP 接口
（`/api/...`），因此：

| 平台 | 本阶段（零原生开发） | 后续演进（原生体验） |
| --- | --- | --- |
| iOS / iPadOS | Safari「添加到主屏幕」(PWA) | Swift/WebKit WKWebView 壳，或小程序/React Native |
| Android | Chrome「添加到主屏幕」(PWA) | Android WebView 壳 / TWA，或 Flutter |
| macOS | Chrome/Edge 安装 PWA；已有 `brew install gqy` 本地版 | Swift + WKWebView，或 Tauri |
| Windows | Edge/Chrome PWA；后续可下 Windows 二进制 | Tauri / Electron 壳 |
| Linux | 浏览器 PWA；已有 Linux 预编译二进制 | Tauri / 系统 WebView |
| 终端 | `gqy` CLI 仍是本机 daemon 的薄客户端（不依赖 Docker） | — |

> **关键点**：WebUI 的会话/SSE 全部走同一服务端，所以一个运行在 Docker 的
> 顾清影可以被你手机、平板、办公电脑、家用机同时接入，记忆与会话共享。

## 后续 Milestone 建议（按价值排序）

1. **桌面 WebView 壳（macOS/Windows/Linux）**：用 Tauri 打包一份指向
   `GQY_SERVER_URL` 的桌面壳，随 Release 分发三平台安装包。Tauri 体积小、
   无重型 JS 运行时，最契合「瘦客户端」定位。
2. **Android APK/AAB（TWA/WebView）**：签名后上传 Play 或作为 APK 资产随
   Release 发布；加载远程服务端地址，本地零 AI。
3. **iOS / iPad（Swift + WKWebView）**：因 App Store 需开发者账号与审核，
   建议先以 **PWA** 满足「添加到主屏幕」即可用；正式上架需独立仓库/证书
   流程，不在本仓库 CI 内完成。
4. **客户端参数化**：新增 `?server=` 或设置页填服务端地址，让同一壳可连
   不同部署。

## 说明

- iOS/iPadOS/Windows 原生客户端受签名、证书、商店审核等**仓库外约束**约束，
  本仓库可产出代码与构建配置，但无法在此 CI 内完成苹果/谷歌签名上架。
- 本阶段先交付「Docker 制品 + 全平台可用的 PWA/浏览器瘦客户端 + 各端接入
  指南」，把架构跑通；原生壳按 roadmap 逐端补齐。
