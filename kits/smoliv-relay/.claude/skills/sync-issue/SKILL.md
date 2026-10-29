---
name: sync-issue
description: Copy a GitHub issue's description and on-topic comments into <docs folder>/<area>/<issue>/requirements.md and discussions.md, when the user starts or refreshes an issue.
---

# Sync an issue

Read `CLAUDE.md` first. Names in angle brackets such as `<docs folder>` or `<rules file>` are defined in its **AI kit** section.

Needs the `gh` CLI, logged in.

Args: issue number, folder (`<area>/<issue>`). If the folder is missing, derive it from the issue title prefix and confirm in one line.

1. Preview: `scripts/sync.sh <n> /tmp/sync-<n>`. It prints `<i> kept|dropped @author date snippet` per comment.
2. Choose the off-topic indexes (test results, screenshots, build notices, LGTM, status pings, bot output). Keep when unsure.
3. Write: `scripts/sync.sh <n> <docs folder>/<area>/<issue> <drops, e.g. 2,5>`.
4. An existing file gets a `.new` suffix instead of being overwritten. Diff it, ask the user how to merge, then replace or delete it. Ask before renaming a misspelled file (for example `dicussion.md`) to `discussions.md`.
5. Report the files written and one line per dropped comment.

Fill in: `<docs folder>`, for example `docs/local`.
