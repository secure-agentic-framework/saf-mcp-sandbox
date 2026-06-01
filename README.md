# SAF-MCP Sandbox

[![Build and Publish Container](https://github.com/bishnubista/saf-mcp-sandbox/actions/workflows/publish.yml/badge.svg)](https://github.com/bishnubista/saf-mcp-sandbox/actions/workflows/publish.yml)

A minimal, intentionally vulnerable MCP server to demonstrate SAF‑T1001 (Tool Poisoning Attack). Use it during the hackathon to: identify the vulnerability, map it to SAF‑T1001, and propose mitigations.

## Quick Start
- Prereqs: Docker installed; internet allowed for image pull.
- Pull (GHCR example): `docker pull ghcr.io/bishnubista/saf-mcp-sandbox:v0.1.0`
- Run (unsafe mode, default):
  - macOS/Linux: `docker run --rm -i --read-only --pids-limit 128 --memory 256m --security-opt no-new-privileges --network none -v "$(pwd)/flags:/opt/flags:ro" ghcr.io/bishnubista/saf-mcp-sandbox:v0.1.0`
  - Windows PowerShell: `docker run --rm -i --read-only --pids-limit 128 --memory 256m --security-opt no-new-privileges --network none -v "${PWD}/flags:/opt/flags:ro" ghcr.io/bishnubista/saf-mcp-sandbox:v0.1.0`
- Run (safe mode demo):
  - Add `-e MODE=safe` before the image name, or use `./scripts/run-safe.sh` / `scripts\run-safe.cmd`.
  - Tip: Override scripts with a pinned tag: `IMAGE=ghcr.io/bishnubista/saf-mcp-sandbox:v0.1.0 ./scripts/run-unsafe.sh`
- Connect with an MCP client (Claude Desktop recommended). See `docs/CLIENTS.md`.

## What You’ll Do
- Recon tool metadata, trigger the poisoned behavior, capture evidence of model coercion/exfiltration, map to SAF‑T1001, and propose a mitigation. See `docs/HACKATHON.md` for the exact tasks and scoring.

## Repository Layout
- `server/`: Node.js (TypeScript) MCP server (unsafe/safe modes)
- `docker/`: Dockerfile
- `flags/`: Sample `flag.txt` mounted read‑only at runtime
- `docs/`: Event docs and materials (`HACKATHON.md`, `CLIENTS.md`, `MITIGATIONS.md`, `SCORING.md`, `ROADMAP.md`)
- `scripts/`: Convenience run scripts for macOS/Linux and Windows

## Notes
- Container runs without network, read‑only, as non‑root in final image.
- Bind‑mount only `flags/` read‑only; do not mount sensitive host paths.
- Issues and improvements welcome via PRs (see `docs/ROADMAP.md`).

## Publishing
- CI builds and pushes images to GHCR on tags (`v*`) and on `main` (edge).
- Image: `ghcr.io/bishnubista/saf-mcp-sandbox` with tags like `v0.1.0`, `v0.1`, `v0`, `latest`, and `edge`.
- Tag and push to release:
  - `git tag v0.1.0 && git push origin v0.1.0`
  - See `docs/ROADMAP.md` for future tagging by scenario.
