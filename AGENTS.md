# Repository Guidelines

## Project Structure & Module Organization
This repository is a **chezmoi source state** for personal development environment files.
- Root-level managed files: `dot_bashrc.tmpl`, `dot_tmux.conf`, `dot_vimrc`, `.chezmoiignore.tmpl`.
- Bash modules: `dot_bash_components/bashrc.d/*.sh` (loaded by `~/.bashrc` in alphabetical order).
- Neovim config: `dot_config/nvim/lua/{config,plugins}/`.
- SSH and Git config fragments: `dot_ssh/`, `dot_gitconfig.d/`.
- One-time/apply scripts: `.chezmoiscripts/<domain>/run_once_*.sh` and `.chezmoiscripts/<domain>/run_*.sh`.
- Docs: `README.md`, `docs/`.

Naming follows chezmoi conventions: `dot_foo -> ~/.foo`, `create_` (create only if missing), `modify_` (idempotent transform), `run_once_` (first apply only).
Platform adaptation is centralized in `.chezmoiignore.tmpl`: filter only files that should not be deployed on `wsl` or `headless` targets, and keep runtime detection inside scripts when possible.

## Build, Test, and Development Commands
There is no build step; validation is done through chezmoi.
- `chezmoi source-path` — verify this repo is the active source.
- `chezmoi status` — show managed files changed in source/target.
- `chezmoi diff` — preview exact changes before deployment.
- `chezmoi apply` — deploy all managed files to `$HOME`.
- `chezmoi apply ~/.bashrc` — deploy a single target file.
- `chezmoi doctor` — run diagnostics when behavior is unexpected.

## Coding Style & Naming Conventions
- Shell scripts: POSIX/Bash-compatible, small idempotent functions, 4-space indentation, no clever one-liners.
- Lua (Neovim): follow existing `config/` and `plugins/` split; keep plugin logic in `plugins/*.lua`.
- File naming must preserve chezmoi prefixes/suffixes (`dot_`, `private_`, `.tmpl`, etc.); changing them changes deployment semantics.

## Testing Guidelines
No formal unit-test suite exists. Use this minimum validation flow for every change:
1. `chezmoi diff`
2. `chezmoi apply` (or targeted apply)
3. Re-open shell/tmux/nvim to confirm runtime behavior
4. `chezmoi status` should be clean or intentionally changed

For script updates, ensure repeated `chezmoi apply` runs stay idempotent.

## Commit & Pull Request Guidelines
Recent history favors short, imperative commit subjects (for example, `Update tmux plugin`, `Update README`). Keep commits focused by subsystem.

Preferred commit format for contributors:
- `feat(module): [PRO-10000] Add concise change summary`

PRs should include:
- What changed and why
- Key files touched (for example, `dot_bashrc.tmpl`, `dot_config/nvim/lua/plugins/lsp.lua`)
- Verification steps and command output summary (`chezmoi diff/apply/status`)
- Screenshots only when UI/terminal visuals are materially affected
