#!/usr/bin/env bash
# Build the plugin and copy the bundle into the OpenCode config repo.
# Usage: scripts/vendor.sh [dest-dir]
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="${1:-$HOME/.config/opencode/vendor/opencode-dcp}"

cd "$repo_root"

if [[ -n "$(git status --porcelain)" ]]; then
    echo "Working tree is dirty; commit first so VERSION points at real code." >&2
    exit 1
fi

npm run typecheck
npm test
npx tsup

mkdir -p "$dest"
cp dist/index.js dist/index.js.map "$dest/"

{
    echo "package: @tarquinen/opencode-dcp $(node -p 'require("./package.json").version')"
    echo "fork: $(git remote get-url origin)"
    echo "branch: $(git rev-parse --abbrev-ref HEAD)"
    echo "commit: $(git rev-parse HEAD)"
    echo "upstream base: $(git merge-base HEAD upstream/master)"
    echo "built: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo
    echo "commits on top of upstream:"
    git log --format='  %h %s' upstream/master..HEAD
} > "$dest/VERSION"

echo "Vendored to $dest"
cat "$dest/VERSION"
