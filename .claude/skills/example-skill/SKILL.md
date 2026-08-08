---
name: example-skill
description: Explains what this example skill is and how skills work in a claude-daemon-setup settings repo. Use when you want a reference for how to write your own skill in this template, or when asked to explain the example skill.
---

# Example Skill

This is the one working example skill shipped in `daemon-agent-template`. It
exists to show the shape Claude Code expects — an empty `.claude/skills/`
directory teaches nothing.

## What this skill does

When invoked, it just explains itself: skills live at
`.claude/skills/<skill-name>/SKILL.md`, exactly one directory level deep.
The daemon's symlink farm (see `settings-repo-sync` in
`claude-daemon-setup`) links each `<skill-name>` directory individually into
`~/.claude-daemon/claude/skills/`, so nested subdirectories beyond the skill
folder itself are never discovered.

## Frontmatter conventions

- `name` — must match the directory name.
- `description` — third-person, states what the skill does AND when to use
  it (trigger phrases help Claude decide to invoke it).
- Optional: `tools`, `model` — omit unless you need to restrict/pin them.

## How to make your own

1. Copy this directory to `.claude/skills/<your-skill-name>/`.
2. Rewrite `SKILL.md` with your own frontmatter and instructions.
3. Add any supporting scripts/references alongside it in the same directory
   (subdirectories under the skill's own folder are fine — it's the
   `.claude/skills/` level that must stay one item deep).
4. Delete this example once you have real skills, or leave it as a
   reference — it's harmless either way.
