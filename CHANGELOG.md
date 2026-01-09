# Changelog

All notable changes to this dotfiles repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added
- Split bashrc into modular files (bashrc-general.sh, bashrc-microsoft.sh)
- Comprehensive agent documentation in docs/ directory
  - AGENT_GUIDE.md - Maintenance playbook and troubleshooting
  - ARCHITECTURE.md - System design and file purposes
  - DECISIONS.md - Decision-making frameworks
  - BEST_PRACTICES.md - Coding patterns and conventions
- Root README.md with quick start and overview
- .gitignore for system files and local overrides
- CHANGELOG.md for tracking changes

### Changed
- Expanded .claude/settings.local.json permissions to include npm, rush, and common tools
- Transformed bashrc.sh into a loader that sources modular files
- Updated install.sh to remove skills/ directory references and improve error handling

### Removed
- Commented-out code from bashrc.sh (lines 67-69)
- Skills directory references from install.sh

## [0.1.0] - 2026-01-09

### Added
- Initial repository setup
- bashrc.sh with git, npm, and Rush aliases
- Claude Code custom commands: /commit, /create-pr, /fix-build, /explain, /clean-code
- install.sh setup script
- Claude commands documentation in claude/README.md
