# Claude Code Matrix theme — shell integration (sourced from ~/.zshrc).

# A new Terminal.app tab opened from a Claude tab inherits the Matrix profile;
# put plain shells back on the default profile.
if [[ "$TERM_PROGRAM" == Apple_Terminal && -t 1 && -z "$CLAUDECODE" ]]; then
  osascript ~/.claude/set-terminal-profile.applescript "$(tty)" default Matrix >/dev/null 2>&1 &!
fi

# Run Claude Code in Matrix style: switch this Terminal.app tab to the "Matrix"
# profile while Claude runs (restored on exit), and play the digital-rain intro.
# The intro is skipped for -p/--print, pipes, or MATRIX_INTRO=0.
claude() {
  local prev_profile="" tab_tty rc
  if [[ "$TERM_PROGRAM" == Apple_Terminal && -t 1 ]]; then
    tab_tty=$(tty)
    prev_profile=$(osascript ~/.claude/set-terminal-profile.applescript "$tab_tty" Matrix 2>/dev/null)
  fi
  if [[ -t 1 && "${MATRIX_INTRO:-1}" != 0 && " $* " != *" -p "* && " $* " != *" --print "* ]]; then
    command -v python3 >/dev/null && python3 ~/.claude/matrix-intro.py
  fi
  command claude "$@"
  rc=$?
  if [[ -n "$prev_profile" ]]; then
    [[ "$prev_profile" == Matrix ]] && prev_profile=default
    osascript ~/.claude/set-terminal-profile.applescript "$tab_tty" "$prev_profile" >/dev/null 2>&1
  fi
  return $rc
}
