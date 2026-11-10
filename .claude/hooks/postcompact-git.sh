#!/usr/bin/env bash
# SessionStart (compact) hook: stdout is added to context after compaction.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
echo "Repository state after compaction (from disk, not from the summary):"
echo "Branch: $(git branch --show-current 2>/dev/null)"
echo "git status --short:"
git status --short 2>/dev/null | head -n 50
echo "git diff --stat:"
git diff --stat 2>/dev/null | tail -n 30
exit 0
