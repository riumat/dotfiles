#!/usr/bin/env bash
# PreCompact hook: stdout becomes instructions for the compaction summary.
cat <<'EOF'
Preserve, as precisely as possible:
- the ticket or spec being worked on (reference and title) and each acceptance criterion with its status: done, in progress, not started;
- every decision or correction the user gave in this conversation, quoted;
- the test seams agreed with the user;
- the active skill and its current step (e.g. impl: build, review, close) and what is left;
- files changed so far and why;
- questions still waiting for the user's answer.
Drop: tool outputs, file contents, exploration that led nowhere.
EOF
