# 版本号规范

本项目使用 [语义化版本 2.0.0](https://semver.org/lang/zh-CN/) 管理版本号，格式为：

```text
主版本号.次版本号.修订号
```

当前版本统一记录在仓库根目录的 [`version.json`](../version.json) 中：

```json
{
  "name": "gqy-arch-setup",
  "version": "0.1.0",
  "versioning": "semver"
}
```

## 版本号变更规则

- **主版本号**：发生不兼容的配置、脚本或使用方式变更时递增，并将次版本号和修订号归零。
- **次版本号**：增加向后兼容的新功能时递增，并将修订号归零。
- **修订号**：修复问题、改进文档或进行不改变使用方式的调整时递增。

## 预发布版本

正式版本前可以使用预发布标识，例如：

```text
0.2.0-alpha.1
0.2.0-beta.1
0.2.0-rc.1
```

预发布版本不应被当作稳定版本使用。

## 脚本读取版本

`install.sh` 会从根目录的 `version.json` 读取并校验 `version` 字段，然后显示当前脚本版本。发布新版本时，只需要先更新 `version.json`，再同步更新 [`CHANGELOG.md`](../CHANGELOG.md)。

版本号必须符合以下基本形式：

```text
MAJOR.MINOR.PATCH
```

也可以附带预发布标识或构建元数据。
