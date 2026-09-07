# GQY（顾清影）服务端镜像 —— 整个 AI（daemon + 回合循环 + 记忆 + 内置 WebUI）
# 跑在容器里，供任意平台的「瘦客户端」（浏览器 / PWA / 桌面与移动端 WebView）
# 通过 HTTP/WebSocket 接入。架构图见 docs/DOCKER.md。
#
# 用法（本地验证）：
#   docker build -t gqy .
#   docker run -it --rm -p 8300:8300 \
#       -e GQY_HOME=/data -e GQY_WEB_PASSWORD=secret \
#       -v gqy-data:/data gqy
#   # 浏览器打开 http://<host>:8300 即得一个瘦客户端，任意平台皆可。

# ── 构建阶段：编译 Release 二进制（glibc，容器内原生运行）──
FROM rust:1.97-bookworm AS gqy-build
WORKDIR /build
# 安装构建所需系统库（与 .cnb/Dockerfile 的 CI 环境一致）
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential pkg-config \
        libssl-dev libfontconfig1-dev libasound2-dev libudev-dev \
        clang libclang-dev \
    && rm -rf /var/lib/apt/lists/*
COPY Cargo.toml Cargo.lock build.rs ./
COPY src ./src
COPY assets ./assets
COPY web ./web
COPY pics ./pics
# build.rs 会编译 persona/词典等，产物来自 src 与 assets，均在上面 COPY 内
RUN cargo build --release

# ── 运行阶段：最小化、非 root、带 CJK 字体（长回复转图渲染）──
FROM debian:bookworm-slim AS gqy-runtime
ENV GQY_HOME=/data
ENV GQY_LANG=auto
WORKDIR /opt/gqy
# fonts-noto-cjk：长回复转图片的渲染字体（缺失时静默退化为纯文本，不影响聊天）
# tini：正确转发信号并回收僵尸进程（daemon 会 fork 子进程）
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates fonts-noto-cjk tini \
    && rm -rf /var/lib/apt/lists/*
COPY --from=gqy-build /build/target/release/gqy /usr/local/bin/gqy
COPY src/memes /usr/share/gqy/memes
COPY src/scripts /usr/share/gqy/scripts
# 非 root 运行（数据目录 /data 由外部 volume 挂载）
RUN useradd --system --create-home --home-dir /data --uid 10001 gqy \
    && mkdir -p /data && chown -R gqy:gqy /data
USER gqy
EXPOSE 8300
# 由 CNB_DOCKER_REGISTRY/CNB_REPO_SLUG 注入镜像名；entrypoint 负责建目录与启动
COPY scripts/docker-entrypoint.sh /usr/local/bin/gqy-entrypoint
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/gqy-entrypoint"]
