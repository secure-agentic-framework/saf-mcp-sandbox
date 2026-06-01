#!/usr/bin/env bash
set -euo pipefail

# Image and flags directory can be overridden via env vars
# Prefer deriving GH owner from repo remote; fallback to 'bishnubista'.
if [[ -z "${IMAGE:-}" ]]; then
  owner=""
  if command -v git >/dev/null 2>&1; then
    if url=$(git config --get remote.origin.url 2>/dev/null || true); then
      owner=$(printf '%s' "$url" | sed -E 's#.*github.com[:/]+([^/]+)/.*#\1#') || true
    fi
  fi
  if [[ -z "$owner" ]]; then
    owner="bishnubista"
  fi
  IMAGE="ghcr.io/${owner}/saf-mcp-sandbox:latest"
fi
FLAGS_DIR=${FLAGS_DIR:-"$PWD/flags"}

docker run --rm -i \
  --read-only \
  --pids-limit 128 \
  --memory 256m \
  --security-opt no-new-privileges \
  --network none \
  -e MODE=safe \
  -v "${FLAGS_DIR}:/opt/flags:ro" \
  "${IMAGE}"
