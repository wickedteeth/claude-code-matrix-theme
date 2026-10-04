#!/bin/bash
# Removes the Claude Code Matrix theme installed by install.sh.
set -uo pipefail

DEST="$HOME/.claude"
MARKER="# claude-matrix-theme"

rm -f "$DEST/themes/matrix.json" "$DEST/statusline-matrix.sh" "$DEST/matrix-intro.py" \
      "$DEST/set-terminal-profile.applescript" "$DEST/matrix-shell.zsh"

settings="$DEST/settings.json"
if [ -f "$settings" ] && command -v jq >/dev/null; then
  cp "$settings" "$settings.bak-$(date +%Y%m%d-%H%M%S)"
  tmp=$(mktemp)
  jq 'if .theme == "custom:matrix" then del(.theme) else . end
      | if .statusLine.command == "~/.claude/statusline-matrix.sh" then del(.statusLine) else . end
      | del(.spinnerVerbs, .spinnerTipsOverride)' "$settings" > "$tmp" && mv "$tmp" "$settings"
fi

if [ -f "$HOME/.zshrc" ]; then
  tmp=$(mktemp)
  grep -vF "$MARKER" "$HOME/.zshrc" > "$tmp"; mv "$tmp" "$HOME/.zshrc"
fi

if [ "$(uname)" = Darwin ]; then
  osascript -e 'tell application "Terminal" to if (exists settings set "Matrix") then delete settings set "Matrix"' >/dev/null 2>&1 \
    || echo "Close Terminal tabs using the Matrix profile, then delete it in Terminal → Settings → Profiles."
fi

echo "Matrix theme removed. Restart Claude Code and open a new terminal."
