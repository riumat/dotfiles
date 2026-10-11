#!/usr/bin/env bash
# Status line: "<context tokens> | <5h usage %> | <time to 5h reset>"
input=$(cat)

# Tokens currently in the context window (input + cache)
tokens=$(jq -r '
  (.context_window.current_usage // {}) as $u
  | (($u.input_tokens // 0) + ($u.cache_creation_input_tokens // 0) + ($u.cache_read_input_tokens // 0))
' <<<"$input")
if [ "$tokens" -ge 1000 ] 2>/dev/null; then
  ctx="$(( (tokens + 500) / 1000 ))k"
else
  ctx="${tokens:-0}"
fi

pct=$(jq -r '.rate_limits.five_hour.used_percentage // empty' <<<"$input")
[ -n "$pct" ] && pct="$(printf '%.0f' "$pct")%" || pct="--"

reset=$(jq -r '.rate_limits.five_hour.resets_at // empty' <<<"$input")
if [ -n "$reset" ]; then
  left=$(( reset - $(date +%s) ))
  (( left < 0 )) && left=0
  remaining="$(( left / 3600 ))h$(printf '%02d' $(( left % 3600 / 60 )))m"
else
  remaining="--"
fi

echo "$ctx | $pct | $remaining"
