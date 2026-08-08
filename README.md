# daemon-agent-template

This is a **GitHub template repo** — fork it (or click "Use this template")
to create your own `CLAUDE_DAEMON_SETTINGS_REPO` for a
[`claude-daemon-setup`](https://github.com/nsheaps/claude-daemon-setup)
daemon.

The daemon clones whatever repo `CLAUDE_DAEMON_SETTINGS_REPO` points at into
`~/.claude-daemon/config-repo/` and syncs its contents into an isolated
Claude Code config root. This repo defines the shape it expects.

## Quick start

1. **Use this template** (GitHub → "Use this template" → "Create a new
   repository"), or fork it.
2. Edit `agent.yaml` — set `agent.name` to something unique. This becomes:
   - the `brew services` label
   - the launchd job label (`com.nsheaps.claude-daemon.<agent.name>`,
     slugified to `[a-z0-9-]`)
   - the Remote Control session name (once `claude remote-control --name`
     ships upstream)
3. Add your own skills, subagents, and rules under `.claude/skills/`,
   `.claude/agents/`, and `.claude/rules/` — replace or delete the shipped
   examples once you understand the shape.
4. Point your daemon host's `CLAUDE_DAEMON_SETTINGS_REPO` environment
   variable at your fork (a git remote URL, or `owner/repo` shorthand for
   GitHub).

## Repo layout

```
agent.yaml                       # required — agent identity, see schema below
.claude/skills/<skill-name>/     # one skill per directory, SKILL.md inside
.claude/agents/<agent-name>.md   # one subagent definition per file
.claude/rules/<rule-name>.md     # one rule per file, always-loaded markdown
```

**The 1-level-deep constraint:** Claude Code only discovers skills one
directory level deep under `.claude/skills/<skill-name>/` (and similarly for
agents and rules). The daemon does not symlink these directories wholesale —
it maintains a symlink farm with one symlink per item, so nesting beyond an
item's own folder won't be discovered. CI in this repo enforces that depth.

## `agent.yaml` schema

```yaml
agent:
  name: my-agent # required. becomes the service label + Remote Control session name.
  description: "" # optional, free text.
```

`agent.name` is slugified (lowercase, `[a-z0-9-]` only) before being used in
service/launchd identifiers.

## What's in this template

- `agent.yaml` — example identity (`example-agent`).
- `.claude/skills/example-skill/` — a working skill that explains itself.
- `.claude/agents/example-agent.md` — a working example subagent.
- `.claude/rules/example-rule.md` — a working example rule.
- `.github/workflows/check.yaml` — CI validating `agent.yaml` and the
  `.claude/**` directory depth constraint. This repo has no binary and no
  release pipeline of its own — the daemon lives in
  `nsheaps/claude-daemon-setup`.

## Status

This template mirrors the settings-repo-sync spec in
[`claude-daemon-setup`](https://github.com/nsheaps/claude-daemon-setup)
(`docs/specs/draft/settings-repo-sync.md` and
`docs/specs/draft/daemon-agent-template.md`). The daemon itself is still
under active scaffolding — see that repo for current status.
