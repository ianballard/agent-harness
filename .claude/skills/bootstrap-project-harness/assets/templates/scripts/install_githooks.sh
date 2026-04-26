#!/usr/bin/env bash
set -euo pipefail

# install_githooks.sh
#
# Installs repo-versioned git hooks by configuring core.hooksPath.

HOOKS_PATH="${1:-.githooks}"

if [[ ! -d "$HOOKS_PATH" ]]; then
  echo "ERROR: hooks path '$HOOKS_PATH' does not exist" >&2
  exit 1
fi

git config core.hooksPath "$HOOKS_PATH"
echo "Configured git core.hooksPath -> $HOOKS_PATH"
