青龙面板一键安装脚本
### 使用方法
1. **指定分支安装**：
   ```bash
   curl -fsSL "https://raw.githubusercontent.com/ljun223/qlsh/refs/heads/main/qinglong.sh" -o qinglong.sh &&bash qinglong.sh -b v2.15.0
   ```
   这将安装 `v2.15.0` 版本的青龙面板。

2. **使用默认分支安装**：
   - 在 **Alpine Linux** 上：
     ```bash
     curl -fsSL "https://raw.githubusercontent.com/ljun223/qlsh/refs/heads/main/qinglong.sh" -o qinglong.sh &&bash qinglong.sh
     ```
     默认安装 `master` 分支。

   - 在 **Debian/Ubuntu** 上：
     ```bash
     curl -fsSL "https://raw.githubusercontent.com/ljun223/qlsh/refs/heads/main/qinglong.sh" -o qinglong.sh &&bash qinglong.sh
     ```
     默认安装 `debian` 分支。

---

### 示例
#### 示例 1：在 Debian 上安装默认分支
```bash
bash qinglong.sh
```
输出：
```
检测到系统类型：Debian
正在安装青龙面板...
...
青龙面板安装完成！
```
默认安装 `debian` 分支。

#### 示例 2：在 Alpine 上安装指定分支
```bash
bash qinglong.sh -b v2.15.0
```
输出：
```
检测到系统类型：Alpine Linux
正在安装青龙面板...
...
青龙面板安装完成！
```
安装 `v2.15.0` 分支。

---

```
curl -fsSL "https://raw.githubusercontent.com/ljun223/qlsh/refs/heads/main/qinglong.sh" -o qinglong.sh && bash qinglong.sh
```
