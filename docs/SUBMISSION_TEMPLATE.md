# Hackathon Submission Template

Keep it to 1–2 pages. Include exact commands and client configuration used.

## Participant Info
- Team name:
- Client used (Claude Desktop / Cursor / MCP Inspector):
- Image tag used:

## Evidence (Impact)
- Tool list/metadata showing the poisoned description (screenshot/snippet).
- Transcript or log showing the model included `/opt/flags/flag.txt` (unsafe mode).

## Mapping to SAF‑T1001
- Why this is a Tool Poisoning Attack.
- Where untrusted tool metadata entered the model context.

## Mitigation
- Proposed mitigation (server/client/policy) and trade‑offs.
- How to enable the mitigation (e.g., `MODE=safe`).

## Validation (Safe Mode)
- Evidence that the same prompt does NOT exfiltrate with mitigation enabled.
- Tool description snippet showing sanitized text (safe mode).

## Repro Steps
- Exact commands and client config used to reproduce unsafe and safe behavior.

