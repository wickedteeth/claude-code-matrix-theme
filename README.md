# Claude Code — Matrix theme

A green-on-black Matrix look for [Claude Code](https://code.claude.com):

- **Theme**: Matrix-green colours for the whole Claude Code UI, including the logo.
- **Status line**: random katakana, model, effort meter, folder and git branch, plus
  a second line with your 5-hour session and weekly plan usage and when they reset.
- **Spinner**: Matrix phrases ("Jacking in…", "Bending the spoon…") and quotes as tips.
- **Intro**: about 2 seconds of digital rain each time you run `claude` (any key skips it).
- **Terminal.app**: the tab turns black and green while Claude runs, then goes back to
  your normal profile when it exits.

## Install

```bash
git clone https://github.com/wickedteeth/claude-code-matrix-theme.git
cd claude-code-matrix-theme
./install.sh
```

Then quit any running Claude Code sessions, open a new terminal window, and run `claude`.

**Requirements:** macOS or Linux, Claude Code, `jq` (`brew install jq`), and `python3` for
the intro. The intro and the tab colour switching need zsh (the macOS default shell).
The tab colour switching only works in macOS Terminal.app. In other terminals, set your
own black background and green text.

The usage line only appears on Claude Pro and Max plans, after Claude's first response
in a session.

## Uninstall

```bash
./uninstall.sh
```

## Tweaks

- Change colours with `/theme` → highlight **Matrix** → `Ctrl+E`, or edit `~/.claude/themes/matrix.json`.
- Skip the intro for one run with `MATRIX_INTRO=0 claude`.
