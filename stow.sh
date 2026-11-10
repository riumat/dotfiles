#!/bin/bash

cd $(dirname $(realpath $0))

STOW_ARGS=$@

mkdir -p ~/.claude/hooks

stow $STOW_ARGS -t ~ .

chmod +x ~/.config/polybar/calendar.sh 2>/dev/null
chmod +x ~/.config/polybar/date.sh 2>/dev/null

CLAUDE_SETTINGS=~/.claude/settings.json
[ -f "$CLAUDE_SETTINGS" ] || echo '{}' > "$CLAUDE_SETTINGS"
tmp=$(mktemp)
jq '
  .statusLine = {"type":"command","command":"~/.claude/statusline.sh","padding":0}
  | .hooks = {
      "PreCompact": [{
        "matcher": "auto",
        "hooks": [{"type":"command","command":"~/.claude/hooks/precompact-instructions.sh","timeout":10}]
      }],
      "SessionStart": [{
        "matcher": "compact",
        "hooks": [{"type":"command","command":"~/.claude/hooks/postcompact-git.sh","timeout":10}]
      }]
    }
' "$CLAUDE_SETTINGS" > "$tmp" && mv "$tmp" "$CLAUDE_SETTINGS"
