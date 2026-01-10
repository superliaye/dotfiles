# Claude Code Setup Prompt

Copy and paste this entire prompt into Claude to set up or update your Claude Code configuration.

---

## Prompt

Set up Claude Code using my dotfiles configuration from GitHub. This handles both fresh installs and updates to existing setups.

**Source repo:** https://github.com/superliaye/dotfiles

### Steps to follow:

1. **Fetch current configuration from GitHub**
   - Base URL: `https://raw.githubusercontent.com/superliaye/dotfiles/main/`
   - Fetch these files (use WebFetch):
     - `instructions/CORE.md` - base instructions
     - `instructions/typescript.md` - TypeScript-specific instructions
     - `.claude/settings.local.json` - permissions whitelist
     - `claude/README.md` - lists available commands
   - Parse command names from `claude/README.md` (look for `### /my-<name>` headings)
   - Fetch each discovered command: `claude/commands/<name>.md`

2. **Check local state**
   - Check if `~/.claude/` directory exists
   - Read `~/.claude/CLAUDE.md` if it exists
   - Read `~/.claude/settings.local.json` if it exists
   - List files in `~/.claude/commands/` if it exists

3. **Set up instructions (`~/.claude/CLAUDE.md`)**
   - If file doesn't exist: create it with CORE.md content
   - If file exists: merge intelligently
     - Keep user's custom rules and content
     - Update/add sections from CORE.md that are missing or outdated
     - For TypeScript projects (detect via tsconfig.json or package.json): also merge typescript.md
   - Preserve any content not from the dotfiles repo

4. **Set up additional instruction files**
   - Copy other instruction files (like `typescript.md`) to `~/.claude/` if they don't exist
   - If they exist, compare and report differences (don't overwrite)

5. **Set up commands**
   - For each command file in the repo's `claude/commands/`:
     - Check if `~/.claude/commands/<filename>` exists
     - If missing: fetch and create it
     - If exists: compare content, update if repo version is newer/different
   - Report which commands were added/updated

6. **Set up permissions**
   - Read current `~/.claude/settings.local.json` if exists
   - Merge permissions arrays:
     - Keep all existing permissions
     - Add new permissions from repo that don't exist locally
     - Never remove existing permissions
   - Write merged result

7. **Report summary**
   - List what was created/updated/unchanged
   - Note any conflicts that need manual review
   - Confirm setup is complete

### Important notes:
- Always preserve user customizations
- When merging, prefer adding over replacing
- For conflicts, show both versions and ask user to choose
- Create `~/.claude/` directory if it doesn't exist
