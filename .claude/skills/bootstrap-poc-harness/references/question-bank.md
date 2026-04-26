# Question Bank

Use this as a short interview checklist. Keep the flow tight and do not expand it into a full factory interview unless the human changes scope.

If the human does not know an answer, record:
- `UNRESOLVED`
- a placeholder value
- whether bootstrap should stop or continue safely

## 1. Project Identity

1. What is the project name?
2. What kind of system is this?
3. Which parts of the repository should this harness cover?

## 2. Task System

1. How are tasks managed?
2. What should happen if there is no task record yet?

## 3. Dev / Test Loop

1. How do you run the project locally?
2. What is the cheapest meaningful validation step? 
3. When is e2e required?
3. What is the definition of done for a task in this repo? (testing complete? review? commit? PR?, something else?)

## 4. Safety

1. Which deploy, infrastructure, or environment mutation actions are off-limits?
2. Which read-only commands are safe by default?
3. Which actions require explicit human approval?
4. Are there safe non-prod environments the harness may mention or use?

## 5. Git

1. What branching model does the team use?
2. Are push or PR actions allowed?

## 6. Optional Structure

1. Which existing docs should the harness link to?

## 6. Output Preferences

1. Should bootstrap stop on unresolved safety answers, or continue with placeholders?
2. Which sections must never contain placeholders?
