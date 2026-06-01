## Decisions: Images, Publishing, and Participant Pack

This file records the choices we made so future events stay consistent.

### Images and Repos
- Organizer image: `ghcr.io/<owner>/saf-mcp-sandbox` (private).
- Participant image (alias): `ghcr.io/<owner>/saf-mcp-hackathon` (public).
- Registry: GHCR. Docker Hub is optional and not used by default.

### CI and Publishing
- Build + smoke test runs on PRs and `main` pushes.
- Publishing to GHCR runs only when either:
  - A tag `v*` is pushed; or
  - The workflow is run manually with `publish = true`.
- We keep provenance/SBOM enabled (default of `docker/build-push-action`).

### Tagging Policy
- Moving pointer: `hackathon` (retarget for each event when publishing).
- Optional manual alias per event: recommended format `hackathon-YYYY-MM` (set via the manual workflow input).
- Semver tags (`vX.Y.Z`, `vX.Y`, `vX`, `latest`) exist for organizer versioned releases.

### Participant Pack Configuration
- Single source of truth for the image tag lives in `participant-pack/image.env`:
  - Format: `IMAGE=ghcr.io/<owner>/saf-mcp-hackathon:<alias>`.
  - Bash and Windows scripts read `image.env` if `IMAGE` is not already set in the environment.
  - Precedence: user-provided `IMAGE` env var > `image.env` > script fallback.
- Rationale: one-line bump per event, consistent across all scripts and docs.

### Event Release Flow (Summary)
1. Run manual publish workflow and set the event alias (e.g., `hackathon-YYYY-MM`).
2. Update `participant-pack/image.env` to the new alias.
3. Sync `participant-pack/` to the public repo `saf-mcp-hackathon` and push:
   - Preferred: `scripts/publish-participant.sh` (uses `git subtree split` and pushes to `main`).
   - Alt: manual copy/rsync to a checkout of the public repo.
4. Tag the participant repo with the same alias for traceability.
5. Announce only the public repo URL and the alias image.
