---
name: plan-issue
description: Write the implementation plan for one issue from its docs, when the user asks to plan an issue.
argument-hint: <issue-dir | issue-number> [status and expectations]
---

# Plan an issue

Read `CLAUDE.md` first. Names in angle brackets such as `<docs folder>` or `<rules file>` are defined in its **AI kit** section.

Act as a senior principal engineer. The `preview` skill later reviews the built change against the rules read in step 2.

## Hard rules

- Write one file, the plan. No code changes.
- Do not build, restore, or run tests. (Optional. Delete this line if your environment can build.)
- Apply the `unslop` skill. One idea per sentence, plain words, for a non-native reader.
- Cite a source for every claim: doc path, comment link and date, code `path:line`, or vendor doc or SDK file. Label an unsourced claim **assumption**.
- Take requirements only from the issue docs and the user's notes.

## 1. Inputs

| Input | Default |
| --- | --- |
| Issue folder | `<docs folder>/<area>/<issue>/`. From an issue number, derive it from the title prefix and confirm in one line |
| Issue number | Links in `discussions.md` |
| Status: decided, waiting on whom | `discussions.md`. Say in the plan that the user gave none |
| Phases | Two if anything waits on an outside answer (Phase 1 decided now, Phase 2 the rest), else one |
| Phase 1 scope | The user's words, e.g. "the read-only routes" |
| Output | `<issue-dir>/<issue>-plan.md`. Ask before overwriting |

No `requirements.md`: stop and offer the `sync-issue` skill. Ask only for an input with no default.

## 2. Read

Done when each file is read or noted absent.

- Issue folder: `requirements.md`, `discussions.md`, analysis and resource files, `review-checks.md` (optional). Skip personal notes, prompts, reviews.
- Area folder: `<acceptance criteria file>`, `review-checks.md` if present.
- `<rules file>`, `<integration rules file>`, `<integration folder>/README.md`. Add the event or logging README if the issue records events, the documents README if it serves documents.
- The two latest sibling `<issue>-plan.md` files.
- Existing code: vendor library, `<integration folder>/<Vendor>/`, its tests.
- Each vendor endpoint and SDK type the plan names: vendor reference and SDK source at the version in your package version file.

## 3. Sort

Done when every requirement line and discussion question is in one bucket:

- **Decided**: confirmed in the thread, or by the user's status.
- **Waiting**: an open question, or a dependency on the client, an admin, or a scope grant.
- **Conflict**: status and docs disagree, or two comments do. Cite both. Do not pick one.

Phase 1 takes only Decided items.

## 4. Write

Numbered sections:

0. **Status and decisions.** Issue, scope in two sentences, sources read. Decisions table with sources. Conflicts. Assumptions.
1. **Already in place.** Table: item, state, file.
2. **Findings that shape the design.** Vendor and code facts that force a choice, with sources.
3. **Phase 1 steps**, in build order. Each builds and passes its tests alone, and gives:
    - Purpose, one or two sentences.
    - Files new and edited, including shared files from your integration checklist.
    - Contract: method, path, operation name, request and response types, error statuses passed through, event recorded or "records nothing", caller guard, vendor scope.
    - Tests: class and cases by behavior, stubbed at the network seam.
    - Done when: checkable conditions, ending with "contract regenerated and committed" (if you generate one).
    Signature snippets only, no method bodies.
4. **Exceptions to the acceptance criteria.** Criterion, what the issue does instead, why. Or "None".
5. **Rework risks.** Per Phase 1 choice a Phase 2 answer could change: the choice, the breaking answer, the cost, how Phase 1 limits it. Done when every Waiting item is checked against every Phase 1 step.
6. **Phase 2 outline.** What is blocked and on whom. Open questions ready to post, tagged to who answers. What each likely answer changes.
7. **To confirm on a machine.** Sandbox calls and runs the plan depends on.

One-phase plan: omit 5 and 6.

## 5. Check and hand over

1. Check each Phase 1 step against every rule in the acceptance criteria file and `review-checks.md` (if present). Fix the plan or list the rule in section 4.
2. Unslop pass, then write the file.
3. In chat: one audience line ("Written for: the engineer who implements the steps."), kept out of the file. Then the path, Conflicts, and open questions.
