#!/usr/bin/env bash
# Regenerate the integrity baseline for .claude/ control files.
# Run after any approved change to settings, agents, hooks, or skills.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
BASELINE="$REPO_ROOT/.claude/integrity-baseline.sha256"

# Collect all control files
FILES=()

# Settings
[ -f "$REPO_ROOT/.claude/settings.json" ] && FILES+=("$REPO_ROOT/.claude/settings.json")

# Agent definitions
for f in "$REPO_ROOT/.claude/agents/"*.md; do
  [ -f "$f" ] && FILES+=("$f")
done

# Hook scripts
for f in "$REPO_ROOT/.claude/hooks/"*.sh; do
  [ -f "$f" ] && FILES+=("$f")
done

# Skill definitions
for f in "$REPO_ROOT/.claude/skills/"*/*.md; do
  [ -f "$f" ] && FILES+=("$f")
done

# Generate SHA-256 checksums
> "$BASELINE"
for f in "${FILES[@]}"; do
  REL_PATH="${f#$REPO_ROOT/}"
  shasum -a 256 "$f" | awk -v p="$REL_PATH" '{print $1 "  " p}' >> "$BASELINE"
done

echo "Integrity baseline updated: $BASELINE"
echo "$(wc -l < "$BASELINE" | tr -d ' ') files checksummed."
