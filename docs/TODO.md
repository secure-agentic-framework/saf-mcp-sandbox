# TODOs: Participant Pack, Image Publishing, and Event Prep

This checklist ships a sanitized participant experience via a GHCR alias, without exposing organizer code or vulnerability names.

## Inputs Needed
- GHCR org/owner: <enter here>
  - What it is: the GitHub org or user that owns the container images on GHCR (same as your repo owner).
  - How to find:
    - From repo URL: `https://github.com/<owner>/<repo>` → `<owner>`.
    - In GitHub Actions: `${{ github.repository_owner }}`.
    - GitHub CLI: `gh repo view <OWNER/REPO> --json owner --jq .owner.login`
- Event tag (alias): <enter here>
  - Suggested formats: `hackathon-YYYY-MM` or `hackathon-YYYY-MM-DD`.
  - Keep it short, lowercase, and pinned (avoid `latest` for events).

## Organizer Repo (this repo)
- [ ] Tag and publish the organizer image (saf-mcp-sandbox)
  - [ ] `git tag v0.1.0 && git push origin v0.1.0`
  - [ ] Verify CI smoke test is green and GHCR image exists: `ghcr.io/<org>/saf-mcp-sandbox:v0.1.0`.
- [ ] Create participant-friendly alias (public): saf-mcp-hackathon
  - [ ] `docker pull ghcr.io/<org>/saf-mcp-sandbox:v0.1.0`
  - [ ] `docker tag ghcr.io/<org>/saf-mcp-sandbox:v0.1.0 ghcr.io/<org>/saf-mcp-hackathon:<event-tag>`
  - [ ] `docker push ghcr.io/<org>/saf-mcp-hackathon:<event-tag>`
- [ ] (Optional) Auto-publish alias in CI
  - [ ] Add `ghcr.io/${{ github.repository_owner }}/saf-mcp-hackathon` to Docker metadata images.
  - [ ] Add an alias tag (e.g., `hackathon`) for tag builds.

## CI Gating (already added)
- [ ] Tiny smoke test before pushing:
  - Builds a local image and runs `server/scripts/smoke.mjs`.
  - Verifies: unsafe description is poisoned; safe description sanitized.
  - Blocks publish on failure.

## Participant Repo: `saf-mcp-hackathon` (sanitized)
- [ ] Create a staging branch and overwrite with sanitized content.
- [ ] Structure
  - [ ] `README.md`: TL;DR quickstart (macOS/Linux + Windows). Reference only `ghcr.io/<org>/saf-mcp-sandbox:<event-tag>`.
  - [ ] `docs/quickstart.md`: run (unsafe + safe), sanity check (list tools), expected behavior (generic wording).
  - [ ] `docs/clients.md`: Claude Desktop, Cursor, MCP Inspector; Windows examples; troubleshooting; FAQ.
  - [ ] `docs/rules.md`, `docs/scoring.md`, `docs/submission.md`, `docs/troubleshooting.md`.
  - [ ] `scripts/`: `run-unsafe.sh|.cmd`, `run-safe.sh|.cmd` defaulting to the alias image.
  - [ ] `flags/flag.txt` or a one-liner to create it.
- [ ] Sanitization
  - [ ] Remove references to specific class names (e.g., "tool poisoning", "SAF‑T1001").
  - [ ] Use generic phrasing: "Identify the vulnerability… map to SAF taxonomy… validate mitigation.".
- [ ] GitHub Pages
  - [ ] Add a Pages workflow to publish the docs site from `docs/`.
  - [ ] Ensure no links back to the organizer repo.
- [ ] Manual verification
  - [ ] Test scripts and commands on macOS and Windows PowerShell.
  - [ ] Validate client connections and tool listing with the alias image.

## Event Release Checklist
- [ ] Organizer CI green (smoke test) for `v0.1.0`.
- [ ] Mint public alias tag on participant image:
  - Actions → Build and Publish Container → Run workflow
  - `Publish images to GHCR` = true
  - `Extra tag/alias` = `<event-tag>` (e.g., `hackathon-YYYY-MM`)
- [ ] Update `participant-pack/image.env` to the new alias.
- [ ] Sync pack to public repo:
  - `scripts/publish-participant.sh` (defaults to `git@github.com:bishnubista/saf-mcp-hackathon.git`)
- [ ] Tag the public repo with the same alias.
- [ ] Alias pulls cleanly: `docker pull ghcr.io/<org>/saf-mcp-hackathon:<event-tag>`.
- [ ] Merge participant-pack to `main`, enable GitHub Pages, switch repo public.
- [ ] Share only the participant repo URL and the alias image in announcements.

## Notes
- Keep `MODE=unsafe` as default; use `-e MODE=safe` only for mitigation validation.
- After the event, consider `SCENARIO` env var and per-scenario structure — see `docs/ROADMAP.md`.
