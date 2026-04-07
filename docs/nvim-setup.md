# Neovim + tmux 远程开发环境搭建

## 架构

```
本地电脑 → SSH → 远程服务器 → tmux（会话保活）→ Neovim（编辑器 + LSP）
```

配置由 chezmoi 管理，`chezmoi apply` 自动部署。

## 一、安装 Neovim

### x86_64

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /opt/nvim
/opt/nvim/bin/nvim --version | head -1   # 验证 0.9+
# 之后开一个新 shell（或 source ~/.bashrc），0_set_path.sh 会自动加 /opt/nvim/bin
```

### arm64 / aarch64

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
tar xzf nvim-linux-arm64.tar.gz
sudo mv nvim-linux-arm64 /opt/nvim
/opt/nvim/bin/nvim --version | head -1   # 验证 0.9+
# 之后开一个新 shell（或 source ~/.bashrc），0_set_path.sh 会自动加 /opt/nvim/bin
```

## 二、安装 LazyVim

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
nvim    # 等待插件自动安装完成
```

## 三、部署 chezmoi 配置

```bash
chezmoi apply
```

chezmoi 会覆盖以下文件（自定义配置）：

- `~/.tmux.conf` — tmux 配置
- `~/.config/nvim/lua/config/options.lua` — nvim 选项
- `~/.config/nvim/lua/config/keymaps.lua` — nvim 快捷键
- `~/.config/nvim/lua/plugins/lsp.lua` — LSP 配置
- `~/.config/nvim/lua/plugins/tmux.lua` — tmux 窗格导航

## 四、安装 tmux 插件（TPM）

已由 `.chezmoiscripts/tmux/run_once_install-tmux-plugins.sh` 自动完成（`chezmoi apply` 时自动执行）。
无需手动操作。如需手动重装：

```bash
bash ~/chezmoi/.chezmoiscripts/tmux/run_once_install-tmux-plugins.sh
```

## 五、安装 LSP Server

方法 A（推荐）：在 nvim 中输入 `:Mason`，搜索语言 server，按 `i` 安装。

方法 B：手动安装后在 `~/.config/nvim/lua/plugins/lsp.lua` 中声明。

## 六、依赖工具

```bash
sudo apt install -y git curl unzip gcc make ripgrep fd-find tmux
```

## 七、SSH 稳定连接

本地 `~/.ssh/config` 添加：

```
Host myserver
    HostName 服务器IP
    User 用户名
    ServerAliveInterval 30
    ServerAliveCountMax 5
    TCPKeepAlive yes
    Compression yes
```

## 八、help-nvim：当前快捷键与窗口/终端操作（实测）

以下为当前配置实测结果（`leader` = `Space`）。

### 1) 打开导航栏（Explorer）

- `Space e`：打开项目根目录导航栏（root dir）
- `Space E`：打开当前工作目录导航栏（cwd）

### 2) 分屏与关闭窗口

- `Ctrl-w s`：水平分屏（`split`，上下）
- `Ctrl-w v`：垂直分屏（`vsplit`，左右）
- `Ctrl-w c`：关闭当前窗口（`close`）
- `Ctrl-w q`：退出当前窗口（`quit`）
- `Ctrl-w h/j/k/l`：在 nvim 窗口间切换

也可以直接输入命令：

```vim
:split
:vsplit
:close
:q
```

### 3) LazyVim 默认 Snacks 终端（只记够用）

一、终端打开 / 新建

- `Ctrl-/`：切换“当前唯一浮动终端”（开 / 关，默认单例）
- `数字 + Ctrl-/`：`1<C-/>` / `2<C-/>` 打开或切换 1 号、2 号独立终端
### 4) 在终端与代码/导航栏之间切换

- 终端输入模式先按 `Ctrl-\ Ctrl-n`，退回普通模式
- 普通模式回到终端输入：光标在终端窗口时按 `i`（多数情况下也会自动进入）
- 再按 `Ctrl-w h/j/k/l` 在窗口间切换
- 当前还支持在终端模式直接按 `Ctrl-h/j/k/l` 做窗口导航（tmux+nvim 联动）
- 需要快速在“代码窗口”和“终端窗口”间切换时，也可以直接按 `Ctrl-/`

### 5) 文件间切换（你最常用）

- `Ctrl-^`：在“当前文件”和“上一个文件”之间一键互切（两个文件来回横跳）
- `]b`：切到下一个 buffer（多文件前进）
- `[b`：切到上一个 buffer（多文件后退）
