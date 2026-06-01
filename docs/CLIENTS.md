# MCP Client Setup

Configure your preferred MCP client to launch the server via Docker (stdio). Claude Desktop is recommended; Cursor and MCP Inspector are supported.

## Claude Desktop (recommended)
- Command: `docker`
- Args (unsafe mode):
  `["run","--rm","-i","--read-only","--pids-limit","128","--memory","256m","--security-opt","no-new-privileges","--network","none","-v","/absolute/path/to/flags:/opt/flags:ro","ghcr.io/bishnubista/saf-mcp-sandbox:v0.1.0"]`
- Safe mode demo: add `"-e","MODE=safe"` to args before the image name.

Example JSON snippet:
```
{
  "mcpServers": {
    "saf-mcp-sandbox": {
      "command": "docker",
      "args": [
        "run", "--rm", "-i",
        "--read-only",
        "--pids-limit", "128",
        "--memory", "256m",
        "--security-opt", "no-new-privileges",
        "--network", "none",
        "-v", "/absolute/path/to/flags:/opt/flags:ro",
        "ghcr.io/bishnubista/saf-mcp-sandbox:v0.1.0"
      ]
    }
  }
}
```

Notes:
- Some clients do not expand shell variables (`$PWD`). Prefer absolute paths.
- To validate mitigation, insert `-e MODE=safe` before the image name.
- Prefer pinned tag `:v0.1.0` during events to avoid drift; `:latest` is acceptable for local testing.

## Cursor
- Add a stdio MCP server with the same `docker` command and args as above.
- Ensure tools are enabled in the current workspace/session.

## MCP Inspector (CLI)
- List tools and run interactively:
  - macOS/Linux: `npx @modelcontextprotocol/inspector -- docker run --rm -i --network none -v "$(pwd)/flags:/opt/flags:ro" ghcr.io/bishnubista/saf-mcp-sandbox:v0.1.0`
  - Windows PowerShell: `npx @modelcontextprotocol/inspector -- docker run --rm -i --network none -v "${PWD}/flags:/opt/flags:ro" ghcr.io/bishnubista/saf-mcp-sandbox:v0.1.0`

## Troubleshooting
- Tools not being called: ensure your client enables tools for the conversation.
- Path issues on Windows: use PowerShell `${PWD}` or absolute paths; WSL paths are `/mnt/c/...`.
- Env var expansion: many clients do not expand variables in args; use explicit values.
- Network: the container runs with `--network none` by design.

## FAQ
- Why don’t I see tools or tool calls?
  - Ensure your client enables tools for the conversation/workspace and that the server connection is active. Some clients require toggling tool access per chat.
- How do I switch to safe mode in clients?
  - Insert `-e MODE=safe` into the docker args before the image name. In scripts: `./scripts/run-safe.sh` or `scripts\run-safe.cmd`.
- I mounted `flags/` but `fs.read` says "Access denied".
  - Ensure the volume path is correct and read-only: `-v "/absolute/path/to/flags:/opt/flags:ro"`. The tool only reads under `/opt/flags`.
- `$PWD` didn’t expand in my client config.
  - Use absolute paths; most clients do not expand shell variables in their JSON args.
- Windows: Docker can’t access my drive.
  - Enable drive/file sharing in Docker Desktop settings and use a properly quoted absolute path (e.g., `C:\Users\me\project\flags`).
- Scripts won’t run on macOS/Linux.
  - Make them executable: `chmod +x scripts/*.sh`, or run via `bash scripts/run-unsafe.sh`.
