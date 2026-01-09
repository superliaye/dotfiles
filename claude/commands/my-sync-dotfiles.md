---
description: Sync user's dotfiles and reinstall workspace setup
allowed-tools: Bash(git:*, bash:*)
---

Sync the user's dotfiles repository to get latest workspace configuration:

1. Find the dotfiles directory:
   ```bash
   # Common locations to check
   ls -d ~/dotfiles ~/.dotfiles ~/GitRepos/dotfiles 2>/dev/null | head -1
   ```

2. Navigate there and pull latest:
   ```bash
   cd <dotfiles_dir>
   git pull
   ```

3. Run install to update symlinks and configurations:
   ```bash
   ./install.sh
   ```

4. Tell the user to reload their shell:
   ```
   Run: source ~/.bashrc
   ```

Report what changed and confirm installation succeeded.
