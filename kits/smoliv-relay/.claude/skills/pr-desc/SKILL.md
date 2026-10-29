---
name: pr-desc
description: Write the pull request description, when asked for a PR description, body, or summary.
---

# PR description

Read `CLAUDE.md` first. Names in angle brackets such as `<docs folder>` or `<rules file>` are defined in its **AI kit** section.

Apply the `unslop` skill to the result.

1. Run `scripts/scope.sh <base>` (default `main`), then read the changed source files. Only the code goes in the description, not commit intent.
2. Ask one short question: which issues this closes, and which it only relates to. Do not search for them.
3. Write the body to the shape below.
4. Cut any sentence that would read the same on a different PR.
5. If the user gave a PR number, run `gh pr edit <n> --body-file <file>` after writing the file, and report the PR URL. Without a number, do not touch GitHub.

## Shape

```
<One to three sentences. What the branch adds and the boundary it holds. Open with the change, not "This PR".>

- **<The thing.>** <What it does. Route names, option keys, status codes, class names.>

| Method | Route | Does | Callers | Role | Records |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/<full>/<route>` | <One short clause.> | <who may call> | `<Role>` | `<event.name>` or - |

Closes #<id>.

Relates to #<id>, #<id> (does not close them).

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Rules

- Three to six bullets, one per real change, not per file. Tests, lock files, formatting only when the approach is the point.
- Bold lead-in names the thing and ends in a period; the rest adds detail, never restates it.
- Be concrete (route, config section, status code, interface). Cover what a reviewer checks: new surface, who may call it, what is recorded, behavior when absent or misconfigured.
- `Closes` for issues the branch finishes, `Relates to` for ones it touches. Drop a line when the developer named nothing for it. Never guess a number.
- Table only for routes `main` lacks, one row per route in mapped order; changed routes go in bullets. With a table, bullets describe the endpoint group and how it fails, not routes.
- Fill rows from the code, never guess: full path with every `MapGroup` prefix; Callers and Role from your authorization calls (`<caller policy>`, `<role policy>`); Records from the event the handler writes; Does from its summary. Use - for an empty cell.
- Drop the Callers or Role column when all rows match; state the value once in the lead.
- No headings, checklists, or test plan. The only emoji is the trailer's robot; the trailer is the last line, verbatim. (Delete the trailer if your team does not want it.)
- Never claim tests pass unless they ran this session.
- Write the body to `<docs folder>/<issue>-pr-desc.md` (`<issue>` is the closing-line number), nothing else in the file. Do not print the body in the reply.

Fill in: `<docs folder>`, `<caller policy>`, `<role policy>`. No route table: delete the table and the route rules.
