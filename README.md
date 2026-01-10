# Personal Dotfiles

A minimal, modular dotfiles repository optimized for cross-machine synchronization and agent-friendly maintenance.

## Claude Code Setup

One-liner to sync Claude configuration:

```bash
# Git Bash / macOS / Linux / Codespaces
curl -sSL https://raw.githubusercontent.com/superliaye/dotfiles/main/sync-claude.sh | bash

# Windows PowerShell
curl.exe -sSL https://raw.githubusercontent.com/superliaye/dotfiles/main/sync-claude.sh | & 'C:\Program Files\Git\bin\bash.exe'
```

This syncs to `~/.claude/`:
- Instructions (`CLAUDE.md`, `typescript.md`)
- Commands (`/my-commit`, `/my-sync`, etc.)
- Permissions (merged with existing)

Run again anytime to pull updates. Works even when repos gitignore `.claude/`.

## Quick Start (Full Clone)

```bash
git clone https://github.com/superliaye/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
source ~/.bashrc
```

## What's Included

### Shell Configuration
- **bashrc-general.sh** - Universal aliases (git, ls, vim, etc.)
- **bashrc-microsoft.sh** - Project-specific Rush/NPM workflows
- **bashrc.sh** - Loader that intelligently sources both

### Claude Code Integration
- **claude/commands/** - Custom Claude Code commands (/commit, /create-pr, etc.)
- **claude/README.md** - Command documentation and usage

### Configuration
- **.claude/settings.local.json** - Permissions for Claude Code operations
- **install.sh** - Automated setup script

## Structure Philosophy

This repository follows a "slim start" approach:
- Modular configuration (general vs. project-specific)
- Minimal dependencies
- Agent-friendly documentation
- Easy to maintain and extend

## For AI Agents

See [docs/AGENT_GUIDE.md](docs/AGENT_GUIDE.md) for maintenance instructions and decision-making frameworks.

## Syncing Across Machines

After setup on first machine:
```bash
cd ~/dotfiles && git pull
```

Changes take effect immediately (symlinks) - no reinstall needed.

## Customization

Create `bashrc-local.sh` for machine-specific overrides:
```bash
# bashrc-local.sh (not committed)
export CUSTOM_VAR="value"
alias custom='echo "local only"'
```

Load it in your ~/.bashrc after the dotfiles sourcing:
```bash
. ~/dotfiles/bashrc.sh
[ -f ~/dotfiles/bashrc-local.sh ] && . ~/dotfiles/bashrc-local.sh
```

## Documentation

- [Agent Maintenance Guide](docs/AGENT_GUIDE.md) - How agents maintain this repo
- [Architecture](docs/ARCHITECTURE.md) - System design and file purposes
- [Decision Framework](docs/DECISIONS.md) - "Where should this go?" decision trees
- [Best Practices](docs/BEST_PRACTICES.md) - Coding patterns and conventions

## License

Personal use. Feel free to fork and adapt to your needs.
