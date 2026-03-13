#!/usr/bin/env bash
# Dotfiles bashrc loader

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$DOTFILES_DIR/bashrc-aliases.sh" ]; then
  . "$DOTFILES_DIR/bashrc-aliases.sh"
fi
