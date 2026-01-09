# Claude Code Configuration

Personal Claude commands and skills for use across all environments.

## Available Commands

### `/commit`
Create a detailed git commit with comprehensive summary. Analyzes all changes and follows best practices.

### `/create-pr`
Create a pull request with detailed description based on all commits and changes in the branch.

### `/fix-build`
Analyze and fix build/lint errors systematically.

Usage: `/fix-build [optional: specific package]`

### `/explain`
Explain code with clear examples and context. Reads files, understands patterns, and provides practical explanations.

### `/clean-code`
Clean up code by removing unused code, fixing style violations, and improving quality.

## Setup

The install.sh script automatically symlinks `~/dotfiles/claude` to `~/.claude`, making these commands available everywhere.

## Adding New Commands

1. Create a new `.md` file in `commands/`
2. Add frontmatter for metadata (description, allowed-tools, etc.)
3. Write the prompt
4. Commit and push
5. Run `cd ~/dotfiles && git pull` on other machines to sync

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

After pushing changes:
```bash
cd ~/dotfiles && git pull
```

The symlink means changes are immediately available - no need to re-run install.sh.
