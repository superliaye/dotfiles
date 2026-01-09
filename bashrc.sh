#!/usr/bin/env bash
# Dotfiles bashrc loader
# This file sources the appropriate bashrc modules

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Always load general aliases
if [ -f "$DOTFILES_DIR/bashrc-general.sh" ]; then
  . "$DOTFILES_DIR/bashrc-general.sh"
fi

# Load Microsoft-specific aliases if on work machines
# Automatically detect or allow manual override with: export LOAD_MICROSOFT_BASHRC=true
if [ -f "$DOTFILES_DIR/bashrc-microsoft.sh" ]; then
  if [ "$LOAD_MICROSOFT_BASHRC" = "true" ] || [ -d "$HOME/repos" ]; then
    . "$DOTFILES_DIR/bashrc-microsoft.sh"
  fi
fi
