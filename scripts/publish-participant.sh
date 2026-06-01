#!/usr/bin/env bash
set -euo pipefail

# Publish participant-pack/ to a separate public repo using git subtree.
#
# Usage:
#   scripts/publish-participant.sh [--remote <git-url>] [--create]
# Examples:
#   scripts/publish-participant.sh                                  # uses default REMOTE
#   scripts/publish-participant.sh --remote git@github.com:bishnubista/saf-mcp-hackathon.git
#   scripts/publish-participant.sh --create                         # create repo via gh if missing
#
# Env vars:
#   REMOTE   Git URL of the participant repo (default: git@github.com:bishnubista/saf-mcp-hackathon.git)

REMOTE=${REMOTE:-git@github.com:bishnubista/saf-mcp-hackathon.git}
CREATE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote)
      REMOTE="$2"; shift 2;;
    --create)
      CREATE=true; shift;;
    -h|--help)
      echo "Usage: $0 [--remote <git-url>] [--create]"; exit 0;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

if [[ ! -d participant-pack ]]; then
  echo "participant-pack/ not found at repo root" >&2
  exit 1
fi

# Ensure we are in a git repo and have a clean tree (no uncommitted changes)
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repository"; exit 1; }
if ! git diff --quiet --ignore-submodules --cached && ! git diff --quiet --ignore-submodules; then
  echo "Uncommitted changes detected; commit or stash before publishing." >&2
  exit 1
fi

# Optionally create the target repo using gh if it doesn't exist
if $CREATE; then
  if command -v gh >/dev/null 2>&1; then
    if ! gh repo view "${REMOTE#*:}" >/dev/null 2>&1; then
      echo "Creating repo ${REMOTE#*:} via gh..."
      gh repo create "${REMOTE#*:}" --public --disable-wiki --description "SAF MCP participant pack"
    fi
  else
    echo "gh CLI not found; skipping --create. Install gh or create the repo manually." >&2
  fi
fi

BR="pack-publish-$(date -u +%s)"
echo "Creating subtree branch ${BR} from participant-pack/ ..."
git subtree split --prefix=participant-pack -b "$BR"

echo "Pushing ${BR} to ${REMOTE} as main (force)..."
git push -f "$REMOTE" "$BR:main"

echo "Cleaning up local branch ${BR} ..."
git branch -D "$BR" >/dev/null 2>&1 || true

echo "Done. Verify: ${REMOTE}"

