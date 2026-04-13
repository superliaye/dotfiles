# Dotfiles - Agent Context

Personal workspace setup for shell configuration and Claude Code integration.

## File Map

| File | Purpose | When to modify |
|------|---------|----------------|
| `bashrc-aliases.sh` | All aliases and functions (git, Rush, NPM) | Adding shortcuts |
| `bashrc.sh` | Loader (sources other files) | Rarely - only to add new modules |
| `sync-claude.sh` | Sync Claude config to ~/.claude/ | Changing what gets synced |
| `install.sh` | Full setup (shell + Claude) | Adding shell setup steps |
| `.claude/settings.local.json` | Permission whitelist | Enabling new bash commands |
| `claude/commands/*.md` | Custom slash commands | Creating new /commands |
| `instructions/*.md` | User instructions (CLAUDE.md) | Adding/updating rules |

## Quick Decision Tree

**Adding an alias?**
- All aliases → `bashrc-aliases.sh`
- One machine only → User creates `bashrc-local.sh`

**Adding a Claude command?**
1. Create `claude/commands/my-<name>.md` with frontmatter (prefix `my-` to avoid conflicts)
2. Update `claude/README.md`

**Expanding permissions?**
- Use wildcards: `Bash(tool:*)` not specific commands
- Never allow: `rm`, `sudo`, `chmod`, `curl`

## Validation

Run `/my-validate` after any significant change, and always before committing.

**Run validation when changing:**

- Any `*.sh` file (shell scripts or aliases)
- `instructions/*.md` or `claude/commands/*.md`
- `.claude/settings.local.json`
- `sync-claude.sh` or `install.sh`

If Docker is unavailable, run directly (safe — uses a temp `$HOME`):

```bash
bash test/run-tests.sh
```

## Principles

1. **Simplicity** - Single alias file, easy to maintain
2. **Context window aware** - Keep files concise, avoid duplication
3. **Test before commit** - Always verify syntax
4. **Document significant changes** - Update CHANGELOG.md

## Common Tasks

**Add git alias:**
```bash
# In bashrc-aliases.sh, add:
alias gx='git command'
```

**Add Rush function:**
```bash
# In bashrc-aliases.sh, add:
rbx() {
  rush install && rush build "$@"
}
```

**Add Claude command:**
```markdown
# claude/commands/my-command.md
---
description: What it does
allowed-tools: Bash(git:*), Read, Edit
---

Your prompt here. Use $ARGUMENTS for input.
```

## Sync Script

`sync-claude.sh` replaces `~/.claude/` with this repo's config. Run from anywhere:

```bash
# Git Bash / macOS / Linux
curl -sSL https://raw.githubusercontent.com/superliaye/dotfiles/main/sync-claude.sh | bash

# Windows PowerShell
curl.exe -sSL https://raw.githubusercontent.com/superliaye/dotfiles/main/sync-claude.sh | & 'C:\Program Files\Git\bin\bash.exe'
```

**What gets synced (overwrites existing):**
- `instructions/CORE.md` → `~/.claude/CLAUDE.md`
- `instructions/*.md` → `~/.claude/`
- `claude/commands/*.md` → `~/.claude/commands/`
- `.claude/settings.local.json` → `~/.claude/settings.local.json`

**Always push to `personal` remote** - that's the public source for the sync script.

## Git Remotes

This repo tracks two origins - push to both for sync:

| Remote | URL | Purpose |
|--------|-----|---------|
| `origin` | https://github.com/liaye_microsoft/dotfiles.git | Corporate/Microsoft |
| `personal` | https://github.com/superliaye/dotfiles.git | Public personal (sync source) |

**Push to both remotes:**
```bash
git push origin main && git push personal main
```

**Sync dotfiles (from any repo):**
```bash
/my-sync           # Syncs dotfiles + merges standards into .claude/CLAUDE.md
```

## Deep Documentation

Only read these when needed for complex changes:
- [docs/AGENT_GUIDE.md](docs/AGENT_GUIDE.md) - Full maintenance playbook
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - System design details
- [docs/DECISIONS.md](docs/DECISIONS.md) - Decision frameworks
- [docs/BEST_PRACTICES.md](docs/BEST_PRACTICES.md) - Coding patterns
