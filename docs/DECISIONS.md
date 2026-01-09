# Decision-Making Framework

This document helps agents (and humans) make consistent decisions when maintaining this repository.

## Guiding Principles

1. **Scope**: Only dotfiles-related configurations belong here
2. **Modularity**: Separate by scope, not by file size
3. **Portability**: Works across environments (Linux, macOS, Windows)
4. **Simplicity**: Prefer obvious over clever
5. **Documentation**: Explain the "why", not just the "what"

## Decision Trees

### "Should this go in the dotfiles repo?"

```
Is it a shell configuration, editor setting, or tool config?
├─ Yes → Continue
└─ No → Doesn't belong here

Is it specific to one project's codebase?
├─ Yes → Doesn't belong here (keep in that project)
└─ No → Continue

Will it work across multiple machines/environments?
├─ Yes → Belongs here
└─ No → Local override (bashrc-local.sh)
```

**Examples:**
- ✓ Git alias for pretty logs → bashrc-general.sh
- ✓ Rush build shortcuts → bashrc-microsoft.sh
- ✗ API keys or secrets → Use environment variables, not dotfiles
- ✗ Project build scripts → Keep in project repo

### "Which bashrc file should this go in?"

```
Is this specific to Microsoft/Rush/SharePoint workflows?
├─ Yes → bashrc-microsoft.sh
└─ No → Continue

Does it depend on project-specific tools or paths?
├─ Yes → bashrc-microsoft.sh
└─ No → Continue

Is it universally useful (git, ls, vim, etc.)?
├─ Yes → bashrc-general.sh
└─ No → Reconsider if it belongs at all
```

**Edge cases:**
- **Git alias for Microsoft branch names** (`gcb`) → bashrc-microsoft.sh (hardcoded username)
- **Generic git aliases** (`gp`, `gs`) → bashrc-general.sh
- **One-off machine need** → User creates bashrc-local.sh

### "Should this be a Claude command?"

```
Is it a repeatable workflow?
├─ Yes → Continue
└─ No → Just do it directly

Does it require multiple steps or context?
├─ Yes → Continue
└─ No → Probably too simple for a command

Would it benefit others (or future you)?
├─ Yes → Create command
└─ No → Consider if it's worth the overhead
```

**Examples:**
- ✓ /commit (analyzes changes, formats message, adds co-author)
- ✓ /fix-build (reads errors, fixes files, re-runs build)
- ✗ /add-alias (too simple - just edit bashrc directly)

### "Does this need documentation?"

```
Is it a new file or directory?
├─ Yes → Update ARCHITECTURE.md
└─ No → Continue

Does it introduce a new pattern or convention?
├─ Yes → Update BEST_PRACTICES.md
└─ No → Continue

Does it change how agents should maintain the repo?
├─ Yes → Update AGENT_GUIDE.md
└─ No → Continue

Is it user-facing (new command, changed behavior)?
├─ Yes → Update root README.md + CHANGELOG.md
└─ No → Commit message might be enough
```

### "Should I expand Claude permissions?"

```
Is the command needed for documented workflows?
├─ Yes → Continue
└─ No → Reject

Can it be scoped with wildcards? (e.g., git:*)
├─ Yes → Use wildcards
└─ No → Add specific pattern

Is it destructive (rm, sudo, chmod 777)?
├─ Yes → Reject
└─ No → Add to whitelist
```

**Current whitelist categories:**
- `git:*` - Version control operations
- `npm:*`, `rush:*` - Build and package management
- `ls:*`, `cat:*`, `find:*` - Read-only file operations
- `grep:*`, `tree:*`, `wc:*` - Analysis tools

**Explicitly not whitelisted:**
- `rm:*` - File deletion
- `sudo:*` - Elevated privileges
- `chmod:*`, `chown:*` - Permission changes
- `curl:*`, `wget:*` - Network operations (add if needed)

## Consistency Checks

Before committing changes, verify:

### Code Style
- [ ] Shell scripts use `#!/usr/bin/env bash`
- [ ] Functions use `function_name()` syntax (not `function function_name`)
- [ ] Comments explain "why", not "what"
- [ ] No trailing whitespace
- [ ] Consistent indentation (2 spaces)

### Documentation Style
- [ ] Headers use sentence case ("Decision-making framework", not "Decision-Making Framework")
- [ ] Code blocks specify language (```bash, not ```)
- [ ] Links use relative paths where possible
- [ ] Examples show both good (✓) and bad (✗) cases

### Git Commits
- [ ] Message starts with verb ("Add", "Update", "Fix", "Remove")
- [ ] First line under 72 characters
- [ ] Body explains why, not just what
- [ ] Co-author line if agent-assisted

## Common Scenarios

### Scenario: User asks to add a new Rush alias

**Decision process:**
1. Is it Rush-specific? → Yes → bashrc-microsoft.sh
2. Check for duplicates: `grep -r "alias <name>" bashrc*.sh`
3. Add in appropriate section with comment
4. No README update needed (minor change)
5. Commit: "Add <alias> for <purpose>"

### Scenario: User wants Claude to run npm install

**Decision process:**
1. Is npm:* whitelisted? → Check settings.local.json
2. If yes → Command allowed
3. If no → Ask user if they want to expand permissions
4. If expanding → Update settings.local.json + commit
5. Document in CHANGELOG.md if significant

### Scenario: Agent discovers commented-out code

**Decision process:**
1. Is there a comment explaining why it's kept? → No
2. Check git history: `git log -p -- <file> | grep -A5 "commented code"`
3. If no clear reason → Remove it (git history preserves it)
4. Commit: "Remove commented-out code (preserved in git history)"

### Scenario: Adding a complex multi-file feature

**Decision process:**
1. Will this benefit most users? → If no, reconsider scope
2. Does it fit the "slim start" philosophy? → If no, simplify
3. Create feature branch for testing
4. Update multiple files: code + docs + tests
5. Verify on at least one environment
6. Commit with detailed message explaining rationale
7. Update CHANGELOG.md with user-facing changes

## Anti-Patterns to Avoid

**Don't:**
- Hardcode absolute paths (use variables: `$HOME`, `$DOTFILES_DIR`)
- Mix concerns (general aliases in microsoft bashrc)
- Add dependencies without documenting them
- Commit secrets or API keys
- Over-engineer (keep it simple)
- Duplicate aliases across files
- Skip testing before committing

**Do:**
- Use relative paths from `$DOTFILES_DIR`
- Keep modules focused and cohesive
- Document dependencies in README
- Use environment variables for sensitive data
- Choose simplicity over cleverness
- Consolidate duplicates
- Test on representative environment

## When to Ask for Guidance

Agents should ask the user when:

1. Decision affects backwards compatibility
2. Unclear if change fits repository scope
3. Multiple valid approaches exist
4. Change requires destructive operation
5. User's intent is ambiguous

**Template:**
```
I want to [action], which would [effect].

Options:
1. [Option A]: [Pros/Cons]
2. [Option B]: [Pros/Cons]

Given the repository's focus on [principle], I recommend [option].
Does this align with your intent?
```
