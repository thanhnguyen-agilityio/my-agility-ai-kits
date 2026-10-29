#!/usr/bin/env bash
# usage: sync.sh <issue> <dir> [drop-indexes, comma-separated]
# Writes requirements.md (title heading, then body) and discussions.md into <dir>; an existing file gets a .new suffix instead.
# Prints one index line per comment on stderr: "<i> <kept|dropped> @author date first-60-chars".
set -euo pipefail
n=$1; dir=$2; drop="-1${3:+,$3}"
mkdir -p "$dir"
out() { [ -e "$dir/$1" ] && echo "$dir/$1.new" || echo "$dir/$1"; }
req=$(out requirements.md); dis=$(out discussions.md)
gh issue view "$n" --json title,body --jq '"# \(.title)\n\n\(.body)"' | tr -d '\r' > "$req"
gh issue view "$n" --json comments --jq ".comments | to_entries[] | .key as \$i | .value |
  \"\(\$i) \(if \$i|IN($drop) then \"dropped\" else \"kept\" end) @\(.author.login) \(.createdAt[0:10]) \(.body[0:60]|gsub(\"[\r\n\t ]+\";\" \"))\"" >&2
gh issue view "$n" --json comments --jq ".comments | to_entries[] | select(.key|IN($drop)|not) | .value |
  \"### @\(.author.login), \(.createdAt[0:10]) ([link](\(.url)))\n\n\(.body)\n\"" | tr -d '\r' > "$dis"
echo "wrote $req $dis"
