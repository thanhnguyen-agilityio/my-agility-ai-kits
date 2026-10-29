---
name: address-review
description: Address a team code review file for the current branch and write the reviewer reply; use to address, fix, or answer a review file (for example pr-review.md), or for the next issue, one at a time.
---

# Address a code review

Read `CLAUDE.md` first. Names in angle brackets such as `<docs folder>` or `<rules file>` are defined in its **AI kit** section. Apply the `unslop` skill to everything you write.

Batch mode: all findings in one run. Step mode: one finding per turn, when the arguments include `next` or the user asks for the "next issue". Step mode follows sections 1 to 4 except where [Step mode](#step-mode) says otherwise.

## 1. Check the review

Read the whole review. If its branch is not the current branch, or its base is not the user's base (default `main`), **stop** and change nothing. If the reviewed commit is behind `HEAD`, list the later commits and continue.

Sources the review cites (issue, Q&A, PR description) may be missing from this checkout: ask the user where each is, and read that file. Ask for the reviewer's handle if the review lacks it.

## 2. Triage

Take findings from Critical, Important, then Suggestion. Split grouped bullets ("Still open from...") into one finding each. Other sections are context. Do not undo a "Decisions that should stay" entry.

Fix every valid Critical and Important finding. Apply a Suggestion only if it is worth it or a risk-free quick win (wording, whitespace, a missing assert). Skip the rest with a reason. Show the user the triage before you start.

## 3. Work each finding

Finish all steps before the next finding:

1. **Verify** against `HEAD` with `path:line` evidence: valid, partly valid, not valid, already fixed, or cannot verify here (say what would settle it). Not valid is Skip. Already fixed is Done.
2. **Explain** in chat, two to four plain sentences: the problem, what it breaks and for whom, the principle behind the fix. Name the concept if it has one ("fail closed", "idempotent retry").
3. **Decide.** Fix it yourself when the fix is clear and changes nothing a caller sees. Otherwise ask the user (`AskUserQuestion` if you have it), recommended option first: owner decisions, competing fixes, a change to a route, status, contract, or event, or when you disagree with the finding.
4. **Fix** with the smallest change. Add a test when behaviour changes. Never hand-edit a generated contract file (for example OpenAPI); regenerate it.
5. **Reply.** Add the finding to `<review-name>-reply.md` beside the review. Read `references/reply-format.md` first: it has the greeting and the line format. Cite the review's paths, not local ones.
6. **Status.** Add a last sub-bullet to the finding in the review file:
   `- **Status: Done|Todo|Skip.** <key takeaway, what it waits on, or why not>`

## 4. Finish

Update the PR description file in place, following the `pr-desc` skill. Change only what the fixes made stale or left out.

Run `git diff --check`, then make one commit with all the review fixes, in the repo's message style (`fix: address PR <n> review`). Do not push.

Tell the user: each finding's status and takeaway; the Todo items; what was not verified or tested; whether the contract needs regenerating; the concepts behind the fixes, one line each.

## Step mode

**Scope.** Critical and Important findings that affect a shipped route (the fix changes a route already on `main` or in the published contract). Use the user's scope if they give another.

**Next finding.** The first in-scope finding, in severity order, with no `Status:` line. Run section 1 on the first turn only. On the first turn also run section 2, show which findings are in scope, then go straight to the first.

**Per turn.** Work one finding through section 3, then stop. Skip the Explain step; answer in this shape:

```markdown
**Issue:** <what is wrong, and for whom, with path:line>
**Root cause:** <why the code does it>
**Solution:** <what changed, with path:line, and the test that covers it>

**Commit:**
fix: <one line in the repo's message style>
```

For Skip or Done, replace Solution with the evidence and omit the commit. Do not commit; the user commits each fix. Run `git diff --check` before you answer.

**Last finding.** When none is left, say so and run section 4 without the commit. Give the commit message for the PR description and reply files instead.

## Reply format

One line per finding: a short bold title, then one sentence on what the code does now, why not, or what it waits on. Prefix `[Critical]` or `[Important]` for those severities; Suggestions untagged. Order: Done, then "Not changed" (Skip), then "Still open" (Todo), each by severity. Omit empty groups.

Read `references/reply-format.md` when writing the reply.
