# 更新日志

本文件记录 GQY Arch Setup 的重要变更。

## [未发布]

### 新增

- Hyprland 桌面配置骨架（模块化拆分：主题、快捷键、窗口规则、自启动）
- Waybar 状态栏配置（Catppuccin Mocha 主题）
- Kitty 终端配置（Catppuccin Mocha 配色）
- Fuzzel 启动器配置
- Mako 通知配置
- Hyprlock 锁屏配置（时钟 + 密码输入）
- Hypridle 电源管理配置（亮度、锁屏、休眠）
- Hyprpaper 壁纸配置 + GQYOS 壁纸
- Shell 环境配置（zshenv 环境变量 + zshrc 别名/插件/提示符）
- Tmux 配置（Ctrl+a 前缀、Vim 风格导航、状态栏）
- Neovim 配置（Catppuccin 主题、Telescope/Lualine/Gitsigns 插件、快捷键）
- Yazi 文件管理器配置
- Git 全局配置（delta 分支对比、常用别名）
- AI 工具链：Ollama + GQY Docker 部署（docker-compose 一键启动，WebUI :8300）
- 额外工具增加 docker / docker-compose
- vim-plug 自动安装
- install.sh 重构为完整的桌面部署脚本（字体、额外工具、配置文件部署）
- CI 增加配置文件存在性校验

### 改进

- 为 yay 安装流程增加严格的 Bash 错误处理。
- 检查 `makepkg -si` 是否成功执行。
- 检查 `yay` 是否已经安装并位于 PATH 中。
- yay 构建目录清理支持默认确认、否定选项和无效输入重试。
- 完善 README 的项目说明、目录结构和快速开始文档。
- 为在线安装入口增加版本读取和日期版本格式校验。
- 版本号改为日期版本格式 `vYY.MM.DD`，当前版本为 `v26.09.07`。

### 注意

- AMD 和 NVIDIA 驱动需要根据实际硬件二选一，不能同时安装。
- `install.sh` 总安装入口仍在开发中。
