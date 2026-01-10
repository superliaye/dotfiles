#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles configuration..."
echo ""

# Install shell configuration
echo "[1/2] Setting up shell aliases..."
grep -qxF ". $DOTFILES_DIR/bashrc.sh" ~/.bashrc || echo -e "\n. $DOTFILES_DIR/bashrc.sh" >> ~/.bashrc
grep -qxF ". $DOTFILES_DIR/bashrc.sh" ~/.zshrc || echo -e "\n. $DOTFILES_DIR/bashrc.sh" >> ~/.zshrc
echo "  ✓ Shell configuration ready"

# Install Claude Code configuration
echo ""
echo "[2/3] Setting up Claude Code configuration..."
mkdir -p ~/.claude

# Copy global CLAUDE.md if it doesn't exist
if [ ! -f ~/.claude/CLAUDE.md ]; then
  if [ -f "$DOTFILES_DIR/instructions/CORE.md" ]; then
    cp "$DOTFILES_DIR/instructions/CORE.md" ~/.claude/CLAUDE.md
    echo "  ✓ Global CLAUDE.md created"
  fi
else
  echo "  - Global CLAUDE.md already exists (skipped)"
fi

# Copy other instruction files if they don't exist
for src in "$DOTFILES_DIR/instructions/"*.md; do
  [ -f "$src" ] || continue
  filename=$(basename "$src")
  [ "$filename" = "CORE.md" ] && continue
  dest="$HOME/.claude/$filename"
  if [ ! -f "$dest" ]; then
    cp "$src" "$dest"
    echo "  ✓ $filename copied"
  else
    echo "  - $filename already exists (skipped)"
  fi
done

# Symlink commands directory
if ln -sf "$DOTFILES_DIR/claude/commands" ~/.claude/commands 2>/dev/null; then
  echo "  ✓ Commands directory linked"
else
  echo "  ! Warning: Could not link commands directory"
fi

# Sync settings
echo ""
echo "[3/3] Syncing settings..."
if [ -f "$DOTFILES_DIR/.claude/settings.local.json" ]; then
  cp "$DOTFILES_DIR/.claude/settings.local.json" ~/.claude/settings.local.json
  echo "  ✓ Settings synced"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Available Claude commands:"
if [ -d ~/.claude/commands ] && ls ~/.claude/commands/*.md 1> /dev/null 2>&1; then
  for cmd in ~/.claude/commands/*.md; do
    basename "$cmd" .md | sed 's/^/  \//'
  done
else
  echo "  (none found)"
fi

echo ""
echo "Reload your shell or run: source ~/.bashrc"
