### 青龙面板一键安装脚本

- **安装命令**:
   ```bash
  bash qinglong.sh
   ```
- **默认安装分支**：
  - Alpine：`master`
  - Debian/Ubuntu：`debian`
- **灵活性**：支持通过 `-b` 参数指定分支。
- **兼容性**：适用于 Alpine 和 Debian/Ubuntu 系统。

---
### 使用方法

1. **使用默认分支安装**：
   在 **Alpine Linux** 上：
     ```bash
     curl -fsSL "https://raw.githubusercontent.com/ljun223/qlsh/refs/heads/main/qinglong.sh" -o qinglong.sh &&bash qinglong.sh
     ```
     默认安装 `master` 分支。

   在 **Debian/Ubuntu** 上：
     ```bash
     curl -fsSL "https://raw.githubusercontent.com/ljun223/qlsh/refs/heads/main/qinglong.sh" -o qinglong.sh &&bash qinglong.sh
     ```
     默认安装 `debian` 分支。

2. **指定分支安装**：

### 示例：在Alpine安装v2.15.0版本

   ```bash
   curl -fsSL "https://raw.githubusercontent.com/ljun223/qlsh/refs/heads/main/qinglong.sh" -o qinglong.sh &&bash qinglong.sh -b v2.15.0
   ```
   这将安装 `v2.15.0` 版本的青龙面板。
