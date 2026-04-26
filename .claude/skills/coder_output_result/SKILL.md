---
name: coder-output-result
description: Use for coder, emitting CODER_DONE or CODER_BLOCKED.
---

**Task Output result**

- On success: output `CODER_DONE`
- On failure: output `CODER_BLOCKED: <reason>`

The implementation notes step is mandatory — do not skip it even if the change is small.
