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

PROVIDER="${PROVIDER:-<cloud-provider>}"
IDENTITY="${IDENTITY:-<required-cloud-identity>}"

if [[ "$PROVIDER" == "<cloud-provider>" ]]; then
  die "Bootstrap required: replace CLOUD_PROVIDER placeholder"
fi
if [[ "$IDENTITY" == "<required-cloud-identity>" ]]; then
  die "Bootstrap required: replace CLOUD_REQUIRED_IDENTITY placeholder"
fi

case "$PROVIDER" in
  aws|gcp|azure|kubernetes|other)
    ;;
  *)
    die "Unknown provider '$PROVIDER'. Bootstrap should set an expected provider name."
    ;;
esac

echo "cloud identity requirement configured: provider=$PROVIDER identity=$IDENTITY"
echo "Bootstrap should extend this script with provider-specific identity verification commands."
