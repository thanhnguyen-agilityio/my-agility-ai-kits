#!/usr/bin/env bash
# Copy the kit into a target project. Never overwrites existing files. Safe to rerun.
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)"
dst="${1:?usage: install.sh /path/to/project}"
mkdir -p "$dst/.claude"
[ -e "$dst/CLAUDE.md" ] || cp "$src/CLAUDE.md.template" "$dst/CLAUDE.md"
[ -e "$dst/skills-lock.json" ] || cp "$src/skills-lock.json" "$dst/skills-lock.json"
rsync -a --ignore-existing "$src/.claude/" "$dst/.claude/"
chmod +x "$dst"/.claude/skills/*/scripts/*.sh 2>/dev/null || true
echo "Installed into $dst. Next: fill the <…> placeholders in CLAUDE.md (AI kit section)."
