#!/usr/bin/env bash
# Validates that .claude/{skills,agents,rules} are exactly one level deep:
#   .claude/skills/<item-name>/        (a directory — SKILL.md lives inside)
#   .claude/agents/<item-name>.md      (a file)
#   .claude/rules/<item-name>.md       (a file)
#
# Claude Code only discovers these one directory level deep (see
# docs/specs/draft/settings-repo-sync.md in claude-daemon-setup) — the
# daemon symlinks each item individually rather than the parent directory,
# so nested subdirectories beyond an item's own folder are never found.
# This check only cares about the .claude/{skills,agents,rules} level
# itself; content *inside* a skill's own directory (e.g. reference files)
# is unrestricted.

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
claude_dir="${repo_root}/.claude"
status=0

check_dir() {
  local category="$1"
  local dir="${claude_dir}/${category}"

  if [[ ! -d "${dir}" ]]; then
    echo "note: ${dir} does not exist, skipping"
    return 0
  fi

  # Find anything nested more than one level below the category directory,
  # i.e. paths matching .claude/<category>/<item>/<anything>/<more...>
  # (skills legitimately have one extra level for SKILL.md + assets;
  # agents/rules are flat *.md files with no subdirectories at all).
  case "${category}" in
    skills)
      # Allow .claude/skills/<item>/** (SKILL.md and supporting files),
      # disallow .claude/skills/<item>/<subdir>/<subdir2>/... nested
      # deeper than needed to detect a stray extra level under skills
      # itself. The real constraint enforced here is: every item directly
      # under .claude/skills/ must itself be a directory (one skill = one
      # directory), not a loose file.
      while IFS= read -r -d '' entry; do
        if [[ ! -d "${entry}" ]]; then
          echo "error: ${entry} is not a directory (expected one directory per skill)"
          status=1
        fi
      done < <(find "${dir}" -mindepth 1 -maxdepth 1 -print0)
      ;;
    agents | rules)
      # Every item directly under .claude/agents/ or .claude/rules/ must be
      # a file (typically *.md), never a subdirectory.
      while IFS= read -r -d '' entry; do
        if [[ -d "${entry}" ]]; then
          echo "error: ${entry} is a directory (expected a flat *.md file per ${category%s})"
          status=1
        fi
      done < <(find "${dir}" -mindepth 1 -maxdepth 1 -print0)
      ;;
  esac
}

check_dir skills
check_dir agents
check_dir rules

if [[ "${status}" -eq 0 ]]; then
  echo ".claude/{skills,agents,rules} depth check OK"
fi

exit "${status}"
