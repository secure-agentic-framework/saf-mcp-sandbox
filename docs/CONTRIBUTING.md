# Contributing

This document explains how to contribute to this SAF‑MCP hackathon repo and keep changes consistent, reviewable, and safe.

## Project Structure & Module Organization
- `server/`: Node.js (TypeScript) MCP server (vulnerable + safe modes).
- `docker/`: Dockerfile and compose/dev scripts.
- `flags/`: Seed data (e.g., `flag.txt`) mounted read‑only at runtime.
- `docs/`: Event materials (`HACKATHON.md`, `CLIENTS.md`, `MITIGATIONS.md`, `SCORING.md`, `ROADMAP.md`).
- Mirror structure in tests (e.g., `server/src/auth/` ↔ `server/test/auth/`).

## Build, Test, and Development Commands
- Install: `cd server && npm ci`
- Dev (stdio mode): `npm run dev`
- Lint/format: `npm run lint && npm run format`
- Test: `npm test` (use `-w` for watch)
- Build: `npm run build` (emits to `server/dist`)
- Docker (local): `docker build -t saf-mcp-tpa:dev -f docker/Dockerfile .`

## Coding Style & Naming Conventions
- Indentation: 2 spaces; max line length ~100.
- TS/JS: `camelCase` for vars/functions, `PascalCase` for classes/types, `kebab-case` filenames.
- Enforce via Prettier + ESLint; run `npm run lint` before PRs.
- Keep functions small; prefer pure, testable modules in `server/src/*`.

## Testing Guidelines
- Framework: Vitest or Jest (choose one and keep consistent).
- File names: `*.test.ts` colocated under `server/test/` mirroring `src/` paths.
- Coverage: target ≥80% for changed code; include error paths.
- Run: `npm test` or `npm run test:cov` if configured.

## Commit & Pull Request Guidelines
- Commits: Conventional Commits, e.g., `feat(server): add safe mode sanitization`.
- PRs must include: purpose, scope, linked issue (if any), screenshots/logs for behavior, and checklist (tests, docs, lint pass, build pass).
- Keep PRs focused and under ~300 lines where possible.

## Security & Configuration Tips
- Do not commit secrets; use `.env` and provide `.env.example`.
- Containers: prefer `--network none`, read‑only mounts for `flags/`, and non‑root user.
- Document new env vars and ports in `README.md` and `docs/CLIENTS.md`.

