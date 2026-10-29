# Reply example

```markdown
Hi @<reviewer>,
Thank you for taking the time to review the work. I've updated the PR with the changes below:

1. **[Important] A personal address in `helpers.http`.** `@grantee` is `colleague@example.com`, to fill in before running.
2. **Four helpers have no registration check.** The registration test now resolves all four.

Not changed:

1. **[Important] `$dotenv` may not read `.env` from a subfolder.** It does: the REST Client searches parent folders for `.env`.

Still open:

1. **[Important] May a billed cloud read run past the budget?** Waits on the owner's answer in `<q&a file>`.
```
