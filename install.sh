#!/bin/bash
# Installs the Claude Code Matrix theme into ~/.claude. Safe to run more than once.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/files"
DEST="$HOME/.claude"
MARKER="# claude-matrix-theme"

green() { printf '\033[38;2;0;255;65m%s\033[0m\n' "$*"; }
warn()  { printf '\033[38;2;212;255;0m! %s\033[0m\n' "$*"; }

if ! command -v jq >/dev/null; then
  echo "jq is required (the status line and this installer use it)."
  echo "Install it with:  brew install jq"
  exit 1
fi
command -v claude >/dev/null || warn "Claude Code (claude) not found on PATH; install it before using the theme."

# 1. Theme, status line, intro, Terminal helper.
themes_existed=1
[ -d "$DEST/themes" ] || themes_existed=0
mkdir -p "$DEST/themes"
cp "$SRC/themes/matrix.json" "$DEST/themes/matrix.json"
cp "$SRC/statusline-matrix.sh" "$SRC/matrix-intro.py" "$SRC/set-terminal-profile.applescript" "$SRC/matrix-shell.zsh" "$DEST/"
chmod +x "$DEST/statusline-matrix.sh" "$DEST/matrix-intro.py"
green "✓ Copied theme files to $DEST"

# 2. Settings: merge our keys into settings.json, keeping everything else.
settings="$DEST/settings.json"
if [ -f "$settings" ]; then
  backup="$settings.bak-$(date +%Y%m%d-%H%M%S)"
  cp "$settings" "$backup"
  if jq -e '.statusLine' "$settings" >/dev/null 2>&1 && \
     [ "$(jq -r '.statusLine.command // ""' "$settings")" != "~/.claude/statusline-matrix.sh" ]; then
    warn "Replacing your existing statusLine (old settings saved in $backup)"
  fi
  tmp=$(mktemp)
  jq -s '.[0] * .[1]' "$settings" "$SRC/settings-fragment.json" > "$tmp"
  mv "$tmp" "$settings"
  green "✓ Updated $settings (backup: $backup)"
else
  cp "$SRC/settings-fragment.json" "$settings"
  green "✓ Created $settings"
fi

# 3. Shell integration (intro + Terminal profile switching) for zsh.
zshrc="$HOME/.zshrc"
if grep -qF "$MARKER" "$zshrc" 2>/dev/null; then
  green "✓ ~/.zshrc already set up"
else
  printf '\n[ -f ~/.claude/matrix-shell.zsh ] && source ~/.claude/matrix-shell.zsh  %s\n' "$MARKER" >> "$zshrc"
  green "✓ Added the Matrix intro to ~/.zshrc"
fi

# 4. macOS Terminal.app profile (used only while Claude runs; default profile untouched).
if [ "$(uname)" = Darwin ]; then
  if osascript >/dev/null <<'EOF'
tell application "Terminal"
	if not (exists settings set "Matrix") then
		set s to make new settings set with properties {name:"Matrix"}
	else
		set s to settings set "Matrix"
	end if
	set background color of s to {0, 0, 0}
	set normal text color of s to {0, 65535, 16705}
	set bold text color of s to {46774, 65535, 51400}
	set cursor color of s to {0, 65535, 16705}
	set font name of s to "Menlo-Regular"
	set font size of s to 14
end tell
EOF
  then
    green "✓ Created the \"Matrix\" Terminal.app profile"
  else
    warn "Couldn't create the Terminal.app profile (allow Terminal automation if macOS asked, then re-run)."
  fi
fi

echo
green "Done. Open a new terminal window and run: claude"
[ "$themes_existed" = 0 ] && warn "Quit any Claude Code sessions that are already running so they pick up the new theme."
exit 0
