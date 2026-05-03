# Ubuntu 安装指南：按平台安装 Skills（Claude Code / Codex）

## 目录

- [Claude Code](#claude-code)
  - [`andrej-karpathy-skills`](#andrej-karpathy-skillsclaude-code)
  - [`superpowers`](#superpowersclaude-code)
  - [`graphify`](#graphifyclaude-code)
  - [`gitnexus`](#gitnexusclaude-code)
  - [`clang-lsp`](#clang-lspclaude-code)
- [Codex](#codex)
  - [`andrej-karpathy-skills`](#andrej-karpathy-skillscodex)
  - [`superpowers`](#superpowerscodex)
  - [`graphify`](#graphifycodex)
  - [`gitnexus`](#gitnexuscodex)
  - [`clang-lsp`](#clang-lspcodex)

## Claude Code

> 本节包含每个 skill 的：功能介绍（含原理）、安装、使用方法、示例。

<a id="andrej-karpathy-skillsclaude-code"></a>
### `andrej-karpathy-skills`

GitHub：`https://github.com/forrestchang/andrej-karpathy-skills`

功能简介：这是偏“工程纪律约束”的技能包，目标是减少 LLM 编码中的低级错误（比如过度修改、跳过验证、未经确认就大改）。它的核心不是“加功能”，而是强制执行四类约束：

1. 先思考再编码：先澄清目标、边界和风险。
2. 简洁优先：避免过度设计与无关抽象。
3. 精准修改：只改必要文件和必要代码。
4. 目标驱动执行：每一步都对齐用户目标并带验证。

安装：

```text
/plugin marketplace add forrestchang/andrej-karpathy-skills
/plugin install andrej-karpathy-skills@karpathy-skills
```

使用方法：

1. 提交明确的编码任务。
2. 明确要求按 `karpathy-guidelines` 风格执行。
3. 要求输出“先分析风险，再最小改动，再验证结果”。

示例：

```text
请使用 karpathy-guidelines 重构这个函数：
先指出 3 个风险，再给最小改动方案，最后给可替换代码。
```

<a id="superpowersclaude-code"></a>
### `superpowers`

GitHub：`https://github.com/obra/superpowers`

功能简介：`superpowers` 是一个完整的软件开发 workflow 包，不是单一提示词。它由多个技能模块组成，覆盖从需求澄清到交付收尾的全过程。

主要组件：

1. 需求澄清：`brainstorming`
2. 计划拆分：`writing-plans`
3. 实施执行：`test-driven-development`、`subagent-driven-development` 或 `executing-plans`
4. 质量控制：`requesting-code-review`、`receiving-code-review`、`verification-before-completion`
5. 收尾交付：`finishing-a-development-branch`

原理：

1. 把“大任务”拆成短闭环任务，每一步可验证。
2. 用测试、评审和检查点阻止“拍脑袋改动”。
3. 用固定流程减少返工，提升可追踪性与可维护性。

建议使用场景：

1. 需求不清晰、容易反复改方向的任务。
2. 跨文件/跨模块的大改动或重构。
3. 需要多人协作、代码评审和交付规范的团队开发。
4. 希望把开发流程标准化的个人长期项目。

安装：

```text
/plugin install superpowers@claude-plugins-official
```

使用方法：

1. 给出真实目标，不要只说“帮我写代码”。
2. 先走 `superpowers:brainstorming` 和 `superpowers:writing-plans`。
3. 再执行 `superpowers:test-driven-development`、`superpowers:requesting-code-review`。

示例：

```text
使用 superpowers workflow 帮我实现需求：
先 brainstorming 明确边界，
再写 implementation plan，
最后按 TDD + code review 推进。
```

<a id=”graphifyclaude-code”></a>
### `graphify`

GitHub：`https://github.com/safishamsi/graphify`

功能简介：`graphify` 是**多模态知识图谱**工具。它不仅分析代码，还能把文档（Markdown）、PDF、图片等混合输入统一抽取为图结构，产出 `graphify-out/`（含 `GRAPH_REPORT.md`、`wiki/`、`graph.html` 可视化）。核心定位是**”理解项目全貌”**——代码 + 非代码资产一起建图。

原理：

1. **代码路径**（AST 解析）：对源文件（含 C/C++）走 tree-sitter/AST 提取符号（函数、类、变量）与关系（调用、导入、继承），再补充调用链结构。这一步是确定性的，不需要 LLM。
2. **文档路径**（LLM 语义抽取）：对 Markdown/PDF/图片调用 LLM 提取概念、实体、关系边。这一步需要 LLM API（首次 `/graphify` 构建时触发）。
3. **图谱合并**：将代码图和文档图合并为统一知识图谱，标注”直接抽取 vs 推断”关系，支持增量更新（`update`）与持续监听（`watch`）。
4. **聚类与报告**：对图谱节点做社区发现（clustering），生成 `GRAPH_REPORT.md` 概述和可交互的 `graph.html`。

与 gitnexus 的核心区别：

| 维度 | graphify | gitnexus |
|------|----------|----------|
| **输入范围** | 代码 + 文档 + PDF + 图片（多模态） | 仅代码 |
| **核心能力** | 知识地图 + 语义理解 + 可视化 | 调用链追踪 + 影响面分析 + 变更检测 |
| **LLM 依赖** | 首次构建需要 LLM（文档语义抽取） | 不需要 LLM（纯 AST 解析） |
| **集成方式** | Claude Code skill（`/graphify`） | MCP server（agent 自动调用） |
| **典型场景** | “这个项目整体在干什么？模块间什么关系？” | “改这个函数会影响哪些调用方？” |

适合对象：

1. **个人开发者**：快速建立项目知识地图，降低上下文切换成本；特别适合接手不熟悉的项目。
2. **文档密集型项目**：有大量 README、设计文档、PDF 规格书的项目，graphify 能把代码和文档关联起来。
3. **小团队**：统一代码和文档认知，辅助架构说明与新人 onboarding。
4. **不适合**：如果你只关心”改代码不破坏调用链”，不需要文档/图片分析，用 gitnexus 更直接。

安装：

```bash
# 需要 Python 3.10+
python3 --version

# 当前包名是 graphifyy，命令仍为 graphify
pip install graphifyy
graphify install
```

在 Claude 里作为插件/技能使用：

1. 安装完成后，打开 Claude Code，在项目目录直接执行 `/graphify`。
2. 也可手动注册 skill 文件到 `~/.claude/skills/graphify/SKILL.md`。
3. 推荐把 `/graphify` 当作”先建图再编码”的前置步骤。

使用方法：

1. **首次构建**（Claude Code 内）：执行 `/graphify`，触发 LLM 语义抽取 + AST 解析，生成完整图谱。
2. **增量更新**（终端）：`graphify update .`，仅重新解析变更的代码文件，不调用 LLM，速度快。
3. **查询图谱**（终端）：`graphify query “<问题>”`，BFS/DFS 遍历图谱回答问题。
4. **路径分析**（终端）：`graphify path “A” “B”`，查两个节点之间的最短路径。

常用命令速查：

```bash
# ── 首次构建（在 Claude Code 内执行） ──
/graphify

# ── 以下命令均在普通终端执行 ──

# 增量更新（仅代码结构，无需 LLM）
graphify update .

# 强制覆盖（重构删除代码后节点变少时）
graphify update . --force

# 查询图谱（BFS 遍历）
graphify query “这个模块的入口在哪里”

# 深度优先搜索 + 限制输出 token 数
graphify query “认证流程是怎样的” --dfs --budget 3000

# 查两个节点的最短路径
graphify path “AuthManager” “DatabaseClient”

# 解释某个节点及其邻居
graphify explain “UserService”

# 监听文件变更，自动重建图谱
graphify watch .

# 重新聚类（不重新解析，只刷新报告）
graphify cluster-only .

# 生成可折叠的 D3 树形可视化
graphify tree

# 检查图谱是否需要更新（可用于 cron）
graphify check-update .

# ── Git Hook（提交后自动增量重建） ──
# 安装 post-commit + post-checkout 钩子
graphify hook install

# 卸载钩子
graphify hook uninstall

# 查看钩子状态
graphify hook status
```

<a id=”gitnexusclaude-code”></a>
### `gitnexus`

GitHub：`https://github.com/abhigyanpatwari/GitNexus`

功能简介：`gitnexus` 是**纯代码结构分析 + 影响面追踪**工具链。它只关注代码本身（不处理文档/PDF/图片），用 tree-sitter 将代码结构（依赖、调用链、执行流）索引为知识图谱，再通过 MCP 协议将能力暴露给 AI agent。核心定位是**”改代码不翻车”**——让 agent 在编辑前知道影响面。

原理：

1. **AST 解析**（tree-sitter 原生绑定）：对每个源文件做语法解析，提取函数、类、模块等符号，以及调用、导入、继承等边关系。全过程确定性，不依赖 LLM。
2. **图索引存储**（LadybugDB）：将解析结果写入本地持久化图数据库，支持增量更新——只重新解析变更文件，不需要每次全量重建。
3. **MCP server 暴露能力**：`gitnexus mcp` 启动 stdio MCP server，agent 通过标准协议查询：
   - `context`：获取某个符号的完整上下文（定义、调用者、被调用者）
   - `impact`：分析修改某个文件/函数的影响面（哪些模块会受波及）
   - `detect_changes`：检测上次索引后哪些文件变了，提示 agent 重建索引
4. **Claude Code 深度集成**：除 MCP 外还注入 PreToolUse hook（搜索时自动补图谱上下文）和 PostToolUse hook（提交后检测索引是否过期并提醒重建）。

适合对象（与 graphify 的对比见上方 graphify 章节的对比表）：

1. **日常编码/重构**：你主要关心”改了 A 会不会炸 B”，需要 agent 帮你追踪调用链和影响面 → 用 gitnexus。
2. **中大型仓库**：文件多、模块间依赖复杂，agent 经常漏掉依赖导致 blind edit → gitnexus 的 MCP 自动注入上下文解决这个问题。
3. **微服务/monorepo 团队**：需要跨仓库追踪服务间调用关系 → `gitnexus group` 聚合多仓图谱。
4. **不适合**：如果你需要理解项目文档、PDF 规格书、架构图等非代码资产，gitnexus 不处理这些，用 graphify。

安装与配置：

> ⚠️ 以下所有命令均在**普通终端（bash/zsh）**中执行，不需要进入 Claude Code REPL。

```bash
# 1) 安装（二选一）
# ⚠️ 需要 Node.js 22 LTS 或更低版本；Node 24+ 会导致 onnxruntime-node 安装失败
npm install -g gitnexus          # 全局安装（推荐）
# 或：npx gitnexus analyze       # 免安装，每次通过 npx 调用

# 2) 在仓库根目录建索引（自动完成：索引 + 安装 skills + 生成 AGENTS.md/CLAUDE.md）
gitnexus analyze

# 3) 配置 MCP（一次性，自动检测 Claude Code/Cursor/Codex 等编辑器）
gitnexus setup
# 或手动指定：claude mcp add gitnexus -- npx -y gitnexus@latest mcp
```

使用方法：

1. **建索引**（终端）：`gitnexus analyze` — 在仓库根目录运行。
2. **配 MCP**（终端）：`gitnexus setup` — 一次即可，自动写入编辑器的 MCP 配置。
3. **日常使用**（Claude Code 内自动）：索引建好后，agent 自动通过 MCP 查询图谱，用户无需手动操作。
4. **大改后更新**（终端）：重跑 `gitnexus analyze`（增量）；重构后用 `--force` 全量重建。

常用命令速查（均在终端执行）：

```bash
gitnexus analyze                  # 建索引 / 增量更新
gitnexus analyze --force          # 强制全量重建（重构后使用）
gitnexus analyze --skip-embeddings # 跳过 embedding（更快，适合大仓库）
gitnexus status                   # 查看当前仓库索引状态
gitnexus wiki                     # 从知识图谱生成 wiki 文档
gitnexus list                     # 列出所有已索引的仓库
gitnexus clean                    # 删除当前仓库索引
gitnexus serve                    # 启动本地 HTTP 服务，供 Web UI 浏览

# 多仓聚合（微服务/monorepo 场景）
gitnexus group create my-platform
gitnexus group add my-platform backend/api my-api-repo
gitnexus group sync my-platform
```

<a id="clang-lspclaude-code"></a>
### `clang-lsp`

GitHub：`https://github.com/llvm/llvm-project/tree/main/clang-tools-extra/clangd`

功能简介：`clang-lsp`（通常是 `clangd` + LSP 生态）是 C/C++ 语义底座。它不是“文档类增强”，而是“改代码不犯语义错误”的基础设施。

原理：

1. `clangd` 读取 `compile_commands.json`，按真实编译参数构建 Translation Unit（翻译单元）。
2. 基于 Clang 前端做语义分析（类型、符号、引用、诊断、重命名）。
3. 通过 LSP（Language Server Protocol）把能力以统一协议暴露给编辑器：
   `go to definition`、`find references`、`rename`、`diagnostics` 等。
4. 这让编辑器前端与语言后端解耦，同一 `clangd` 可服务多个编辑器。

安装：

```bash
sudo apt update
sudo apt install -y clangd clang-format
```

在 Claude 里作为插件/技能使用：

1. `clangd` 本体是语言服务器，不是插件市场条目。
2. 可直接在 Claude Code 插件市场安装 `clangd-lsp`（Anthropic 官方插件封装）。
3. 建议仍在系统中安装 `clangd`，并准备 `compile_commands.json`，保证语义分析质量。
4. Claude Code 负责高层任务编排；语义真相由 `clangd` 和 `compile_commands.json` 提供。

安装方式：

```text
/plugins
# 搜索 clangd-lsp 并选择 Install Plugin
```

或直接安装：

```text
/plugin install clangd-lsp@claude-plugins-official
```

使用方法：

1. 先保证项目可生成 `compile_commands.json`。
2. 编辑器启用 `clangd` LSP。
3. 修改前后看诊断与引用，确认无语义回归。

示例（CMake）：

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json .
```

## Codex

> 本节只放“安装”，使用方法与实例请参考上面的 Claude Code 同名 skill 章节。

<a id="andrej-karpathy-skillscodex"></a>
### `andrej-karpathy-skills`

```bash
mkdir -p ~/.codex/skills
git clone --depth 1 https://github.com/forrestchang/andrej-karpathy-skills.git /tmp/andrej-karpathy-skills
cp -r /tmp/andrej-karpathy-skills/skills/karpathy-guidelines ~/.codex/skills/
```

<a id="superpowerscodex"></a>
### `superpowers`

推荐方式（插件市场）：

```bash
/plugins
# 搜索 superpowers 并选择 Install Plugin
```

兼容方式（手动）：

```bash
git clone https://github.com/obra/superpowers.git ~/.codex/superpowers
mkdir -p ~/.agents/skills
ln -s ~/.codex/superpowers/skills ~/.agents/skills/superpowers
```

<a id="graphifycodex"></a>
### `graphify`

```bash
python3 --version
pip install graphifyy
```

说明：`graphify` 官方当前主要定位 Claude Code skill；在 Codex 场景通常以独立 CLI 运行产物（如 `GRAPH_REPORT.md`、`wiki/`）再供 agent 使用。

<a id="gitnexuscodex"></a>
### `gitnexus`

```bash
# 1) 建索引（自动安装 skills + 生成 AGENTS.md）
npx gitnexus analyze

# 2) 接入 Codex MCP（方式一：自动检测）
npx gitnexus setup

# 2) 接入 Codex MCP（方式二：手动）
codex mcp add gitnexus -- npx -y gitnexus@latest mcp
```

使用方法同 Claude Code 章节，常用命令一致（`analyze`、`status`、`wiki` 等）。

<a id="clang-lspcodex"></a>
### `clang-lsp`

```bash
sudo apt update
sudo apt install -y clangd clang-format
```
