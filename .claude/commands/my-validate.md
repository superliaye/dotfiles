---
description: Run dotfiles validation tests
allowed-tools: Bash(docker:*, bash:*)
---

Run the dotfiles validation suite. Prefer Docker for clean isolation; fall back to direct execution.

## Run

Try Docker first:

```bash
docker build -q -f Dockerfile.test -t dotfiles-test . && docker run --rm dotfiles-test
```

If Docker is unavailable, run directly (safe — uses a temp `$HOME`):

```bash
bash test/run-tests.sh
```

## What it checks

1. `bash -n` syntax on all `*.sh` files
2. No duplicate aliases in `bashrc*.sh`
3. `sync-claude.sh` produces expected files (`CLAUDE.md`, `commands/`)
4. Re-running sync is idempotent

## On failure

Read the `[FAIL]` lines, fix the root cause, and re-run. Do not skip or suppress failing tests.
