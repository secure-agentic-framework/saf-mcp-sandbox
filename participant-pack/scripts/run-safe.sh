#!/usr/bin/env bash
set -euo pipefail

# Determine pack dir (parent of this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Load IMAGE from image.env if not provided
if [[ -z "${IMAGE:-}" && -f "${PACK_DIR}/image.env" ]]; then
  set -a
  # shellcheck disable=SC1090
  . "${PACK_DIR}/image.env"
  set +a
fi

IMAGE=${IMAGE:-ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08}
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
