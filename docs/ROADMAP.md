# Roadmap and Maintainer Plan

This repo hosts a minimal, intentionally vulnerable MCP server for hackathons. Today it focuses on SAF‑T1001 (Tool Poisoning Attack). After the event, we will evolve it into a multi‑scenario sandbox while keeping setup simple.

## Immediate Plan (Event-Ready)
- Quickstart TL;DR with secure Docker flags and Windows examples.
- Expand client setup (Claude Desktop, Cursor, MCP Inspector) with troubleshooting.
- Add run scripts (`scripts/run-unsafe.*`, `scripts/run-safe.*`).
- Reproducible container builds (`npm ci` + lockfile in Dockerfile).
- Submission template describing evidence, mapping, mitigation, and validation.
- Default `MODE=unsafe` for hackathon speed; `MODE=safe` for validation.

## Future TODOs (Post-Event)
- Introduce `SCENARIO` env var to select vulnerability (default `SAF-T1001`).
- Refactor server into `server/src/scenarios/<id>/` with a thin loader in `index.ts`.
- Add `scenarios.json` manifest for per‑scenario metadata (optional mounts, notes, Docker flags).
- CI matrix to build/test scenarios and publish per‑scenario image tags.
- Workflow to watch `fkautz/saf-mcp` for new vulnerabilities and scaffold PRs.

## Scenario Strategy (Non-Breaking Outline)
- Entry: `server/src/index.ts` loads `SCENARIO` (`SAF-T1001` by default) and `MODE` (`unsafe|safe`).
- Modules: `server/src/scenarios/SAF-T1001/index.ts` exports `getTools(mode)`.
- Docs: `docs/scenarios/<id>/` for scenario-specific materials.
- Images: publish `:<scenario>-vX.Y.Z` and `:<scenario>-latest` alongside a stable `:latest` for the current event.

## Integration with saf-mcp
- Source of truth: https://github.com/fkautz/saf-mcp
- When new vulnerabilities are merged upstream, scaffold a new scenario with docs and smoke tests.

