# Repository Architecture

## Design Philosophy

This dotfiles repository is designed around three core principles:

1. **Modularity** - Configurations separated by scope (general vs. project)
2. **Portability** - Works across Linux, macOS, Windows (Git Bash/WSL)
3. **Agent-Friendly** - Clear structure, concise docs, easy to parse

## Directory Structure

```
dotfiles/
├── bashrc.sh                    # Loader that sources other bashrc files
├── bashrc-aliases.sh             # All shell aliases and functions
├── install.sh                   # Setup script (creates symlinks)
├── README.md                    # User-facing documentation
├── CHANGELOG.md                 # Change tracking
├── .gitignore                   # Exclude temp files, local overrides
├── claude/
│   ├── README.md                # Command documentation
│   └── commands/                # Custom Claude Code commands
│       ├── commit.md
│       ├── create-pr.md
│       ├── fix-build.md
│       ├── explain.md
│       └── clean-code.md
└── docs/
    ├── AGENT_GUIDE.md           # Agent maintenance playbook
    ├── ARCHITECTURE.md          # This file
    ├── DECISIONS.md             # Decision-making framework
    └── BEST_PRACTICES.md        # Coding/tooling patterns
```

## File Purposes

### Shell Configuration

**bashrc.sh** (Loader)
- Sources bashrc-aliases.sh
- Minimal logic - just sourcing

**bashrc-aliases.sh** (All Aliases)
- Universal aliases (git, ls, vim)
- Rush/NPM workflows for SharePoint development
- Microsoft-specific shortcuts
- Always loaded by bashrc.sh

**bashrc-local.sh** (Not committed)
- Machine-specific overrides
- User creates manually if needed
- Listed in .gitignore

### Claude Code Integration

**claude/commands/** (Custom Commands)
- Each .md file = one slash command
- Frontmatter defines behavior (description, allowed-tools)
- Symlinked to ~/.claude/commands by install.sh
- Auto-synced via git pull (no reinstall)

### Setup and Configuration

**install.sh** (Setup Script)
- Appends source line to ~/.bashrc and ~/.zshrc
- Creates symlinks for Claude commands
- Idempotent (safe to run multiple times)

**.gitignore** (Exclusions)
- OS-specific files (.DS_Store, Thumbs.db)
- Editor configs (.vscode, .idea)
- Local overrides (bashrc-local.sh)

### Documentation

**Root README.md** (User Documentation)
- Quick start, structure overview, syncing instructions
- Entry point for humans
- Links to agent docs

**docs/** (Agent Documentation)
- AGENT_GUIDE.md - Maintenance how-to
- ARCHITECTURE.md - System design (this file)
- DECISIONS.md - Decision framework
- BEST_PRACTICES.md - Patterns and conventions

## Data Flow

### Installation Flow
```
User runs install.sh
  ↓
Append source line to ~/.bashrc, ~/.zshrc
  ↓
Create symlink: ~/.claude/commands → ~/dotfiles/claude/commands
  ↓
User reloads shell (source ~/.bashrc)
  ↓
bashrc.sh loads → sources bashrc-aliases.sh
  ↓
Aliases available
  ↓
Claude commands available in Claude Code UI
```

### Update Flow
```
User commits changes to git
  ↓
Push to remote
  ↓
On other machine: cd ~/dotfiles && git pull
  ↓
Symlinks ensure changes immediately available (no reinstall)
  ↓
User reloads shell if bashrc changed
```

## Environment Detection Logic

The loader (`bashrc.sh`) unconditionally sources `bashrc-aliases.sh`.

## Extension Points

### Adding New Configuration Modules

Add new aliases directly to `bashrc-aliases.sh` in the appropriate section.

### Adding New Claude Commands

1. Create `claude/commands/<command>.md`
2. Follow existing patterns (frontmatter, $ARGUMENTS)
3. Update `claude/README.md`
4. No install.sh changes needed (symlink handles it)

## Design Constraints

**Why symlinks?**
- Changes sync instantly (no reinstall)
- Claude Code expects ~/.claude/ location
- Users can override per-machine without affecting repo

**Why a single alias file?**
- Simpler to maintain (one place for all aliases)
- No conditional loading logic needed
- Easier to search for duplicates

**Why docs/ directory?**
- Separates agent docs from user docs
- Keeps root clean (less clutter)
- Allows growth without bloat

## Future Considerations

Potential additions (not planned, but architecturally sound):

- Python virtualenv helpers (add to bashrc-aliases.sh)
- Docker shortcuts (add to bashrc-aliases.sh)
- `claude/skills/` - Automated Claude workflows
- `bin/` - Custom scripts (add to PATH)

All would follow existing patterns (modular, documented, optional).
