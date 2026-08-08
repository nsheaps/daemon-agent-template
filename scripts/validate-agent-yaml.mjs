#!/usr/bin/env node
// Validates agent.yaml against the schema owned by claude-daemon-setup
// (see docs/specs/draft/settings-repo-sync.md in that repo):
//
//   agent:
//     name: my-agent   # required, non-empty
//     description: ""  # optional
//
// This repo intentionally has no dependencies (no binary, no release
// pipeline of its own — see docs/specs/draft/daemon-agent-template.md), so
// this is a minimal regex-based check rather than a full YAML parser.
// TODO: swap for a real YAML library (e.g. `yaml`) if the schema grows
// beyond two flat string fields.

import { readFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = join(__dirname, "..");
const agentYamlPath = join(repoRoot, "agent.yaml");

function fail(message) {
  console.error(`agent.yaml validation failed: ${message}`);
  process.exit(1);
}

if (!existsSync(agentYamlPath)) {
  fail(`${agentYamlPath} does not exist`);
}

const contents = readFileSync(agentYamlPath, "utf8");

const agentBlockMatch = contents.match(/^agent:\s*$/m);
if (!agentBlockMatch) {
  fail("missing top-level `agent:` key");
}

const nameMatch = contents.match(/^\s+name:\s*(.+?)\s*$/m);
if (!nameMatch) {
  fail("missing `agent.name` key");
}

// Strip surrounding quotes and inline comments for a bare scalar value.
const rawName = nameMatch[1].replace(/\s+#.*$/, "");
const name = rawName.replace(/^["']|["']$/g, "").trim();

if (name.length === 0) {
  fail("`agent.name` must not be empty");
}

const slug = name.toLowerCase();
if (!/^[a-z0-9-]+$/.test(slug)) {
  fail(
    `agent.name "${name}" must slugify to [a-z0-9-] only (got "${slug}") — ` +
      "this value is used directly in service/launchd identifiers"
  );
}

console.log(`agent.yaml OK: agent.name = "${name}" (slug: "${slug}")`);
