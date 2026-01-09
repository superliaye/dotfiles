#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating .bashrc and .zshrc with personal bashrc"
grep -qxF ". $DOTFILES_DIR/bashrc.sh" ~/.bashrc || echo -e "\n. $DOTFILES_DIR/bashrc.sh" >> ~/.bashrc
grep -qxF ". $DOTFILES_DIR/bashrc.sh" ~/.zshrc || echo -e "\n. $DOTFILES_DIR/bashrc.sh" >> ~/.zshrc

echo "Setting up Claude config..."

# Ensure ~/.claude directory exists
mkdir -p ~/.claude

# Symlink commands and skills directories
ln -sf "$DOTFILES_DIR/claude/commands" ~/.claude/commands
ln -sf "$DOTFILES_DIR/claude/skills" ~/.claude/skills

echo "✓ Claude config ready!"
echo "Available commands:"
if ls ~/.claude/commands/*.md 1> /dev/null 2>&1; then
  for cmd in ~/.claude/commands/*.md; do
    basename "$cmd" .md | sed 's/^/  \//'
  done
else
  echo "  (none yet)"
fi