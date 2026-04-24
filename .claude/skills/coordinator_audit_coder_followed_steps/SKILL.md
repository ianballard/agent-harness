---
name: coordinator-audit-coder-followed-steps
description: Use for coordinator, auditing whether coder followed all required steps.
---

## Audit Coder Followed All Steps

Review the coder's output and the task notes to confirm each required step ran:                                                                                                                          

- **Unit tests** — did the coder run tests and report results?                                                                                                                                           
- **Deploy** — if the configured deployment policy required deploy-oriented steps, did the coder run them?
- **E2e tests** — did the coder run e2e tests and report results?
- **Implementation notes** — does the task have an `## Implementation Notes` section in its notes?                                                                                                       
- **Commit** — was a commit made?
                                                                                                                                                                                                        
If all steps are accounted for, proceed to the next coordinator step.
                                                                                                                                                                                                        
If any required step was skipped, dispatch the coder to complete the remaining steps:

Agent: coder                                                                                                                                                                                             
Prompt: "Complete the remaining steps for task . The following steps were skipped and must be run now: . Start from step  in coder.md and complete all remaining steps. Output CODER_DONE when done."
                                                                                                                                                                                                        
If the coder returns `CODER_BLOCKED: <reason>`:
- append the blocked reason through the configured task-system interface                                                                                                                       
- output `FACTORY_BLOCKED: coder blocked on audit retry for task <id> — <reason>`                                                                                                                        
- stop.
        
