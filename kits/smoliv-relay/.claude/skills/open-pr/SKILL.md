---
name: open-pr
description: Open the current branch as a draft pull request with a written description, when asked to open, create, or raise a PR.
---

# Open a draft PR

Read `CLAUDE.md` first. Names in angle brackets such as `<docs folder>` or `<rules file>` are defined in its **AI kit** section.

Needs the `gh` CLI, logged in. Arg: base branch (default `main`).

1. Stop if the branch is the base, or `git status --porcelain` shows uncommitted changes. Tell the user.
2. If `gh pr view --json number,url` finds a PR for this branch, run the `pr-desc` skill with that number instead and stop.
3. Ask the user to confirm `git push -u origin HEAD`, then run it.
4. Run the `pr-desc` skill for the body, without a PR number. It writes `<docs folder>/<issue>-pr-desc.md`.
5. Title: one line in the style of `git log --oneline -10 <base>`, naming the branch's main change. No issue number unless recent titles carry one.
6. `gh pr create --draft --base <base> --title "<title>" --body-file <file>`.
7. Report the PR URL. Never mark it ready for review.
