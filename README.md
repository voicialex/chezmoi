# Chezmoi-managed Bash configuration

This directory is your chezmoi source state.

- [File Naming](#file-naming)
- [Installation](#installation)
- [Initialize on a new machine](#initialize-on-a-new-machine)
- [Common Commands](#common-commands)
- [Platform Profiles](#platform-profiles)
- [Troubleshooting](#troubleshooting)

## File Naming

chezmoi 通过文件名前缀和后缀来决定如何处理文件。

### 核心规则：`dot_` → `.`

`dot_` 前缀被替换为目标路径的点号：

| 源文件 | 目标路径 |
|---|---|
| `dot_bashrc.tmpl` | `~/.bashrc` |
| `dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `dot_codex/AGENTS.md` | `~/.codex/AGENTS.md` |
| `dot_bash_components/bashrc.d/` | `~/.bash_components/bashrc.d/` |
| `create_dot_bash_aliases` | `~/.bash_aliases`（仅首次，已有则跳过） |

### 常用前缀

| 前缀 | 效果 |
|---|---|
| `dot_` | 文件名前加 `.` |
| `private_` | 去掉 group/other 权限（文件 600，目录 700） |
| `executable_` | 加可执行权限 |
| `encrypted_` | 源文件内容加密存储 |
| `create_` | 仅当目标文件不存在时创建 |
| `modify_` | 转换已有文件：从 stdin 读当前内容，stdout 输出修改后内容；每次 apply 幂等执行；**仅用于文件，不能用于目录**（嵌套路径用 `dot_dir/modify_file`） |
| `run_once_` | 仅首次 apply 时执行一次（由 chezmoi 状态追踪） |
| `run_` | 每次 apply 都执行（用于需要重复检查的场景，脚本必须幂等） |
| `symlink_` | 创建符号链接而非复制 |
| `literal_` | 停止解析前缀（用于文件名本身含关键词的情况） |

前缀可组合，顺序为：`encrypted_` → `private_` → `readonly_` → `empty_` → `executable_` → `modify_` → `create_` → `dot_`

例：`private_dot_bashrc.tmpl` → `~/.bashrc`（权限 600）

### 后缀

| 后缀 | 效果 |
|---|---|
| `.tmpl` | 文件内容作为 Go 模板渲染 |
| `.literal` | 停止解析后缀 |

### 忽略规则

源目录中所有以 `.` 开头的文件和目录被忽略，但 `.chezmoi` 开头的除外（如 `.chezmoiignore`）。

### 脚本目录约定（推荐）

- 本仓库将执行脚本放在 `.chezmoiscripts/<domain>/` 下做功能分组（如 `tmux/`、`editor/`、`claude/`）。
- 在 `.chezmoiscripts/` 下的 `run_` / `run_once_` 脚本会正常执行，但不会在 `$HOME` 生成对应目录结构。
- 这样可以同时满足“功能归类”和“目标目录不被脚本文件污染”。
- `.chezmoiscripts/00-core/run_00_show-apply-greeting.sh` 会在每次 `chezmoi apply` 开头输出当前配置版本（复用 `_greeting`）。

## Installation

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
# 或者: sudo snap install chezmoi（WSL/容器可能不可用）
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
chezmoi --version
```

## Initialize on a new machine

```bash
# 从远程仓库初始化（一键安装 + 部署）
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/voicialex/chezmoi.git
# 或者从本地目录: cd /path/to/repo && chezmoi init
chezmoi diff    # 可选: 查看变更
chezmoi apply   # 部署到 $HOME
```

- `~/.bash_aliases` — 使用 `create_` 前缀管理，首次 `chezmoi apply` 时创建标准版本，**已有则不覆盖**，用户可自由定制。
- `~/.bash_local` — 完全不纳入版本管理（`.chezmoiignore`），每台机器各自独立。

## Common Commands

### Checking Status

```bash
# Check chezmoi source directory path
chezmoi source-path

# Show status of managed files (A=added, M=modified, etc.)
chezmoi status

# Show differences between source and destination
chezmoi diff

# Show complete configuration
chezmoi dump-config
```

### Editing and Applying Changes

```bash
# Edit a file in the source state
chezmoi edit ~/.bashrc

# Apply all pending changes
chezmoi apply

# Apply specific file
chezmoi apply ~/.bashrc
```

## Platform Profiles

This repo keeps platform adaptation intentionally simple: **filter only files that should not be deployed**, and let scripts detect the runtime environment themselves.

- `wsl` — detected when `WSL_DISTRO_NAME` or `WSL_INTEROP` exists on Linux.
- `desktop` — detected when `DISPLAY` or `WAYLAND_DISPLAY` exists.
- `headless` — any other environment.

Current behavior:

- `wsl` / `headless`: skip `dot_config/gnome-terminal/`, `.chezmoiscripts/terminal-theme/run_once_apply-gnome-terminal-theme.sh`, and `dot_bash_components/bashrc.d/gnome-terminal-theme.sh`
- clipboard and tmux integration stay deployed everywhere; they already auto-detect `wl-copy`, `clip.exe`, and `xclip` at runtime
- In WSL, `.chezmoiscripts/editor/run_sync-windows-editor-keybindings.sh` syncs:
  `~/.config/editor-keybindings/vscode-keybindings.jsonc` → `AppData/Roaming/Code/User/keybindings.json`
  `~/.config/editor-keybindings/cursor-keybindings.jsonc` → `AppData/Roaming/Cursor/User/keybindings.json`

Rule of thumb: if a feature is harmless but environment-dependent, keep it deployed and make the script auto-skip. Only use `.chezmoiignore.tmpl` for files that are clearly wrong on a target platform.

## Troubleshooting

**Problem: `chezmoi apply` has no effect**

Check that your source directory is configured correctly:

```bash
# Check current source path
chezmoi source-path

# If incorrect, create/edit ~/.config/chezmoi/chezmoi.toml
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
sourceDir = "/path/to/your/chezmoi/repo"
EOF
```

```toml
# ~/.config/chezmoi/chezmoi.toml
sourceDir = "/home/pi/ws/chezmoi"
```

**Run diagnostics:**

```bash
chezmoi doctor
```
