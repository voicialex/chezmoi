# Ghostty 安装与默认终端（Ubuntu / Linux）

[Ghostty](https://ghostty.org/) 是跨平台 GPU 终端。本文聚焦：**安装**、**设为默认终端**、**分屏与 pane 快捷键**，以及与本仓库 chezmoi 的集成。

## 1. 安装方式

### 1.1 Snap（步骤最少）

```bash
sudo snap install ghostty
```

版本随 Snap 渠道变化，可用 `snap info ghostty` 查看。

### 1.2 社区安装脚本 / PPA（.deb）

> **⚠ 仅支持 Ubuntu 24.04+**。Ubuntu 22.04 会报错 `This installer is not compatible`，
> 需改用源码编译：https://ghostty.org/docs/install/build

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
```

### 1.3 Snap 与 .deb 的取舍

| 方式 | 说明 |
|------|------|
| Snap | 沙箱封装，一条命令安装，版本由 Snap 渠道决定。 |
| 脚本 / deb | 更接近传统系统包路径，更新节奏取决于脚本维护者。 |

## 2. 设为默认终端

多种方式可并存，按需选用。

### 2.1 GNOME「默认终端应用」

影响新标签、`xdg-open` 等拉起终端的行为：

```bash
gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
```

若命令找不到，可改为可执行文件的绝对路径（Snap 常见为 `/snap/bin/ghostty`）。

### 2.2 `x-terminal-emulator` 备选

部分程序会通过 `update-alternatives` 注册的 `x-terminal-emulator` 启动终端：

```bash
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$(command -v ghostty)" 50
sudo update-alternatives --config x-terminal-emulator
```

在交互列表中选中 Ghostty。

### 2.3 键盘快捷键

在 **设置 → 键盘 → 自定义快捷键** 中，将「打开终端」类快捷键的命令改为 `ghostty`（或上述绝对路径）。

## 3. 验证

```bash
ghostty --version
command -v ghostty
```

## 4. 分屏与切换 pane（默认快捷键）

以下为 Ghostty **出厂默认**绑定；若你改过 `keybind`，以本机输出为准：

```bash
ghostty +list-keybinds
```

### 4.1 新建分屏（split）

| 快捷键 | 作用 |
|--------|------|
| **Ctrl+Shift+O** | 向右新开一格（垂直分割线，左右分屏） |
| **Ctrl+Shift+E** | 向下新开一格（水平分割线，上下分屏） |

### 4.2 在 pane 之间移动焦点

| 快捷键 | 作用 |
|--------|------|
| **Ctrl+Alt+方向键（↑↓←→）** | 焦点移到上 / 下 / 左 / 右相邻的 pane |
| **Super+Ctrl+[** | 按布局顺序切换到上一个 pane |
| **Super+Ctrl+]** | 按布局顺序切换到下一个 pane |

（`Super` 即 Windows / Command 键；部分桌面环境会占用 **Super+…**，若无效请用 `+list-keybinds` 核对或改用 **Ctrl+Alt+方向键**。）

### 4.3 常用辅助

| 快捷键 | 作用 |
|--------|------|
| **Ctrl+Shift+Enter** | 放大 / 还原当前 pane（toggle split zoom） |
| **Super+Ctrl+Shift+方向键** | 沿该方向调整分割线位置（resize split） |

## 5. 与本仓库 chezmoi 的集成

- **仅 Linux**：当 `ghostty` 在 `PATH` 中（`lookPath "ghostty"`）且 `.chezmoi.os == "linux"` 时，才会部署配置。macOS 的 Ghostty 使用 `~/Library/Application Support/...` 路径，本仓库不处理。
- 满足条件时会部署：
  - `~/.config/ghostty/config.ghostty`：常用选项（主题、字体大小、分屏淡化、关闭确认、剪贴板粘贴保护等）。
  - `~/.config/ghostty/config.local.ghostty`：**仅在首次创建**（`create_`），用于本机覆盖；之后 chezmoi 不会覆盖该文件。
- 主配置开头通过 `config-file = "?config.local.ghostty"` 加载本地覆盖文件；若尚不存在也不会报错。
- 在 Bash 中可运行 `help ghostty` 查看内置帮助摘要。

### 5.1 常用 CLI

```bash
ghostty +list-keybinds    # 当前有效快捷键
ghostty +list-themes      # 内置主题名称
ghostty +show-config --default --docs   # 带注释的默认配置（可配合 pager）
```

修改 `~/.config/ghostty/config.ghostty` 后，可用 **Ctrl+Shift+,** 重载配置（默认快捷键，以 `ghostty +list-keybinds` 为准）。
