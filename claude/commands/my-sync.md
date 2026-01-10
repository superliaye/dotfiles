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

### 2. Detect project type

Check the current working directory for:
- **TypeScript**: `tsconfig.json` exists OR `package.json` contains "typescript"

### 3. Merge standards into per-user CLAUDE.md

Target: `.claude/CLAUDE.md` in the current working directory (per-user config, not the team's root `CLAUDE.md`)

Build the content to merge:
1. Start with `<dotfiles_dir>/instructions/CORE.md`
2. If TypeScript project: append `<dotfiles_dir>/instructions/typescript.md`

Create `.claude/` directory if needed.

**If `.claude/CLAUDE.md` doesn't exist**: Create it with the combined content.

**If `.claude/CLAUDE.md` exists**:
- Check for `<!-- DOTFILES-STANDARDS-START -->` marker
- If marker exists: Replace content between START and END markers with combined content
- If no marker: Append at the end:
  ```

  <!-- DOTFILES-STANDARDS-START -->
  [combined contents of CORE.md + typescript.md if applicable]
  <!-- DOTFILES-STANDARDS-END -->
  ```

### 4. Report

- What changed in dotfiles (git pull output)
- Which instruction files were merged (CORE.md, typescript.md, etc.)
- Whether `.claude/CLAUDE.md` was created/updated
