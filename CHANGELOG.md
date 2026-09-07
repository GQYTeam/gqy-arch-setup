# 更新日志

本文件记录 GQY Arch Setup 的重要变更。

## [未发布]

### 新增

- 添加根目录 `version.json`，作为项目统一版本源。
- 添加版本号规范说明文档。
- 添加 Arch Linux、Hyprland、Bash 和 AGPL v3 徽章。
- 添加 GNU AGPL v3.0 许可证文件。
- 添加 Hyprland 桌面基础依赖清单。
- 添加 AMD 和 NVIDIA 显卡驱动选项及 Arch 官方包链接。
- 添加 yay 的 AUR 编译安装脚本。

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
