# Best Practices

Condensed patterns and conventions for maintaining this dotfiles repository.

## Shell Scripting

### Alias vs Function

**Use aliases for:**
- Simple command substitutions
- Adding default flags
- Short abbreviations

```bash
alias gs='git status'
alias ll='ls -la'
```

**Use functions for:**
- Multi-step operations
- Logic or conditionals
- Dynamic arguments

```bash
gcb() {
  git checkout -b "user/liaye/$@"
}

rbt() {
  rush install && rush build --to "$@" && echo Finished at "$(date)"
}
```

### Variable Naming

- Uppercase for exported environment variables: `DOTFILES_DIR`
- Lowercase for local variables: `cmd_file`
- Use descriptive names, not abbreviations

```bash
# Good
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Bad
DIR="$HOME/dotfiles"  # Not dynamic, hardcoded
```

### Quoting Rules

- Always quote variables: `"$VAR"`
- Use single quotes for literal strings: `'text'`
- Double quotes for strings with variables: `"Path: $HOME"`

```bash
# Good
if [ -f "$DOTFILES_DIR/bashrc.sh" ]; then
  . "$DOTFILES_DIR/bashrc.sh"
fi

# Bad (unquoted, will break on spaces)
if [ -f $DOTFILES_DIR/bashrc.sh ]; then
  . $DOTFILES_DIR/bashrc.sh
fi
```

### Error Handling

For critical operations, check success:

```bash
# Good
if ! mkdir -p ~/.claude; then
  echo "Error: Could not create .claude directory"
  exit 1
fi

# Acceptable for non-critical
mkdir -p ~/.claude 2>/dev/null
```

### Comments

Explain "why", not "what":

```bash
# Good
# Load Microsoft aliases only on work machines to keep general configs portable
if [ "$LOAD_MICROSOFT_BASHRC" = "true" ]; then

# Bad
# Check if variable is true
if [ "$LOAD_MICROSOFT_BASHRC" = "true" ]; then
```

## Git Practices

### Commit Messages

**Format:**
```
<Verb> <what> [optional: context]

[Optional body explaining why]

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Good examples:**
```
Add Rush build aliases for AI Properties project

Update .claude permissions to include npm and rush commands

Fix install.sh to skip missing skills directory
```

**Bad examples:**
```
Update bashrc (too vague)
Added stuff (not descriptive)
Fixed it (what was fixed?)
```

### Commit Scope

**One commit should:**
- Address one logical change
- Include related documentation updates
- Pass basic verification (no syntax errors)

**Avoid:**
- Mixing unrelated changes
- Committing broken code
- Leaving TODOs uncommitted

### Branch Strategy

- Main branch: `main` (stable, working)
- Feature branches: `feature/<name>` or `fix/<name>`
- Agent work: `agent/<description>`

```bash
# For significant changes
git checkout -b feature/add-python-config

# For quick fixes
git checkout -b fix/bashrc-syntax-error
```

## Claude Code Commands

### Command Structure

**Frontmatter:**
```yaml
---
description: Brief description (shown in UI)
argument-hint: [optional arguments shown in UI]
allowed-tools: Bash(git:*), Read, Edit
---
```

**Body:**
- Clear numbered steps
- Use `$ARGUMENTS` for dynamic input
- Specify what agent should NOT do
- End with success criteria

**Example:**
```markdown
---
description: Fix build errors systematically
argument-hint: [optional: specific package]
allowed-tools: Bash(npm:*, rush:*), Read, Edit, Grep
---

Fix build or lint errors:

1. Run the build command to see errors
2. Read relevant files with errors
3. Fix each issue systematically
4. Verify fixes by running build again
5. Summarize what was fixed

Focus on: $ARGUMENTS
```

### Command Naming

- Use kebab-case: `fix-build.md`, not `fixBuild.md`
- Be descriptive: `create-pr.md`, not `pr.md`
- Match slash command: `commit.md` → `/commit`

### Allowed Tools

Be specific to minimize permission creep:

```yaml
# Good (specific)
allowed-tools: Bash(git:*), Bash(gh:*), Read

# Acceptable (controlled scope)
allowed-tools: Bash(git:*), Bash(npm:*), Read, Edit, Grep

