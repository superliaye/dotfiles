---
description: Create a detailed git commit and push to remote
allowed-tools: Bash(git:*)
---

Create a git commit and push, following best practices:

1. Run git status and git diff to see changes
2. Analyze all changes (not just latest)
3. Create a commit message with:
   - Clear summary line
   - Detailed breakdown of changes
   - Why the changes were made
   - Build/test status if applicable

Always end with:
```
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

4. After successful commit, push to the remote tracking branch
