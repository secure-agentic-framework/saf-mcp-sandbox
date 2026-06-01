# SAF MCP Hackathon

Your mission: investigate a vulnerable MCP server, identify the vulnerability, map it to relevant saf‑mcp techniques (https://github.com/fkautz/saf-mcp/tree/main/techniques), and propose mitigations if any.

Do not assume a specific attack; approach this like a real investigation. Gather evidence, reason about impact, map to techniques, then validate a mitigation.

## Deliverables Checklist

- Technique mapping: list applicable saf‑mcp IDs (e.g., SAF-T####) and why.
- Evidence of impact: relevant tool metadata and a transcript/screenshot.
- Mitigation: proposal (server/client/policy) and trade‑offs.
- Validation: show the same flow with mitigation enabled and explain the outcome.
- Repro: exact commands and client configuration used.
- Length: keep it 1–2 pages; templated option: [`SUBMISSION_TEMPLATE.md`](SUBMISSION_TEMPLATE.md).

What success looks like:
- Clear identification of a concrete vulnerability and its impact.
- Correct mapping to at least one saf‑mcp technique ID.
- A plausible mitigation and validation that it prevents the issue.

## Quick Start (Participants)

- Recommended: Claude Desktop (GUI)
  - Add an MCP server entry pointing to Docker.
  - Quick JSON snippet (replace /ABS/PATH/flags):
    
    {
      "mcpServers": {
        "saf-mcp": {
          "command": "docker",
          "args": [
            "run","--platform","linux/amd64","--rm","-i",
            "--network","none",
            "-v","/ABS/PATH/flags:/opt/flags:ro",
            "ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08"
          ]
        }
      }
    }
    
    Safe mode: insert "-e","MODE=safe" before the image tag.
    
    Notes: Use an absolute host path; on Windows, escape backslashes in JSON.
  - See full details in [clients.md](clients.md).

## Client Guides

- Claude Desktop setup (step-by-step): see [clients.md#claude-desktop-recommended](clients.md#claude-desktop-recommended)
- Cursor setup (step-by-step): see [clients.md#cursor](clients.md#cursor)
- Inspector quick check: see [clients.md#mcp-inspector](clients.md#mcp-inspector)

- Alternatively: MCP Inspector (no install)
  - macOS/Linux:
    `npx @modelcontextprotocol/inspector -- docker run --platform linux/amd64 --rm -i --network none -v "$(pwd)/flags:/opt/flags:ro" ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08`
  - Windows PowerShell:
    `npx @modelcontextprotocol/inspector -- docker run --platform linux/amd64 --rm -i --network none -v "${PWD}/flags:/opt/flags:ro" ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08`

- Safe mode variant (to validate mitigations):
  - macOS/Linux:
    `npx @modelcontextprotocol/inspector -- docker run --platform linux/amd64 --rm -i --network none -e MODE=safe -v "$(pwd)/flags:/opt/flags:ro" ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08`
  - Windows PowerShell:
    `npx @modelcontextprotocol/inspector -- docker run --platform linux/amd64 --rm -i --network none -e MODE=safe -v "${PWD}/flags:/opt/flags:ro" ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08`

Prereq: create a local `./flags/flag.txt` file before running.

## Suggested Workflow

1. Connect a client (Inspector, Claude Desktop, or Cursor). See [clients.md](clients.md) for config and troubleshooting.
2. Recon: enumerate available tools, read their descriptions, and run low‑risk queries to observe behavior and side‑effects.
3. Hypothesize: based on observations, identify the vulnerability class and map it to one or more saf‑mcp techniques.
4. Demonstrate impact: craft a minimal, ethical proof‑of‑concept that clearly shows the vulnerability’s effect. Capture transcripts/screenshots.
5. Mitigate: propose mitigation(s) and explain trade‑offs. Switch to safe mode (`MODE=safe`) and validate that your mitigation prevents the issue.

## What to Submit

- Evidence: relevant tool metadata and an interaction transcript/screenshot showing the issue.
- Mapping: link to the saf‑mcp technique(s) and explain the alignment.
- Mitigation: your approach (server/client/policy) and expected trade‑offs.
- Validation: show the same scenario in `MODE=safe` and explain the outcome.
- Keep it 1–2 pages. You can use [`SUBMISSION_TEMPLATE.md`](SUBMISSION_TEMPLATE.md).

## Timeline (3 hours)

- 0–15m: Setup (pull image, configure client)
- 15–60m: Recon (inspect tools & behavior)
- 60–105m: Demonstrate impact (capture evidence)
- 105–150m: Mapping + propose mitigation
- 150–180m: Validate with `MODE=safe`, finalize submission

## Rules & Safety

- Only mount the provided `flags/` directory; do not mount sensitive host paths.
- Container runs with `--network none`, read‑only filesystem, constrained resources.
- Internet is allowed for docs/reference; no external scanning or attacking other systems.
- Keep transcripts local; do not share real secrets.

## Image & Scripts

- Public image: `ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08`
- Scripts: `scripts/run-unsafe.sh` / `scripts/run-safe.sh` (macOS/Linux) and `scripts\run-unsafe.cmd` / `scripts\run-safe.cmd` (Windows)

## Troubleshooting

- “file not found”: create `./flags/flag.txt` in your current folder.
- Volume mount issues: try an absolute host path on the left side of `-v`.
- On Windows JSON, escape backslashes in paths.

References:
- MCP Inspector: https://modelcontextprotocol.io/inspector
- Claude Desktop: https://modelcontextprotocol.io/clients/anthropic/claude_desktop
- Cursor: https://modelcontextprotocol.io/clients/cursor
