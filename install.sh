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
echo "[2/2] Setting up Claude Code configuration..."
mkdir -p ~/.claude

# Symlink commands directory
if ln -sf "$DOTFILES_DIR/claude/commands" ~/.claude/commands 2>/dev/null; then
  echo "  ✓ Commands directory linked"
else
  echo "  ! Warning: Could not link commands directory"
fi

# Copy settings if they don't exist (don't overwrite existing)
if [ -f "$DOTFILES_DIR/.claude/settings.local.json" ] && [ ! -f ~/.claude/settings.local.json ]; then
  cp "$DOTFILES_DIR/.claude/settings.local.json" ~/.claude/settings.local.json
  echo "  ✓ Settings copied"
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
