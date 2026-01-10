---
description: Sync dotfiles and merge coding standards into local per-user CLAUDE.md
allowed-tools: Bash(git:*, bash:*, ls:*, mkdir:*), Read, Edit, Write, Glob
---

Sync the user's dotfiles and merge coding standards into the current repo's per-user config.

## Steps

### 1. Find and sync dotfiles

```bash
# Find dotfiles directory
ls -d ~/dotfiles ~/.dotfiles ~/GitRepos/dotfiles 2>/dev/null | head -1
```

Navigate there, pull latest, run install:
```bash
cd <dotfiles_dir>
git pull
./install.sh
```

### 2. Merge standards into per-user CLAUDE.md

Target: `.claude/CLAUDE.md` in the current working directory (per-user config, not the team's root `CLAUDE.md`)

- Create `.claude/` directory if needed
- **If `.claude/CLAUDE.md` doesn't exist**: Create it with content from `<dotfiles_dir>/instructions/CORE.md`
- **If `.claude/CLAUDE.md` exists**:
  - Check for `<!-- DOTFILES-STANDARDS-START -->` marker
  - If marker exists: Replace content between START and END markers with latest CORE.md
  - If no marker: Append at the end:
    ```

    <!-- DOTFILES-STANDARDS-START -->
    ## Personal Standards

    [contents of CORE.md here]
    <!-- DOTFILES-STANDARDS-END -->
    ```

### 3. Report

- What changed in dotfiles (git pull output)
- Whether `.claude/CLAUDE.md` was created/updated
- Remind user to reload shell if needed
