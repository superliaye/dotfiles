#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR=$(mktemp -d)
trap "rm -rf '$TMPDIR'" EXIT
PASS=0; FAIL=0

ok()   { echo "  [pass] $1"; PASS=$((PASS+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

# 1. Bash syntax
echo "[1] Bash syntax"
for f in "$REPO_DIR"/*.sh; do
  bash -n "$f" && ok "$(basename "$f")" || fail "$(basename "$f")"
done

# 2. No duplicate aliases
echo "[2] Duplicate aliases"
dups=$(grep -h "^alias " "$REPO_DIR"/bashrc*.sh 2>/dev/null | sed 's/=.*//' | sort | uniq -d)
[ -z "$dups" ] && ok "no duplicates" || fail "duplicates found: $dups"

# 3. sync-claude.sh produces expected output
echo "[3] sync output"
HOME="$TMPDIR" SKIP_ECC=1 bash "$REPO_DIR/sync-claude.sh" > /dev/null
[ -f "$TMPDIR/.claude/CLAUDE.md" ] && ok "CLAUDE.md" || fail "missing CLAUDE.md"
[ -d "$TMPDIR/.claude/commands" ]  && ok "commands/" || fail "missing commands/"
cmds=$(ls "$TMPDIR/.claude/commands/"*.md 2>/dev/null | wc -l)
[ "$cmds" -gt 0 ] && ok "$cmds command files" || fail "no command files installed"

# 4. Idempotency
echo "[4] Idempotency"
HOME="$TMPDIR" SKIP_ECC=1 bash "$REPO_DIR/sync-claude.sh" > /dev/null
[ -f "$TMPDIR/.claude/CLAUDE.md" ] && ok "idempotent" || fail "idempotency broken"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
