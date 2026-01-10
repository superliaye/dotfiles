# Dotfiles - Agent Context

Personal workspace setup for shell configuration and Claude Code integration.

## File Map

| File | Purpose | When to modify |
|------|---------|----------------|
| `bashrc-general.sh` | Universal aliases (git, ls, vim) | Adding general-purpose shortcuts |
| `bashrc-microsoft.sh` | Rush/NPM/Microsoft workflows | Adding project-specific shortcuts |
| `bashrc.sh` | Loader (sources other files) | Rarely - only to add new modules |
| `sync-claude.sh` | Sync Claude config to ~/.claude/ | Changing what gets synced |
| `install.sh` | Full setup (shell + Claude) | Adding shell setup steps |
| `.claude/settings.local.json` | Permission whitelist | Enabling new bash commands |
| `claude/commands/*.md` | Custom slash commands | Creating new /commands |
| `instructions/*.md` | User instructions (CLAUDE.md) | Adding/updating rules |

## Quick Decision Tree

**Adding an alias?**
- Universal (git, ls, etc.) → `bashrc-general.sh`
- Rush/NPM/Microsoft → `bashrc-microsoft.sh`
- One machine only → User creates `bashrc-local.sh`

**Adding a Claude command?**
1. Create `claude/commands/my-<name>.md` with frontmatter (prefix `my-` to avoid conflicts)
2. Update `claude/README.md`

**Expanding permissions?**
- Use wildcards: `Bash(tool:*)` not specific commands
- Never allow: `rm`, `sudo`, `chmod`, `curl`

## Before Any Change

```bash
# Verify syntax after editing bashrc files
bash -n bashrc.sh && bash -n bashrc-general.sh && bash -n bashrc-microsoft.sh

# Check for duplicate aliases
grep -r "alias <name>" bashrc*.sh

# Test aliases load correctly
bash -c ". ./bashrc.sh && type <alias_name>"
```

## Principles

1. **Modularity** - Keep general vs project-specific separated
2. **Context window aware** - Keep files concise, avoid duplication
3. **Test before commit** - Always verify syntax
4. **Document significant changes** - Update CHANGELOG.md

## Common Tasks

**Add git alias:**
```bash
# In bashrc-general.sh, add:
alias gx='git command'
```

**Add Rush function:**
```bash
# In bashrc-microsoft.sh, add:
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
curl -sSL https://raw.githubusercontent.com/superliaye/dotfiles/main/sync-claude.sh | bash
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
