---
name: preview
description: Review .NET changes against the project's own rules. Use when asked to review a branch, PR, diff, or changed files. Read-only; writes one report file.
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git log:*), Bash(git status:*), Bash(git show:*), Bash(git merge-base:*), Bash(git ls-files:*), Bash(git branch:*), Write
---

# .NET API review

Read `CLAUDE.md` first. Names in angle brackets such as `<docs folder>` or `<rules file>` are defined in its **AI kit** section.

Act as a Senior .NET Backend Engineer and Software Architect.

## Hard rules

- Do not change code. Do not stage, commit, push, or merge.
- Write exactly one file, the report.
- If your environment cannot build, keep this line: Do not build. Do not restore. Do not run tests. (Optional. Delete it if your environment can build.)
- Never claim tests pass unless they ran in this session.
- If a claim needs running something to verify, say so in the report. Do not guess.

## Writing

- Short sentences, one idea each. Plain words. No idioms, metaphors, or jokes.
- Name the file and line.
- The `unslop` skill applies. No em dashes.
- No pleasantries or generic praise. Praise only a specific decision a reviewer might ask to remove, and say why it should stay.

## Step 1: target

Use the user's target. If none, review the current branch against `main`.

```bash
git log --oneline -3
git status --porcelain
git merge-base main HEAD
git diff --stat main...HEAD
```

- Use the three-dot form `main...HEAD`.
- Uncommitted or staged work is part of the change. Review it and say in the report it is not committed.
- A `UU` line means an unfinished merge. Report it first. The branch cannot merge.
- Do not credit the PR with files that main changed.
- If the user names an issue file, read it, compare the code to it, and fill in the Definition of Done table. If issue and code disagree, say which is stale.

## Step 2: project rules

Do not review from memory. Read every file listed under **Rule files** in `CLAUDE.md`. Also read `Directory.Build.props` and `.editorconfig` if they exist. Check whether the build enforces `.editorconfig`; if not, the surrounding code wins.

## Step 3: codebase

Read **Codebase summary** in `CLAUDE.md`. If it is missing or still has `<…>` placeholders, stop and ask the user to fill it.

## Step 4: checklist

Use this as a base. Add the project's own invariants.

1. **Routing**
   - Routes are registered in the one place the project allows.
   - Every route has a name, tags, a summary, and a declared problem response for each status it can return.
   - The route sits on the right group (version, authentication floor, shared filters).
   - Ids in a path are safe. A URL, search query, or free text goes in the query string or body.
2. **Async and performance**
   - No `.Result`, `.Wait()`, or `Thread.Sleep`.
   - `CancellationToken` reaches every async call, including calls inside helpers.
   - Time comes from an injected `TimeProvider`, not `DateTime.Now`.
   - A cache states its bound (size, lifetime, or both). A paged vendor call reads the page count, not only the first page.
   - DI lifetimes fit: clients scoped, probes transient, caches and credential holders singleton. A singleton that holds a disposable disposes it.
3. **Security and errors**
   - Caller identity comes from the resolved request context, never from a body or caller header.
   - Fail closed. If the caller cannot be resolved, answer 403 and make no call. No fallback to a service identity.
   - A detail string that reaches a caller shows no host, request URI, token, or SDK message.
   - Only statuses the caller can act on pass through from a vendor. A vendor 401 must not look like the caller's own credential failing. Map the rest to 502.
   - Secrets never reach a log line, a stored record, or a response.
4. **Logging and audit**
   - A mutation records one event. A read records nothing (if that is your rule).
   - The record is written in a `finally`, so a failed call is recorded too.
   - The event status is set on every failure path, including permission refusals.
   - File bytes, extracted text, download URLs, and tokens never enter the log.
5. **Tests**
   - Each new branch has a test, including error paths and the fail-closed path.
   - Tests stub at the network seam, not inside the class under test.
6. **Build gates and contract**
   - A route change rewrites the generated contract file, and the file is committed.
   - A new package has a version entry, and lock files are regenerated.
   - Nullable and warning-as-error settings are respected.
7. **Style**
   - Modern C# idioms as the surrounding code uses them (primary constructors, records, collection expressions, pattern matching).
   - A comment says why, never what. A comment that describes the opposite of the code is a finding, and a serious one on an auth path.
   - No em dashes.

Then read **Project checklist** in `CLAUDE.md` and check every item. Quote the rule file for each finding.

## Step 5: severity

- **Critical**: a bug, a security weakness, a rule the project calls an invariant, or a comment that documents the opposite of the code on a security path.
- **Important**: a correctness gap with a workaround, a missing required test, a performance or memory concern, a missing build gate, or a pattern the next issue will copy and regret.
- **Suggestion**: style, naming, wording, small clean-ups.

Each finding has the file and line, what is wrong, and what to do. For Critical, add a short code snippet of the fix. If a rule file differs from the code, quote the rule and name the file.

If you reviewed this branch before, list what you now withdraw and why. A finding that a later decision settles is no longer a finding.

## Step 6: report

Save to `<reviews folder>/<name>.md`, or the path the user gives.

```markdown
# Review: <branch or PR>

| | |
| --- | --- |
| Branch | <branch> @ <sha> |
| Base | main @ <sha> |
| Merge base | <sha> |
| Diff | <n> files, +<a> / -<d>. <clean or uncommitted work> |
| Issue | <issue file, if any> |
| Reviewed | <date>, static read of git diff. No build, no restore, no test run. |

<One paragraph: what the branch does, and what changed since the last review.>

## Withdrawn since the last pass
<Only when there was a last pass.>

## Critical (Must Fix)
* **[File:line / endpoint]:** <what is wrong, why it matters, the fix, with a snippet.>

## Important (Should Fix)
* **[File:line / endpoint]:** <what is wrong, why it matters, the fix.>

## Suggestion (Nice To Have)
* **[File:line / endpoint]:** <the smaller thing.>

## Definition of Done status
<A table, one row per item, when the user named an issue. Mark met, partial, or missing.>

## Verification status
<What you did not run, and the exact items that need a machine to settle.>
```
