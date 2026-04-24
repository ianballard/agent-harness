---                                                                                                                                                                                                      
name: task-refinement-interview
description: >-
    Conducts a structured interview to gather missing requirements when a
    backlog task is too vague to implement. Use when task-intake detects missing problem                                                                                                                   
    definition, acceptance criteria, context, constraints, scope, or functional/non-functional
    requirements. Trigger on INTAKE_BLOCKED due to insufficient definition, when the                                                                                                                       
    coordinator's optional refinement gate is enabled, or when the user asks to flesh
    out or refine a vague task.                                                                                                                                                                            
---
                                                                                                                                                                                                        
## Purpose                

A well-defined task lets an implementer work without back-and-forth. This skill
guides a structured interview to fill gaps. Only ask about what's actually missing
— don't re-ask things the task already answers.                                                                                                                                                          

## Step 1: Audit the task                                                                                                                                                                                
                                                                                                                                                                                                        
Read the task and note what's present and absent across these categories:
                                                                                                                                                                                                        
| Category | What to look for |
|----------|-----------------|
| **Problem** | What's broken, missing, or needed? Why does it matter? |
| **Expected outcome** | What does success look like from the user's perspective? |
| **Validation** | How will we verify it's correct? Specific test cases or scenarios? |                                                                                                                  
| **Context** | Background, current behavior, affected users, related systems |
| **Constraints** | Technical, time, compatibility, or backward-compatibility limits |                                                                                                                   
| **Scope** | What's explicitly in vs. out |                                                                                                                                                             
| **Functional requirements** | What the feature/fix must *do*, including error states |
| **Non-functional requirements** | Performance, security, accessibility targets |                                                                                                                       
| **Failure modes** | What can go wrong, trade-offs already decided, degraded behavior |                                                                                                                 
                                                                                                                                                                                                        
## Step 2: Interview in focused rounds                                                                                                                                                                   
                                                                                                                                                                                                        
Ask one round at a time. Wait for answers before moving to the next round.
                                                                                                                                                                                                        
### Round 1 — Problem and outcome (if missing)
Establish *what* and *why* before *how*.                                                                                                                                                                 
                        
- "What's currently happening that shouldn't be, or what's missing that should exist?"
- "Who is affected, and what's the impact if this isn't addressed?"
- "If this is done perfectly, what can someone do that they can't do now?"                                                                                                                               

### Round 2 — Validation (if missing)                                                                                                                                                                    
Pin down what "done" means before scoping anything else.

- "How would you verify this works correctly — what would you check?"
- "Are there specific scenarios or edge cases that must pass?"                                                                                                                                           
- "Is there an existing bug report, screenshot, or example that shows what's wrong?"
                                                                                                                                                                                                        
### Round 3 — Scope and constraints (if missing)
Boundary-setting prevents scope creep and surprises during implementation.
                                                                                                                                                                                                        
- "Is there anything related that might seem in scope but should explicitly be excluded?"
- "Are there technical constraints — framework versions, browser support, API limits,                                                                                                                    
backward compatibility requirements?"
- "Must this work on mobile? For anonymous users, or authenticated only?"
                                                                                                                                                                                                        
### Round 4 — Functional requirements (if missing)
Walk through the key behaviors expected.                                                                                                                                                                 
                        
- "Walk me through the main actions a user takes — what must the system do at each step?"
- "What happens when something goes wrong — are there error states to handle?"
                                                                                                                                                                                                        
### Round 5 — Non-functional requirements (only when relevant)
Ask only for tasks touching performance, security, or accessibility.                                                                                                                                     
                        
- "Are there performance targets — page load time, API response time, throughput?"
- "Are there accessibility requirements (WCAG level, screen reader support)?"
- "Are there security requirements around authentication, authorization, or data handling?"                                                                                                              

### Round 6 — Failure modes and trade-offs (always ask)                                                                                                                                                  
Understanding how failure should be handled is as important as defining success.
                                                                                                                                                                                                        
- "What are the most likely ways this could fail or produce incorrect results?"
- "If this feature partially fails or degrades, what's acceptable behavior — fail                                                                                                                        
visibly with an error, fail silently, or fall back to a default?"
- "Are there trade-offs you've already decided on — for example, speed over accuracy,                                                                                                                    
eventual consistency over strong consistency, simplicity over edge-case handling?"                                                                                                                     
- "What should happen if a dependency (external API, database, third-party service)                                                                                                                      
is unavailable when this runs?"                                                                                                                                                                        
- "Are there data integrity concerns — what if the operation only partially completes?"
                                                                                                                                                                                                        
## Step 3: Update the task
                                                                                                                                                                                                        
Write gathered information back to the task:

```bash
# Refine the description if the original was vague
backlog task edit <id> --description "<refined problem statement>"

# Add acceptance criteria — one per --ac flag
backlog task edit <id> --ac "<criterion 1>" --ac "<criterion 2>"                                                                                                                                         

# Add context, constraints, scope, and failure handling as a note                                                                                                                                        
backlog task edit <id> --append-notes "Context: <background and affected users>                                                                                                                          

Constraints: <technical or business constraints>                                                                                                                                                         
                        
In scope: <explicit inclusions>
Out of scope: <explicit exclusions>
                                                                                                                                                                                                        
Failure modes and trade-offs: <degraded behavior, known trade-offs, dependency failure handling>
                                                                                                                                                                                                        
Non-functional requirements: <only if applicable>"
                                                                                                                                                                                                        
Step 4: Confirm and summarize gaps

Read the updated task back and ask the human to confirm it captures their intent.                                                                                                                        

If any category remains unresolved after the interview, note it explicitly — this                                                                                                                        
becomes the <missing requirements summary> passed back to task-intake if the
task still cannot be actioned.                                                                                                                                                                           
                        
Quality bar                                                                                                                                                                                              
                        
A task is ready when someone reading it cold can:                                                                                                                                                        
1. Understand the problem without asking follow-ups
2. Know exactly what to build and what not to build                                                                                                                                                      
3. Independently verify whether the implementation is complete and correct