# Bad (too broad)
allowed-tools: Bash:*
```

## Documentation

### Markdown Style

**Headers:**
- Use ATX style (`#`), not underline style
- One H1 per document
- Logical hierarchy (no skipping levels)

**Code blocks:**
- Always specify language: ```bash, not ```
- Use syntax highlighting for readability
- Keep examples runnable (no pseudocode unless noted)

**Lists:**
- Use `-` for unordered lists (consistent)
- Indent sublists with 2 spaces
- Use `1.` for ordered lists (auto-numbering)

### Link Conventions

- Relative links within repo: `[AGENT_GUIDE.md](AGENT_GUIDE.md)`
- Absolute links for external: `[Claude Docs](https://docs.anthropic.com)`
- Use descriptive text, not "click here"

### Doc Length

**Keep docs concise** (agents have context window limits):

- AGENT_GUIDE.md: ~500 lines max
- ARCHITECTURE.md: ~300 lines max
- DECISIONS.md: ~400 lines max
- BEST_PRACTICES.md: ~300 lines max (this file)

**Prefer:**
- Bullet points over paragraphs
- Examples over explanations
- Tables over prose

## Testing

### Pre-commit Checks

**For bashrc changes:**
```bash
# Syntax check
bash -n bashrc.sh
bash -n bashrc-general.sh
bash -n bashrc-microsoft.sh

# Test alias resolution
bash -c ". ./bashrc.sh && type gs"
bash -c ". ./bashrc.sh && type gcb"
```

**For install.sh changes:**
```bash
# Run in clean environment (optional but recommended)
./install.sh

# Verify symlinks created
ls -la ~/.claude/commands

# Verify bashrc updated
grep "bashrc.sh" ~/.bashrc
```

**For Claude commands:**
```bash
# Check frontmatter valid (no YAML errors)
head -10 claude/commands/<cmd>.md

# Verify command shows up
ls ~/.claude/commands/<cmd>.md
```

### Cross-Platform Testing

**Minimum:** Test on one environment (Linux, macOS, or Windows Git Bash)

**Ideal:** Test on multiple platforms if changes affect:
- Path handling (`/` vs `\`)
- Command availability (GNU vs BSD tools)
- Shell differences (bash vs zsh)

**Common gotchas:**
- `ls --color` (GNU) vs `ls -G` (BSD)
- `date` format differences
- `sed -i` behavior (GNU needs no suffix, BSD requires empty string)

## Performance

### Bashrc Loading Speed

**Keep fast:**
- Avoid expensive operations in bashrc (no network calls)
- Use lazy loading for heavy functions
- Don't source large files unconditionally

```bash
# Good (lazy load)
nvm_lazy() {
  unset -f nvm_lazy
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}
alias nvm='nvm_lazy'

# Bad (always loads NVM, slows shell startup)
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
```

### Context Window Optimization

**For agents reading this repo:**
- Keep individual files under 500 lines
- Use clear section headers (helps with search)
- Avoid repetition (DRY principle)
- Reference other files instead of duplicating content

## Security

### Never Commit

- API keys, tokens, passwords
- Absolute paths with usernames: `/Users/leon/...`
- Company-specific internal URLs
- SSH private keys

**Use instead:**
- Environment variables: `$API_KEY`
- Config files in .gitignore: `bashrc-local.sh`
- Placeholders: `<your-username>`

### Permission Whitelisting

**In .claude/settings.local.json:**

Only whitelist commands necessary for documented workflows:

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",      // Version control
      "Bash(npm:*)",      // Package management
      "Bash(ls:*)"        // Read-only operations
    ]
  }
}
```

**Never whitelist:**
- `Bash(rm:*)` - Destructive
- `Bash(sudo:*)` - Elevated privileges
- `Bash(curl:*)` - Network (unless explicitly needed)

## Maintenance Cadence

**Regular (monthly):**
- Review git log for patterns worth documenting
- Check for commented-out code to remove
- Update CHANGELOG.md with significant changes
- Verify links in documentation

**As needed:**
- Add new aliases when workflow emerges
- Create Claude commands for repeated tasks
- Update permissions when new tools needed
- Refactor when files exceed size guidelines

**Never:**
- Premature optimization (wait for proven need)
- Over-engineering (YAGNI principle)
- Breaking changes without migration path
