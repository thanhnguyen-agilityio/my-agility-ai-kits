# Example: a issue-specific review prompt

A one-off prompt for the `preview` skill. It depends on one branch and one day, so it is a prompt, not a skill.
The skill gives the standard checklist. The numbered list at the end adds checks for this issue only.
Replace every `<placeholder>`. Delete the checks you do not need.

```text
Use the `preview` skill. Review the current branch against `main` and the PR description
`<docs folder>/<area>/<issue>/pr-desc.md`.

Target: `<branch>` versus `main`.
Use `git diff main...HEAD` (three dots). The working tree has only untracked folders
(`<docs folder>`), which do not belong in the source tree. No source file is uncommitted.
Say that in the report.

The change is one integration issue: <issue name>. It updates the `<vendor library>` library,
the `<integration folder>/<Vendor>` folder, the `<vendor library>.UnitTests` project, new
service unit tests, and the contract file.

Issue: read `<docs folder>/<area>/<issue>/requirements.md` and `discussions.md`.
Fill in the Definition of Done table from both. Where the issue text and the code disagree,
decide which one is stale and say which.

Scope of this review: Phase 1 only. Assume (1) only read-only routes, (2) no classifications,
(3) vendor errors pass through.

Prior passes: do not read any.

Beyond the standard checklist, confirm these for this issue:

1. The credential gate. The credentials turn the vendor on, not the presence of the config
   section. A partial credential set must fail fast, not disable the vendor in silence.
   The configuration tests should prove both directions.
2. Fail closed at the identity bridge. When the caller cannot be mapped to a vendor user, the
   service answers 403 and makes no vendor call. No fallback to a service account. Check that
   a test covers the refusal, and that the refusal records a `Denied` status when it records
   at all.
3. Error mapping. The vendor exception carries a clean message. A vendor 401 must not reach
   the caller as the caller's own credential failing. Check which statuses are allowed to pass
   through, and that everything else becomes 502.
4. The health probe. It answers inside the probe timeout and throws only the integration's own
   exception type. An anonymous caller can read its output, so no host, no URI, no token.
5. Logging. Reads record nothing. A mutation or content download records once, from a
   `finally`. No token, no download URL, and no file bytes in the record.
6. DI lifetimes. Client scoped, probe transient, cache or credential holder singleton.
   A singleton that holds a cache disposes it. Clients resolve with `GetService<T>()`,
   never `GetRequiredService`.
7. The shared files. Confirm all of them are touched and consistent: `<list your shared files
   from the integration README>`. Name any that is missing.
8. Build gates. The contract file is in the diff, so check that the route metadata in the
   endpoint file matches it: name, tags, summary, description, and a problem response for every
   status including 502 and 503. New packages need a version entry and regenerated lock files.

Hard rules from the skill still apply. Do not change code. Write exactly one file. Anything that
needs a machine to settle goes in "Verification status", not into a guessed finding.

Write the report to `<reviews folder>/<issue>-review-phase-1-<date>.md`.
```

## How to adapt it

- Keep the first block (target, diff form, scope, prior passes). It stops the reviewer from guessing.
- Keep the last two lines (hard rules, output path).
- Write the numbered list from the issue's real risks: new auth paths, new vendor calls, new shared files.
  Each item names the rule and the file or test that proves it.
