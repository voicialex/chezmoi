# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A chezmoi source state directory managing Bash dotfiles. Files are deployed to `$HOME` via `chezmoi apply`.

## Chezmoi File Naming

- `dot_foo` → `~/.foo` (dot prefix maps to hidden file)
- `dot_foo.tmpl` → `~/.foo` (Go template, rendered on apply)
- `create_dot_foo` → `~/.foo` (only created if not exists; existing files never overwritten)
- `modify_dot_foo` → `~/.foo` (script that transforms existing file: reads current content from stdin, writes modified content to stdout; idempotent on every apply; **`modify_` prefix only works on files, NOT directories** — for nested paths use `dot_dir/modify_file`)
- `private_dot_foo` → `~/.foo` with restricted permissions (600)
- `run_once_foo.sh` → script executed only once on first apply (tracked by chezmoi state)
- `run_foo.sh` → script executed every apply (use for checks that need re-evaluation; must be idempotent)
- `.chezmoiscripts/<domain>/run_*.sh` → recommended script layout for grouping without creating extra files in `$HOME`
- Prefix order: `encrypted_` → `private_` → `readonly_` → `empty_` → `executable_` → `modify_` → `create_` → `dot_`
- Suffixes: `.tmpl` (Go template), `.literal` (stop parsing)

## Architecture

`dot_bashrc.tmpl` is the main entry point. It sources all `~/.bash_components/bashrc.d/*.sh` in alphabetical order:
- `0_log.sh` — shared log utilities (`_info`, `_warn`, `_error`, `_fatal`, `_clipboard_tool`); sourceable by chezmoi scripts via `$HOME/.bash_components/bashrc.d/0_log.sh`
- `0_set_path.sh` — adds common tool paths (nvim, bun, go, etc.) if they exist
- `1_help-dispatcher.sh` — `help` dispatcher + loads `help.d/*.sh` topic files via `_help_desc` registration
- `chezmoi-doctor.sh` — `_greeting()` version banner + `chezmoi-doctor` diagnostic command
- `gnome-terminal-theme.sh` — GNOME Terminal theme config
- `help.d/` — one file per topic (`help-<name>.sh`), sourced by `1_help-dispatcher.sh`; add new topics by creating a file and calling `_help_desc`
- `prompt_git.sh` — sets PS1 with git branch display (independent color detection via tput)
- `2_aliases.sh` — global aliases shared on all devices
- `z_local-loader.sh` — sources `~/.bash_aliases` and `~/.bash_local` (z_ prefix ensures last load order)

## Managed vs Unmanaged Files

| File | Strategy | Behavior |
|---|---|---|
| `~/.claude.json` | `modify_private_dot_claude.json` | Python script; ensures `hasCompletedOnboarding=true`; preserves user keys |
| `~/.gitconfig` | `modify_dot_gitconfig` | Ensures `[include]` of `~/.gitconfig.d/*.conf`; user settings preserved |
| `~/.gitconfig.d/*.conf` | `dot_gitconfig.d/` | Modular git config (core, alias); `create_user.conf` for per-machine identity |
| `~/.bashrc` | `dot_bashrc.tmpl` | Always overwritten on apply |
| `~/.bash_aliases` | `create_dot_bash_aliases` | Created once as personalization template; existing version never touched |
| `~/.bash_local` | `.chezmoiignore` | Completely ignored; each machine keeps its own |
| `~/.ssh/config` | `dot_ssh/modify_config` | Prepends `Include config.d/*.conf` if absent; existing entries preserved |
| `~/.ssh/config.d/*.conf` | `dot_ssh/config.d/` | Remote host configs (Tailscale, etc.) managed by chezmoi |
| `~/.claude/claudeline` | `.chezmoiscripts/claude/run_install-claudeline.sh` | Checks every apply: downloads binary + patches settings.json if claude installed but claudeline missing |
| `~/.claude/settings.json` | `dot_claude/modify_settings.json.tmpl` | Deep-merges managed keys (plugins, permissions, statusLine, etc.); user-set keys preserved |
| `~/.codex/config.toml` | `dot_codex/modify_config.toml` | Ensures managed keys present (features, agents, tui, etc.); user-set keys preserved; add model_providers/projects manually |
| `~/.tmux.conf` | `dot_tmux.conf` | Auto-detects clipboard tool: Wayland(`wl-copy`) → WSL(`clip.exe`) → X11(`xclip`); shows install hint if TPM missing |
| `~/.tmux/plugins/tpm` | `.chezmoiscripts/tmux/run_once_install-tmux-plugins.sh` | Installs TPM + all plugins on first apply |
| `~/.config/ghostty/config.ghostty` | `dot_config/ghostty/config.ghostty.tmpl` | Common Ghostty options (Linux only); GTK options conditional on OS; `create_config.local.ghostty` supplies per-machine overrides |
| editor keybindings | `.chezmoiscripts/editor/run_sync-editor-keybindings.sh` | Syncs `dot_config/editor-keybindings/` to VS Code and Cursor keybindings paths |
| `chezmoi apply` output | `.chezmoiscripts/chezmoi-info/run_00_show-apply-greeting.sh` | Prints `_greeting()` version banner at apply start |

## Conditional Deployment

`.chezmoiignore.tmpl` skips files based on detected environment:
- **WSL / headless**: skips GNOME terminal theme files
- **No `claude` binary**: skips `dot_claude/` and claudeline install script
- **No `codex` binary**: skips `dot_codex/`
- **No `nvim` binary**: skips `dot_config/nvim/`
- **No `ghostty` binary**: skips `dot_config/ghostty/`

Platform detection: `WSL_DISTRO_NAME`/`WSL_INTEROP` → WSL; `DISPLAY`/`WAYLAND_DISPLAY` → desktop.

## Agent Instructions

- `dot_claude/CLAUDE.md` → synced to `~/.claude/CLAUDE.md` (Claude Code instructions)
- `dot_claude/rules/*.md` → synced to `~/.claude/rules/*.md` (modular global rules)
  - `english-coach.md` — correct non-native English to help user improve
  - `commit.md` — commit message format conventions
  - `symlink_obsidian.md.tmpl` — symlinks Obsidian vault rules (conditional on vault existence)
- `dot_codex/AGENTS.md` → synced to `~/.codex/AGENTS.md` (Codex instructions)

Both contain the same role/persona configuration with a Linus Torvalds coding philosophy and commit message format: `feat(module): [PRO-10000] <Description>`.

## Version

Version is embedded in `chezmoi-doctor.sh` `_greeting()` function: `vYYYY.MM.DD`. Update it when making changes.

## Key Commands

```bash
chezmoi diff                  # preview changes before applying
chezmoi apply                 # deploy dotfiles to $HOME
chezmoi apply ~/.bashrc       # apply a single file
chezmoi edit ~/.bashrc        # edit source file in $EDITOR
chezmoi status                # show changed files
chezmoi source-path           # verify source directory location
```

**Always edit files in this repo (the source directory), never the deployed `~/` copies** — `chezmoi apply` overwrites them.
