---
name: implement-aws-changes
description: Use when implementing or fixing AWS work in Terraform, AWS CLI, boto3, or IAM. Verify syntax and behavior against official AWS docs and Context7, and validate IAM actions, resources, and context keys before relying on retry-driven debugging.
---

# AWS implementation

Use this skill for AWS implementation and debugging work involving Terraform, AWS CLI, boto3, IAM, Bedrock, AgentCore, Lambda, API Gateway, Cognito, CloudWatch, EventBridge, S3, DynamoDB, and similar AWS services.

## AWS Profile — jg-sandbox is mandatory

- Every `aws` CLI command MUST include `--profile jg-sandbox`. No exceptions.
- Every `terraform plan` and `terraform apply` command MUST include `-var="aws_profile=jg-sandbox"` explicitly on the command line — e.g. `terraform plan -target=<resource> -var="aws_profile=jg-sandbox"`. The value is also set in `terraform.tfvars` as a fallback, but the CLI flag is required.
- Any command missing the profile or using a different profile is blocked by hooks.

## Goals

- Stop relying on memory for Terraform arguments, CLI flags, boto3 request shapes, and IAM permissions.
- Use primary AWS sources before coding.
- Catch IAM gaps before runtime where possible.

## Required sources

For AWS implementation work, use these sources in this order:

1. Official AWS service documentation
2. Context7 for up-to-date library, SDK, and provider usage guidance
3. Existing repo code only after the service contract is confirmed

Do not treat prior local examples as authoritative until they are checked against AWS docs.

## Required workflow

### 1. Confirm the service contract before editing

For every AWS change, verify all three surfaces that apply:

- Terraform:
  Check the exact resource, nested block names, argument names, computed attributes, and import behavior against official docs and Context7 provider guidance.
- AWS CLI:
  Check the exact service namespace, command name, required flags, accepted payload fields, and response shape against official AWS docs.
- boto3 / API:
  Check the exact client name, operation name, request parameter names, response fields, and waiter or polling model against official AWS docs and SDK references.

If the code and the docs disagree, the docs win.

### 2. Validate IAM before shipping

Before adding or changing IAM, always check:

- Service authorization reference:
  https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html
- IAM policy simulator:
  https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_testing-policies.html#policies-simulator-using-api
- IAM Access Analyzer policy validation:
  https://docs.aws.amazon.com/cli/latest/reference/accessanalyzer/validate-policy.html

Use them to answer:

- Which actions are actually required?
- Which resource types support those actions?
- Which condition keys or context keys apply?
- Are wildcard resources avoidable?
- Does the policy contain invalid or ineffective statements?

### 3. Implement with explicit permission reasoning

When adding IAM statements, write them from verified facts:

- Action list from the service authorization reference or API docs
- Resource ARN pattern from the service authorization reference or service docs
- Condition keys only when the docs say the action supports them

If an action requires multiple resources, model that explicitly.
If one action must apply to a gateway ARN and another only to a policy-engine ARN, split the statements instead of broadening everything.

### 4. Verify after editing

Minimum verification for AWS implementation work:

- Relevant unit tests
- Terraform formatting / validation / plan when Terraform changed
- Dry-run or help output for CLI workflows when applicable
- A short note listing the AWS docs checked and the IAM actions/resources validated

If runtime validation still fails, use the exact AWS error to refine permissions or request shape. Do not guess from memory.

## IAM debugging checklist

When AWS returns `AccessDenied`, `ValidationException`, or a policy-engine error:

1. Identify the exact action from the error message.
2. Identify the exact resource ARN from the error message.
3. Check the service authorization reference for supported resource types and context keys.
4. Check whether the failing principal is the caller, an assumed role, a service role, or a gateway/runtime execution role.
5. Use the policy simulator and Access Analyzer guidance before broadening permissions.
6. Prefer adding the narrow missing action/resource pair rather than expanding unrelated statements.

## Output requirements

When closing out AWS implementation work, include:

- The official AWS docs used
- The Terraform / CLI / boto3 surfaces that were verified
- The IAM actions and resource scopes that were validated
- Whether policy simulator or Access Analyzer checks were run, or what blocked them

## Example prompts

- `Use implement-aws-changes to add a new AgentCore gateway target in Terraform and verify the CLI flow.`
- `Use implement-aws-changes to fix this boto3 request shape for Bedrock AgentCore.`
- `Use implement-aws-changes to debug an AccessDenied error for an AWS role and narrow the IAM policy correctly.`
- `Use implement-aws-changes to verify this Terraform resource against official AWS docs and Context7 before editing.`
