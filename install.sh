#!/usr/bin/env bash
#
# Full dotfiles setup: shell aliases + Claude Code configuration
# For Claude-only setup, use sync-claude.sh instead
#
# Usage: curl -sSL https://raw.githubusercontent.com/superliaye/dotfiles/main/install.sh | bash

set -e

# Handle curl | bash - clone repo first
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
  exec bash "$DOTFILES_DIR/install.sh"
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles..."
echo ""

# Shell configuration
echo "[1/3] Shell aliases"

# Clean up stale Codespace dotfiles reference (uses outdated persisted copy)
if [ -f ~/.bashrc ]; then
  sed -i '/\.codespaces.*dotfiles/d' ~/.bashrc 2>/dev/null || true
fi

[ -f ~/.bashrc ] && grep -qxF ". $DOTFILES_DIR/bashrc.sh" ~/.bashrc || echo -e "\n. $DOTFILES_DIR/bashrc.sh" >> ~/.bashrc
[ -f ~/.zshrc ] && grep -qxF ". $DOTFILES_DIR/bashrc.sh" ~/.zshrc || echo -e "\n. $DOTFILES_DIR/bashrc.sh" >> ~/.zshrc 2>/dev/null || true
echo "  -> Added to ~/.bashrc"

# Install Claude Code CLI
echo ""
echo "[2/3] Claude Code CLI"
if command -v claude &> /dev/null; then
  echo "  -> Already installed ($(claude --version 2>/dev/null || echo 'version unknown'))"
else
  if command -v npm &> /dev/null; then
    npm install -g @anthropic-ai/claude-code
    echo "  -> Installed via npm"
  else
    echo "  -> Skipped (npm not found)"
  fi
fi

# Claude configuration (delegate to sync-claude.sh)
echo ""
echo "[3/3] Claude Code config"
bash "$DOTFILES_DIR/sync-claude.sh"

echo ""
echo "Reload shell: source ~/.bashrc"
