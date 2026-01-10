# Claude Code Configuration

Personal Claude commands and skills for use across all environments.

## Available Commands

### `/my-commit`
Create a detailed git commit with comprehensive summary. Analyzes all changes and follows best practices.

### `/my-commit-and-push`
Same as `/my-commit` but also pushes to the remote after committing.

### `/my-create-pr`
Create a pull request with detailed description based on all commits and changes in the branch.

### `/my-fix-build`
Analyze and fix build/lint errors systematically.

Usage: `/my-fix-build [optional: specific package]`

### `/my-explain`
Explain code with clear examples and context. Reads files, understands patterns, and provides practical explanations.

### `/my-clean-code`
Clean up code and docs by removing unused code, fixing style violations, and applying evergreen documentation principles.

### `/my-sync`
Sync dotfiles and merge coding standards into the current repo's per-user `.claude/CLAUDE.md` (not the team's root `CLAUDE.md`).

## Setup

The install.sh script automatically symlinks `~/dotfiles/claude` to `~/.claude`, making these commands available everywhere.

## Adding New Commands

1. Create a new `my-<name>.md` file in `commands/` (prefix with `my-` to avoid conflicts)
2. Add frontmatter for metadata (description, allowed-tools, etc.)
3. Write the prompt
4. Commit and push
5. Run `/my-sync` on other machines to sync

## Example Command Template

```markdown
---
description: Brief description of what this command does
argument-hint: [optional arguments]
allowed-tools: Bash(git:*), Read, Edit
---

Your prompt here.

Use $ARGUMENTS for dynamic input.
```

## Syncing Across Machines

This repo tracks two remotes - push to both:
```bash
git push origin main && git push personal main
```

On other machines, use the `/my-sync` command or manually:
```bash
cd ~/dotfiles && git pull && ./install.sh
```

The symlink means command changes are immediately available after pull.
