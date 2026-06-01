# SAF MCP Hackathon

This pack lets participants run a minimal MCP server image for the event. It uses a public alias image so no local build is needed.

## Quickstart

- Prereqs: Docker Desktop or Docker Engine 24+.
- Create a flags file (read by the server):
  - macOS/Linux: `mkdir -p flags && echo DEMO-FLAG > flags/flag.txt`
  - Windows PowerShell: `New-Item -ItemType Directory -Force flags; Set-Content -Path flags/flag.txt -Value DEMO-FLAG`

### Image Tag Configuration

- The image tag lives in `image.env` as `IMAGE=...`.
- To switch events, edit that single line (or override with `IMAGE=...` when running scripts).

### Run (unsafe)

- macOS/Linux: `./scripts/run-unsafe.sh`
- Windows: `scripts\\run-unsafe.cmd`

### Run (safe)

- macOS/Linux: `./scripts/run-safe.sh`
- Windows: `scripts\\run-safe.cmd`

Notes:
- The container runs without network and with read-only FS. Flags are mounted read-only to `/opt/flags`.
- Default image: `ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08`.
- Override image: set `IMAGE=...` before running the script.

## MCP Client Examples

- MCP Inspector (macOS/Linux):
  - `npx @modelcontextprotocol/inspector -- docker run --rm -i --network none -v "$(pwd)/flags:/opt/flags:ro" ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08`
- MCP Inspector (Windows PowerShell):
  - `npx @modelcontextprotocol/inspector -- docker run --rm -i --network none -v "${PWD}/flags:/opt/flags:ro" ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08`

## Troubleshooting

- “denied: requested access to the resource is denied” → Pull the public tag `ghcr.io/bishnubista/saf-mcp-hackathon:hackathon` or update to the latest published alias.
- Ensure `flags/flag.txt` exists and is mounted; otherwise some tools may fail when attempting to read it.
