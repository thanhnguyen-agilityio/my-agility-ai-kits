#!/usr/bin/env bash
# usage: scope.sh [base=main]
# Prints commits, diff stat, and added Map* route lines (with file) for base...HEAD.
set -euo pipefail
b=${1:-main}
echo "## commits"; git log --oneline "$b"..HEAD --no-merges
echo "## stat"; git diff --stat "$b"...HEAD
echo "## new routes"; git diff "$b"...HEAD -U0 -G'Map(Get|Post|Put|Patch|Delete|Group)\(' |
  awk '/^\+\+\+ /{f=$2} /^\+.*Map(Get|Post|Put|Patch|Delete|Group)\(/{print f": "substr($0,2)}'
