#!/bin/bash
# Matrix-style status line for Claude Code. Reads session JSON on stdin.
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "?"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "?"')
effort=$(echo "$input" | jq -r '.effort.level // empty')
branch=$(git -C "$dir" branch --show-current 2>/dev/null)
dir=${dir/#$HOME/\~}

BRIGHT=$'\033[38;2;0;255;65m'
MID=$'\033[38;2;0;143;17m'
DIM=$'\033[38;2;0;95;20m'
RESET=$'\033[0m'

# A few random katakana/digits for the "digital rain" feel; changes each refresh.
glyphs=(ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ﾀ ﾁ ﾂ ﾃ ﾅ ﾆ ﾇ ﾈ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾗ ﾘ ﾜ 0 1)
rain=""
for _ in 1 2 3 4 5; do rain+="${glyphs[RANDOM % ${#glyphs[@]}]}"; done

line="${DIM}${rain}${RESET} ${BRIGHT}${model}${RESET}"

# Effort meter: low=1 … max=5 filled cells.
if [ -n "$effort" ]; then
  case "$effort" in
    low) n=1 ;; medium) n=2 ;; high) n=3 ;; xhigh) n=4 ;; max) n=5 ;; *) n=0 ;;
  esac
  meter=""
  for i in 1 2 3 4 5; do
    if [ "$i" -le "$n" ]; then meter+="${BRIGHT}▮"; else meter+="${DIM}▯"; fi
  done
  line+=" ${MID}::${RESET} ${meter}${RESET} ${BRIGHT}${effort}${RESET}"
fi

line+=" ${MID}::${RESET} ${BRIGHT}${dir}${RESET}"
[ -n "$branch" ] && line+=" ${MID}::${RESET} ${BRIGHT}⎇ ${branch}${RESET}"

printf '%s\n' "$line"

# Second line: plan usage (5-hour session and 7-day weekly). Only present for
# Pro/Max plans, after the first response of a session.
s_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
s_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
w_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
w_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

WARN=$'\033[38;2;212;255;0m'
HOT=$'\033[38;2;255;59;59m'

# Colour by how much is used: green, then yellow-green past 50%, red past 80%.
pct_color() {
  if [ "$1" -ge 80 ]; then printf '%s' "$HOT"
  elif [ "$1" -ge 50 ]; then printf '%s' "$WARN"
  else printf '%s' "$BRIGHT"; fi
}

bar() {
  local filled=$(( ($1 + 5) / 10 )) out="" i
  for i in 1 2 3 4 5 6 7 8 9 10; do
    if [ "$i" -le "$filled" ]; then out+="$(pct_color "$1")▮"; else out+="${DIM}▯"; fi
  done
  printf '%s%s' "$out" "$RESET"
}

# Format an epoch time with date(1) on macOS (-r) or Linux (-d @).
fmt_time() {
  date -r "$1" "+$2" 2>/dev/null || date -d "@$1" "+$2" 2>/dev/null
}

until_text() {
  local secs=$(( $1 - $(date +%s) ))
  [ "$secs" -lt 0 ] && secs=0
  local d=$(( secs / 86400 )) h=$(( secs % 86400 / 3600 )) m=$(( secs % 3600 / 60 ))
  if [ "$d" -gt 0 ]; then printf '%dd %dh' "$d" "$h"
  elif [ "$h" -gt 0 ]; then printf '%dh %dm' "$h" "$m"
  else printf '%dm' "$m"; fi
}

usage=""
if [ -n "$s_pct" ]; then
  p=$(printf '%.0f' "$s_pct")
  usage+="${MID}session${RESET} $(bar "$p") $(pct_color "$p")${p}%${RESET}"
  [ -n "$s_reset" ] && usage+=" ${DIM}↻${RESET} ${BRIGHT}$(fmt_time "$s_reset" '%-I:%M %p')${RESET} ${MID}(in $(until_text "$s_reset"))${RESET}"
fi
if [ -n "$w_pct" ]; then
  p=$(printf '%.0f' "$w_pct")
  [ -n "$usage" ] && usage+=" ${MID}::${RESET} "
  usage+="${MID}weekly${RESET} $(bar "$p") $(pct_color "$p")${p}%${RESET}"
  [ -n "$w_reset" ] && usage+=" ${DIM}↻${RESET} ${BRIGHT}$(fmt_time "$w_reset" '%a %-I:%M %p')${RESET}"
fi
[ -n "$usage" ] && printf '%s\n' "$usage"
