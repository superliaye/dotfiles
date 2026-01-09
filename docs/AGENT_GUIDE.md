# Agent Maintenance Guide

This document helps AI agents maintain and extend this dotfiles repository effectively.

## Repository Mission

Provide a lean, modular, agent-friendly dotfiles system that:
- Works across machines (local, SSH, codespaces)
- Separates general from project-specific configurations
- Minimizes context window overhead
- Enables AI-driven maintenance

## Maintenance Principles

1. **Modularity First** - Keep configurations separated by scope
2. **Documentation as Code** - Every decision should be traceable
3. **Context Window Aware** - Prefer concise over comprehensive
4. **Backwards Compatible** - Don't break existing workflows
5. **Test Before Commit** - Verify changes work across environments

## Common Maintenance Tasks

### Adding a New Alias

**Location decision:**
- General purpose (git, ls, etc.) → `bashrc-general.sh`
- Project-specific (Rush, Microsoft tools) → `bashrc-microsoft.sh`
- One machine only → User creates `bashrc-local.sh`

**Process:**
1. Read relevant bashrc file
2. Add alias in appropriate section (with comment)
3. Update CHANGELOG.md if significant
4. Test: `bash -c ". ./bashrc.sh && type <alias_name>"`

### Adding a Claude Command

**Process:**
1. Create `claude/commands/<command-name>.md`
2. Use frontmatter: description, allowed-tools, argument-hint
3. Write clear, actionable prompt
4. Update `claude/README.md` with command description
5. Test: Run install.sh, verify command appears

### Modifying Permissions

**File:** `.claude/settings.local.json`

**Guidelines:**
- Use wildcards for command families: `Bash(git:*)`
- Avoid overly specific paths (brittle)
- Never allow destructive commands globally: `rm -rf`, `sudo`
- Test: Attempt blocked command, verify it's denied

### Updating Documentation

**When to update:**
- Architecture changes → `ARCHITECTURE.md`
- New patterns/conventions → `BEST_PRACTICES.md`
- Decision rationale → `DECISIONS.md`
- User-facing changes → root `README.md` + `CHANGELOG.md`

## Decision-Making Framework

See [DECISIONS.md](DECISIONS.md) for detailed framework.

**Quick checklist:**
- [ ] Does this belong here? (dotfiles scope)
- [ ] General or project-specific?
- [ ] Will this work across environments?
- [ ] Does it increase complexity unnecessarily?
- [ ] Is documentation needed?

## Verification Checklist

Before committing changes:

**For bashrc changes:**
- [ ] No syntax errors: `bash -n bashrc*.sh`
- [ ] Aliases resolve: `bash -c ". ./bashrc.sh && type <alias>"`
- [ ] No hardcoded paths (use variables)

**For Claude commands:**
- [ ] Frontmatter valid (description, allowed-tools)
- [ ] Uses $ARGUMENTS for dynamic input
- [ ] Command appears in Claude UI after install

**For documentation:**
- [ ] Links work (no 404s)
- [ ] Code examples are valid
- [ ] Follows repository style (concise, practical)

**For all changes:**
- [ ] Git status is clean (no untracked junk)
- [ ] Commit message follows conventions
- [ ] Changes tested on at least one environment

## Troubleshooting Common Issues

### "Command not found" after install

**Cause:** Shell not reloaded or bashrc not sourced
**Fix:**
```bash
source ~/.bashrc
# or
exec $SHELL
```

### Claude command doesn't appear

**Cause:** Symlink not created or .md file malformed
**Fix:**
```bash
ls -la ~/.claude/commands  # Verify symlink
cat ~/.claude/commands/<cmd>.md  # Check frontmatter
```

### Alias conflicts

**Cause:** Duplicate definitions across bashrc files
**Fix:** Grep for alias name, remove duplicates:
```bash
grep -r "alias <name>" bashrc*.sh
```

## Getting Help

**For agents:**
1. Read relevant docs in `docs/`
2. Search for patterns: `grep -r "<pattern>" .`
3. Check git history: `git log --all --grep="<keyword>"`
4. Review recent changes: `git diff HEAD~5..HEAD`

**For users:**
- Open an issue with: OS, shell version, error message
- Include output of: `bash -x bashrc.sh` (verbose mode)
