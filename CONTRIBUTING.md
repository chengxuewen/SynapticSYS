# 贡献指南 | Contributing Guide

> **注意**: 本项目目前处于早期验证阶段，暂不接受外部贡献。本文档将在项目开放贡献时生效。

欢迎你！感谢你考虑为 SynapticSYS 项目贡献力量。这份指南将帮助你了解如何有效地参与进来。

---

## 📋 目录

- [如何开始](#-如何开始)
- [开发流程](#-开发流程)
- [Git 提交规范](#-git-提交规范)
- [拉取请求流程](#-拉取请求流程)
- [测试与代码质量](#-测试与代码质量)
- [需要帮助](#-需要帮助)

---

## 🚀 如何开始

### 1. Fork 仓库
在项目镜像（GitHub、Gitee、GitLab 等）上 Fork 本项目仓库到你的账户下。

### 2. 克隆仓库
将你 Fork 后的仓库克隆到本地。以下以 GitHub 为例，其他镜像操作类似：

```bash
git clone https://github.com/<你的用户名>/SynapticSYS.git
cd SynapticSYS
```

**其他镜像示例**：
- Gitee: `https://gitee.com/<你的用户名>/SynapticSYS.git`
- GitLab: `https://gitlab.com/<你的用户名>/SynapticSYS.git`

### 3. 设置上游远程
添加原始仓库作为上游远程，以便同步最新更改。选择你的主要镜像源：

```bash
# 使用 GitHub 主源
git remote add upstream https://github.com/synapticsys/SynapticSYS.git

# 或使用 Gitee 镜像
git remote add upstream https://gitee.com/synapticsys/SynapticSYS.git

# 可选：添加多个镜像源
git remote add github https://github.com/synapticsys/SynapticSYS.git
git remote add gitee https://gitee.com/synapticsys/SynapticSYS.git
```

---

## 🔧 开发流程

### 1. 同步主分支
在开始新工作前，请确保你的本地 main 分支与上游同步：

```bash
git checkout main
git fetch upstream
git merge upstream/main
```

### 2. 创建功能分支
为每个新功能或 Bug 修复创建一个描述性的分支：

```bash
git checkout -b feat/your-feature-name   # 新功能
git checkout -b fix/issue-123            # 修复 Bug
git checkout -b docs/update-readme       # 文档更新
```

### 3. 进行你的更改
在分支上完成你的代码或文档修改。

### 4. 运行测试
在提交前，请确保你的更改通过了相关测试。

### 5. 提交更改
请遵循下文严格的 **提交消息规范**。

---

## 🔖 Git 提交规范

我们严格遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范。这有助于自动生成变更日志、确定语义化版本，并使历史记录清晰可读。

### 提交消息格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

**结构说明**：
- **第一行**：类型 + 范围（可选）+ 简短描述
- **第二行**：空行
- **第三行起**：详细描述（可选）
- **最后**：页脚信息（可选，如关联 Issue）

### 类型说明

| 类型 | 说明 | 版本影响 |
|------|------|----------|
| `feat` | 新功能（新增用户可感知的功能） | MINOR (次版本) ↑ |
| `fix` | Bug 修复（修复用户可感知的问题） | PATCH (修订号) ↑ |
| `docs` | 文档变更（README、CONTRIBUTING、API 文档等） | - |
| `style` | 代码格式调整（不影响功能的格式修改） | - |
| `refactor` | 代码重构（既不是新功能，也不是 Bug 修复） | - |
| `perf` | 性能优化 | PATCH ↑ |
| `test` | 测试相关（添加或修改测试代码） | - |
| `build` | 构建系统或依赖变更（CMake、NuGet 等） | - |
| `ci` | CI 配置变更（.github/workflows、.gitlab-ci.yml 等） | - |
| `chore` | 杂项变更（不修改源代码或测试文件） | - |

### 范围说明

范围（scope）**可选**，用于指明变更影响的具体模块。应与项目结构对应：

- `core` - 核心运行时框架
- `runtime` - 运行时系统
- `studio` - 集成开发环境
- `designer` - 蓝图编辑器
- `cli` - 命令行工具
- `link` - 通信管理器（Synaptic Link）
- `docs` - 文档
- `build` - 构建系统

**注**：如果更改影响多个模块或难以界定，可以省略范围。

### 主题说明

✅ **推荐做法**：
- 使用祈使句、现在时（如 "add" 而非 "added" 或 "adds"）
- 首字母不要大写
- 结尾不要加句号
- 长度建议不超过 50 个字符

### 提交示例

#### ✅ 良好示例

**新功能提交**：
```
feat(runtime): add heartbeat-based service health check

- Implement heartbeat detection protocol
- Auto-restart unresponsive services via daemon
- Update related documentation

Closes #123
```

**Bug 修复**：
```
fix(studio): prevent crash when connecting empty data flow nodes

Added null check to handle empty output ports during connection operations.

Fixes #456
```

**文档更新**：
```
docs: update environment setup in quick start guide

Synchronized latest CLI commands and configuration examples.
```

**代码重构**：
```
refactor(core): simplify communication manager plugin loading logic

Improves testability and reduces complexity.
```

#### ❌ 应避免的示例

```
updated some files         # 类型不明，描述模糊
fix bug                    # 范围不明，描述过于简单
修复了一个小问题           # 未使用英文
```

---

## 🔀 拉取请求 (Pull Request) 流程

### 1. 推送分支
将你的本地分支推送到你的 Fork 仓库：

```bash
# 推送到 GitHub Fork
git push origin feat/your-feature-name

# 或推送到其他镜像的 Fork
git push origin feat/your-feature-name
```

### 2. 创建 PR
在对应的镜像仓库页面上创建 Pull Request（GitHub/Gitee/GitLab 等均支持）：

**PR 标题和描述规范**：
- **标题**：清晰描述变更，遵循提交消息规范
- **描述**：详细说明做了什么、为什么做，并关联相关 Issue（例如 `Closes #123`、`Fixes #456`）
- **附件**：如适用，请附上截图或测试结果

**PR 模板示例**：
```
## 描述
请简要描述这个 PR 的目的和内容。

## 相关 Issue
Closes #123

## 变更类型
- [ ] 新功能
- [ ] Bug 修复
- [ ] 文档更新
- [ ] 性能优化
- [ ] 代码重构

## 测试方法
请描述如何测试这个变更。

## 截图（如适用）
附上相关截图。
```

### 3. 代码审查
维护者会对你的 PR 进行审查。请积极参与讨论，并根据反馈进行修改。这是提升代码质量的关键环节。

### 4. 合并
通过所有审查且 CI 测试通过后，维护者会将你的贡献合并入 main 分支。

---

## 🧪 测试与代码质量

- 在提交 PR 前，请确保你的更改不会破坏现有的测试
- 鼓励为你添加的新功能编写相应的单元测试或集成测试
- 我们使用工具（如 EditorConfig）来保持代码风格一致，请确保你的编辑器已支持

---

## ❓ 需要帮助？

### 常见问题

**Q: 我不知道从哪个镜像克隆？**
A: 建议选择离你地理位置最近或访问速度最快的镜像。通常：
- 中国用户：优先使用 Gitee 镜像
- 其他地区：优先使用 GitHub 镜像
- 均可正常访问的情况下，推荐使用 GitHub 主源以获得最新的更新

**Q: 我可以向任何镜像提交 PR 吗？**
A: 可以，但建议向主镜像（GitHub）提交。其他镜像的 PR 也会被及时处理，但主镜像确保了最快的响应速度。

**Q: 如何同步其他镜像的最新代码？**
A: 可以在本地添加多个镜像源并定期同步：
```bash
git fetch upstream
git fetch github
git merge upstream/main
```

### 获取帮助

如果你对贡献流程、代码库或设计决策有任何疑问，可以通过以下方式寻求帮助：

- **[GitHub Issues](https://github.com/synapticsys/SynapticSYS/issues)**：提交问题和建议
- **[GitHub Discussions](https://github.com/synapticsys/SynapticSYS/discussions)**：开放讨论和技术问答
- **[Gitee Issues](https://gitee.com/synapticsys/SynapticSYS/issues)**：Gitee 镜像上的问题跟踪

提交问题时，请确保：
- 问题描述清晰详细
- 提供必要的环境信息（系统、版本等）
- 已查阅过相关文档

---

## 📝 补充说明

感谢你愿意花费时间和精力让 SynapticSYS 变得更好！我们期待看到你的贡献。

本文档基于 [Conventional Commits](https://www.conventionalcommits.org/) 规范及众多成功开源项目的实践制定。
