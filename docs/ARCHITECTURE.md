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
├── bashrc-general.sh            # Universal shell aliases and functions
├── bashrc-microsoft.sh          # Project-specific configurations
├── install.sh                   # Setup script (creates symlinks)
├── README.md                    # User-facing documentation
├── CHANGELOG.md                 # Change tracking
├── .gitignore                   # Exclude temp files, local overrides
├── .claude/
│   └── settings.local.json      # Claude Code permissions
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
- Sources general and project-specific bashrc files
- Conditionally loads based on environment detection
- Minimal logic - just sourcing

**bashrc-general.sh** (Universal)
- Aliases/functions that work anywhere (git, ls, vim)
- No project dependencies
- No hardcoded paths
- Safe for all machines

**bashrc-microsoft.sh** (Project-Specific)
- Rush/NPM workflows for SharePoint development
- Microsoft-specific shortcuts
- Only loaded when detected or explicitly enabled

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

**.claude/settings.local.json** (Permissions)
- Whitelists bash command patterns
- Prevents accidental destructive operations
- Copied (not symlinked) to ~/.claude/ by install.sh
- Can be overridden per machine

### Setup and Configuration

**install.sh** (Setup Script)
- Appends source line to ~/.bashrc and ~/.zshrc
- Creates symlinks for Claude commands
- Copies settings if not present
- Idempotent (safe to run multiple times)

**.gitignore** (Exclusions)
- OS-specific files (.DS_Store, Thumbs.db)
- Editor configs (.vscode, .idea)
- Local overrides (bashrc-local.sh, settings.local.json)

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
Copy settings: ~/dotfiles/.claude/settings.local.json → ~/.claude/
  ↓
User reloads shell (source ~/.bashrc)
  ↓
bashrc.sh loads → sources bashrc-general.sh + bashrc-microsoft.sh (if detected)
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

**For bashrc-microsoft.sh loading:**

The loader (`bashrc.sh`) uses two methods to detect Microsoft environments:

1. **Explicit override:** `export LOAD_MICROSOFT_BASHRC=true`
2. **Auto-detect:** Check if `$HOME/repos` directory exists (common pattern)

Users can customize this detection in bashrc.sh without affecting other files.

## Extension Points

### Adding New Configuration Modules

To add a new bashrc module (e.g., `bashrc-python.sh`):

1. Create `bashrc-<name>.sh` with relevant aliases
2. Add sourcing logic to `bashrc.sh`:
   ```bash
   if [ -f "$DOTFILES_DIR/bashrc-<name>.sh" ]; then
     . "$DOTFILES_DIR/bashrc-<name>.sh"
   fi
   ```
3. Update ARCHITECTURE.md (this file)
4. Add entry to .gitignore if needed

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

**Why split bashrc files?**
- Context window efficiency (agents read less)
- Modularity (general configs portable)
- Easier maintenance (clear boundaries)

**Why docs/ directory?**
- Separates agent docs from user docs
- Keeps root clean (less clutter)
- Allows growth without bloat

## Future Considerations

Potential additions (not planned, but architecturally sound):

- `bashrc-python.sh` - Python virtualenv helpers
- `bashrc-docker.sh` - Docker shortcuts
- `claude/skills/` - Automated Claude workflows
- `bin/` - Custom scripts (add to PATH)

All would follow existing patterns (modular, documented, optional).
