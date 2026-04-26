#!/usr/bin/env bash
set -euo pipefail

# guard_cloud_identity.sh
#
# Template cloud-identity guard.
# Bootstrap a concrete project by replacing the placeholder variables below and,
# if needed, adding provider-specific identity lookup commands.

usage() {
  cat <<'EOF'
Usage:
  guard_cloud_identity.sh [options]

Options:
  --provider <name>          Provider name override
  --identity <value>         Explicit identity/profile/account/project value
  --help                     Show help

Environment:
  CLOUD_PROVIDER             Provider name
  CLOUD_REQUIRED_IDENTITY    Required identity/profile/account/project/subscription

Notes:
  A concrete project bootstrap should replace placeholder defaults and may add
  provider-specific auto-detection logic here.
EOF
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

PROVIDER="${CLOUD_PROVIDER:-}"
IDENTITY="${CLOUD_REQUIRED_IDENTITY:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --provider) PROVIDER="${2:-}"; shift 2 ;;
    --identity) IDENTITY="${2:-}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "Unknown argument: $1" ;;
  esac
done

PROVIDER="${PROVIDER:-aws}"
IDENTITY="${IDENTITY:-jg-sandbox}"

case "$PROVIDER" in
  aws)
    local_profile="${AWS_PROFILE:-}"
    if [[ -n "$local_profile" && "$local_profile" != "$IDENTITY" ]]; then
      die "AWS profile '$local_profile' does not match required identity '$IDENTITY'"
    fi
    ;;
  gcp|azure|kubernetes|other)
    die "Provider '$PROVIDER' is not configured for this repository"
    ;;
  *)
    die "Unknown provider '$PROVIDER'"
    ;;
esac

echo "cloud identity ok: provider=$PROVIDER identity=$IDENTITY"
