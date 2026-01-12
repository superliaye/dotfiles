#!/usr/bin/env bash
#
# Sync Claude Code configuration to ~/.claude/ (overwrites existing)
# Works on: Windows (Git Bash/WSL), macOS, Linux, Codespaces
#
# Usage:
#   Git Bash / macOS / Linux:
#     curl -sSL https://raw.githubusercontent.com/superliaye/dotfiles/main/sync-claude.sh | bash
#   Windows PowerShell:
#     curl.exe -sSL https://raw.githubusercontent.com/superliaye/dotfiles/main/sync-claude.sh | & 'C:\Program Files\Git\bin\bash.exe'

set -e

# Handle curl | bash - clone/update repo first
if [ ! -f "${BASH_SOURCE[0]}" ] || [ "${BASH_SOURCE[0]}" = "/dev/stdin" ]; then
  DOTFILES_DIR="${HOME}/dotfiles"
  if [ -d "$DOTFILES_DIR/.git" ]; then
    echo "Updating dotfiles..."
    git -C "$DOTFILES_DIR" pull --quiet
  else
    echo "Cloning dotfiles..."
    git clone --quiet https://github.com/superliaye/dotfiles.git "$DOTFILES_DIR"
  fi
  chmod +x "$DOTFILES_DIR"/*.sh
  exec bash "$DOTFILES_DIR/sync-claude.sh"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Syncing Claude configuration..."

# Remove existing and recreate
rm -rf "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/commands"

# Copy instructions (CORE.md -> CLAUDE.md, others as-is)
cp "$SCRIPT_DIR/instructions/CORE.md" "$CLAUDE_DIR/CLAUDE.md"
for f in "$SCRIPT_DIR/instructions/"*.md; do
  [ "$(basename "$f")" = "CORE.md" ] && continue
  cp "$f" "$CLAUDE_DIR/"
done

# Copy commands
cp "$SCRIPT_DIR/claude/commands/"*.md "$CLAUDE_DIR/commands/"

# Copy settings
cp "$SCRIPT_DIR/.claude/settings.local.json" "$CLAUDE_DIR/"

echo ""
echo "Done! Synced to $CLAUDE_DIR"
echo "  - CLAUDE.md + $(ls "$SCRIPT_DIR/instructions/"*.md 2>/dev/null | wc -l | tr -d ' ') instruction files"
echo "  - $(ls "$CLAUDE_DIR/commands/"*.md 2>/dev/null | wc -l | tr -d ' ') commands"
echo "  - settings.local.json"
