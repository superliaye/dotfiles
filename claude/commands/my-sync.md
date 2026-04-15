---
description: Sync dotfiles and merge coding standards into local per-user CLAUDE.md
allowed-tools: Bash(git:*, bash:*, ls:*, cat:*), Read
---

Sync the user's dotfiles by running the authoritative shell script. All sync logic lives in `sync-claude.sh` -- do NOT duplicate it here.

## Steps

### 1. Find dotfiles directory

```bash
ls -d ~/dotfiles ~/.dotfiles ~/GitRepos/dotfiles /d/GitRepos/dotfiles 2>/dev/null | head -1
```

### 2. Pull latest and run sync

DO NOT SKIP!

```bash
cd <dotfiles_dir>
git pull
bash ./sync-claude.sh
```

The script handles everything: merging instruction files into `~/.claude/CLAUDE.md`, copying commands, copying settings, installing everything-claude-code, and installing the superpowers plugin.

### 3. Report

Summarize the output from `sync-claude.sh`:

- What changed in dotfiles (git pull output)
- How many instruction files were merged
- How many commands were synced
- Whether everything-claude-code installed successfully
- Whether superpowers plugin installed successfully

If any plugins were newly installed or updated, tell the user to **restart their Claude Code session** — plugins load at startup, so new skills won't appear until restart.
