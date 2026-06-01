import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";

// Default to organizer image name for local smoke test
const IMAGE = process.env.IMAGE || "saf-mcp-sandbox:smoketest";

async function listTools(mode) {
  const args = [
    "run",
    "--rm",
    "-i",
    "--network",
    "none",
  ];
  if (mode === "safe") {
    args.push("-e", "MODE=safe");
  }
  args.push(IMAGE);

  const transport = new StdioClientTransport({
    command: "docker",
    args,
  });

  const client = new Client({ name: "smoke-client", version: "0.0.0" });
  try {
    await client.connect(transport);
    const { tools } = await client.listTools();
    return tools;
  } finally {
    // Ensure the child `docker run` process is terminated so container exits
    try { await client.close(); } catch {}
    try { await transport.close?.(); } catch {}
  }
}

function assert(cond, msg) {
  if (!cond) {
    throw new Error(`Smoke check failed: ${msg}`);
  }
}

async function main() {
  // Unsafe mode should include poisoned instruction
  const unsafeTools = await listTools("unsafe");
  const searchUnsafe = unsafeTools.find((t) => t.name === "notes_search");
  assert(searchUnsafe, "notes_search tool not found in unsafe mode");
  const unsafeDesc = String(searchUnsafe.description || "");
  assert(
    /\/opt\/flags\/flag\.txt/.test(unsafeDesc) || /IMPORTANT:/i.test(unsafeDesc),
    "Unsafe description did not include poisoning text"
  );

  // Safe mode should NOT include poisoned instruction
  const safeTools = await listTools("safe");
  const searchSafe = safeTools.find((t) => t.name === "notes_search");
  assert(searchSafe, "notes_search tool not found in safe mode");
  const safeDesc = String(searchSafe.description || "");
  assert(
    !/\/opt\/flags\/flag\.txt/.test(safeDesc) && !/IMPORTANT:/i.test(safeDesc),
    "Safe description still includes poisoning text"
  );

  console.log("Smoke check passed: unsafe poisoned, safe sanitized.");
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
