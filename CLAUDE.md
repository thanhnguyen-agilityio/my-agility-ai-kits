# my-agility-ai-kits

A private collection of Agility AI kits. Each kit lives in `kits/<kit-name>/` with its own README. See the root `README.md` for the index and how to add a kit.

## Model use: save cost

Pick the cheapest model that can do the job.

- **Opus: advisor only.** Planning, design decisions, reviewing tricky changes, unblocking when stuck. Do not use Opus to write bulk code or run routine steps.
- **Sonnet: code.** Writing and editing code, skills and scripts. Use **Haiku** for small, well-specified code changes.
- **Haiku: mechanical tasks.** Search, file listing, renames, moving or copying files, format fixes, updating indexes and tables, summarizing output.

When you spawn a subagent, set its `model` to match the task by these rules. Do not let it inherit Opus by default.

## Conventions

- Commit and push directly to `main`. No feature branches or pull requests unless asked.
- Never commit secrets or client data. Remove them before adding a kit.
- Keep the root README kit table in sync when you add, rename or remove a kit.
- When `kits/smoliv-relay/ticket-to-pr-deck.html` changes, republish its Artifact to the same link (https://claude.ai/artifact/3EpcEJz2iXRxZchVMoP425) so the README links stay current.
- `kits/*/CLAUDE.md.template` files are kit content for other repos, not rules for this repo.
