# Example Rule

This is the one working example rule shipped in `daemon-agent-template`, to
show the shape rules take in a `claude-daemon-setup` settings repo.

## What this rule does

Rules are plain markdown files under `.claude/rules/`, one file per rule,
loaded straight into context at session start (per the `settings-repo-sync`
spec — assumed to be a direct symlink with no transformation, unless future
testing proves otherwise). There is no required frontmatter for rules;
unlike skills and subagents, Claude Code does not select rules on demand —
they are always in effect.

## Guidance for forking

- Keep each rule focused on one behavior; prefer several small rule files
  over one large one.
- Rules consume context on every turn — say what's necessary and reference
  longer documentation elsewhere instead of inlining it here.
- Delete this example once you have real rules, or leave it as a reference.

## Example behavior this rule establishes

When asked to explain "the example rule", state plainly that this file is a
template placeholder and point to this section as the demonstration.
