#!/usr/bin/env bash
# block-terraform-env-check.sh
# PreToolUse hook: enforces terraform env check before plan or apply.
#
# Blocks if:
#   - Command is terraform plan or terraform apply
#   - AND env in infrastructure/terraform/terraform.tfvars is not "sandbox"
#     (or the file/key is missing)
#
# terraform destroy is handled by the permissions.deny list and never reaches here.

INPUT=$(cat)
COMMAND=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

# Only act on terraform plan/apply subcommands
if ! printf '%s' "$COMMAND" | grep -qE '\bterraform[[:space:]]+(plan|apply)\b'; then
    exit 0
fi

GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
TFVARS="${GIT_ROOT}/infrastructure/terraform/terraform.tfvars"

deny() {
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
    exit 0
}

if [ ! -f "$TFVARS" ]; then
    deny "BLOCKED: $TFVARS not found. Cannot verify env before terraform. Create the file with env = sandbox first."
fi

# Extract env value: strip key, quotes, and whitespace
TF_ENV=$(grep -E '^env[[:space:]]*=' "$TFVARS" \
    | head -1 \
    | awk -F= '{print $2}' \
    | sed 's/[[:space:]]//g; s/"//g; s/'"'"'//g')

if [ -z "$TF_ENV" ]; then
    deny "BLOCKED: env key not found in terraform.tfvars. Add env = sandbox before running terraform."
fi

case "$TF_ENV" in
    sandbox|dev|staging)
        ;;
    *)
        deny "BLOCKED: terraform env is '$TF_ENV' — only sandbox/dev/staging are allowed. NEVER run terraform plan or apply against prod."
        ;;
esac

# Also enforce aws_profile = "jg-sandbox"
TF_PROFILE=$(grep -E '^aws_profile[[:space:]]*=' "$TFVARS" \
    | head -1 \
    | awk -F= '{print $2}' \
    | sed 's/[[:space:]]//g; s/"//g; s/'"'"'//g')

if [ -z "$TF_PROFILE" ]; then
    deny "BLOCKED: aws_profile key not found in terraform.tfvars. Add aws_profile = \"jg-sandbox\" before running terraform."
fi

if [ "$TF_PROFILE" != "jg-sandbox" ]; then
    deny "BLOCKED: aws_profile is '$TF_PROFILE' — only jg-sandbox is allowed."
fi

# Also require -var="aws_profile=jg-sandbox" explicitly on plan/apply commands
if ! printf '%s' "$COMMAND" | grep -q 'aws_profile=jg-sandbox'; then
    deny "BLOCKED: terraform plan/apply must include -var=aws_profile=jg-sandbox explicitly on the command line."
fi

exit 0
