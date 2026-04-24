---
name: read-session-memories
description: >-
  Retrieves context from `.claude/memories.md` using size-aware full read, grep,
  line-window reads, and follow-the-reference retrieval. Use when CLAUDE.md or
  the user mentions session memories, prior compact/hook context, or
  cross-session continuity; also when answering questions that may have been
  recorded in memories.
---

# Read session memories effectively

**File:** `.claude/memories.md` (repository root). Populated by hooks (e.g. post-compact); entries are usually **chronological** with newer content toward the **end**.

## 1. Choose a retrieval strategy first

| Situation | Technique |
|-----------|-----------|
| Unknown size or first touch this turn | **Probe** (short read or line count), then pick below |
| File is tiny (roughly ≤ ~100 lines) | **Full read** once |
| Looking for a topic, name, task id, path, or error string | **Grep** with context, then **window read** around hits |
| Need “what happened lately” | **Tail read**: `Read` with `offset` near end (last 80–200 lines), or grep from bottom mentally after line count |
| Grep shows scattered hits | **Two-pass**: grep for line numbers → one or two `Read` calls with `offset`/`limit` covering those ranges |
| Memory cites `path/to/file` or a command | **Follow**: open cited files or run allowed shell (e.g. `backlog task N --plain`) — memories are pointers, not the full story |

Do not assume the file is still small; hooks append over time.

## 2. Full read

Use when the probe shows modest size.

- Read the entire file in one `Read` (no offset/limit).
- If the editor already injected the full file, do not re-read unless the user asks for a refresh or you know it changed.

## 3. Keyword and pattern search (grep)

Use `Grep` on `.claude/memories.md` when the question is specific.

- **Topics / features:** meaningful nouns from the user question (e.g. `gateway`, `terraform`, `MCP`).
- **Identifiers:** `task-\d+`, backlog ids, branch names, Jira keys, PR numbers.
- **Stable anchors:** file paths (`backend/`, `infrastructure/`), resource names, error substrings.

**Patterns:**

- Prefer **multiple narrow greps** over one huge alternation.
- Use **context lines** (`-B` / `-A` / `-C`) so snippets stay interpretable.
- If results are noisy, add **case sensitivity** or a stricter substring.

After grep, **open a line window** (see §4) around each distinct cluster of hits instead of relying on grep output alone for long entries.

## 4. Line-bounded read (window / tail)

Use the editor `Read` tool with `offset` and `limit`.

- **Window:** If grep reports line 142, read roughly `offset = max(1, 142 - 25)`, `limit ≈ 50` (tune to capture full bullet blocks).
- **Tail (recent history):** After `wc -l .claude/memories.md` or a read of the last chunk, set `offset` to `total_lines - 150` (for example) and `limit` to 150.
- **Multiple windows:** Prefer a few focused windows over one enormous read.

## 5. Two-pass retrieval

1. **Pass A — locate:** `Grep` (or skim headings if the file uses `##` sections) to get line numbers.
2. **Pass B — load:** `Read` each needed span with explicit `offset`/`limit`.
3. **Merge:** Summarize only what is relevant to the current task; note **dates** or **ordering** if several entries conflict (newer usually wins).

## 6. Semantic / meaning-based questions

There is no embedded vector index in-repo.

- If the question is vague (“what did we decide about auth?”), use **grep** with synonyms and known project terms, then **windows**.
- If still thin, use **SemanticSearch** on the codebase for the same concepts; memories often **mirror** paths and decisions that also exist in code or docs.

## 7. What to return to the user

- Distinguish **fact in memories** vs **inference**.
- Quote or cite the **minimum** supporting lines when it helps (path + gist).
- If memories contradict the repo, **trust the repo** for current behavior and treat memories as historical unless the user says otherwise.

## 8. Probe helpers (shell)

Allowed when you need size or tail quickly:

```bash
wc -l .claude/memories.md
```

For a tail preview without loading the whole file in the model, a short `sed`/`tail` is acceptable in sandbox; prefer `Read` with `offset`/`limit` when you need exact line numbers for citations.

## Quick checklist

- [ ] Probed or estimated size before reading huge content
- [ ] Used grep for specific needles; used full read only when small
- [ ] Read line windows around hits (not just grep fragments)
- [ ] Checked end of file for latest appended context
- [ ] Followed file paths or task references when present
