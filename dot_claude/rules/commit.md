# Commit Conventions

## Format

```
<type>(<scope>): [<issue-ref>] <Description>
```

## Fields

| Field | Required | Values |
|-------|----------|--------|
| `<type>` | Yes | `feat`, `fix`, `refactor`, `docs`, `chore`, `style`, `test`, `perf` |
| `<scope>` | Yes | The module or component being changed (e.g., `bash`, `nvim`, `ssh`, `tmux`) |
| `[<issue-ref>]` | No | Linked issue or ticket ID (e.g., `[PRO-123]`, `[GH-456]`). Omit if no associated issue. |
| `<Description>` | Yes | Imperative mood, Capitalized, under 50 chars |

## Examples

```
feat(bash): [PRO-100] Add path detection for WSL
fix(nvim): Resolve keymap conflict in insert mode
refactor(ssh): Simplify config merge logic
docs(tmux): Update clipboard detection comment
```

## Rules

- Always use imperative mood (`Add` not `Added`, `Fix` not `Fixed`).
- Scope must reflect the actual module touched, not the project name.
- Description must be under 50 chars and summarize the "what", not the "why".
