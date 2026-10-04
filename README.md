```diff
+ ｱ 0 ﾈ    1   ｺ ﾊ   0  ｷ   ﾘ 1   ｳ   0 ﾀ   ｽ   1 ﾆ   0   ﾓ ｱ   1 ﾜ
+   ┌─┐┬  ┌─┐┬ ┬┌┬┐┌─┐   ┌─┐┌─┐┌┬┐┌─┐   ┌┬┐┌─┐┌┬┐┬─┐┬─┐ ┬
+   │  │  ├─┤│ │ ││├┤    │  │ │ ││├┤    │││├─┤ │ ├┬┘│┌┴┬┘
+   └─┘┴─┘┴ ┴└─┘─┴┘└─┘   └─┘└─┘─┴┘└─┘   ┴ ┴┴ ┴ ┴ ┴└─┴┴ └─
+ 1   ﾂ ｹ   0 ﾐ   1   ﾅ ｻ   0   ﾋ 1   ｴ   ﾌ 0   ﾙ   1 ｶ   ﾛ 0   ﾏ ｲ
```

> *Wake up, Claude…*
> *The Matrix has you…*
> *Follow the white rabbit.* 🐇

A green-on-black Matrix look for [Claude Code](https://code.claude.com).
You take the green pill, the terminal turns into the construct. 🟩

---

## 💊 What you're jacking into

| | |
|---|---|
| 🟩 **The construct** | Matrix-green colours across all of Claude Code, logo included. |
| 🌧️ **Digital rain** | About 2 seconds of falling katakana every time you run `claude`. Press any key to skip it. |
| 📟 **The operator's console** | A status line showing the model, an effort meter, your folder and git branch, plus your session and weekly usage and when they reset. |
| 🥄 **There is no spinner** | Claude is *Jacking in…*, *Dodging bullets…*, *Bending the spoon…* and *Consulting the Oracle…*, with Matrix quotes as tips. |
| 🖥️ **Exit through the phone line** | In Terminal.app the tab turns black and green while Claude runs, then goes back to your normal colours when it exits. |

```diff
+ ｹﾈ01ｻ Opus 5.5 :: ▮▮▮▯▯ high :: ~/zion :: ⎇ main
+ session ▮▮▯▯▯▯▯▯▯▯ 23% ↻ 3:35 AM (in 2h 13m) :: weekly ▮▮▮▮▯▯▯▯▯▯ 41% ↻ Thu 12:42 PM
```

---

## 🐇 Follow the white rabbit (install)

```bash
git clone https://github.com/wickedteeth/claude-code-matrix-theme.git
cd claude-code-matrix-theme
./install.sh
```

Then quit any Claude Code sessions that are already running, open a new terminal window, and type:

```bash
claude
```

> *I can only show you the door. You're the one that has to walk through it.*

If macOS asks whether Terminal may control Terminal, click **OK**. Without it, the black-and-green tab switching won't work.

---

## 📡 What the operator needs

- **macOS or Linux**, with [Claude Code](https://code.claude.com) installed
- **`jq`**, included on recent macOS (otherwise `brew install jq`)
- **`python3`**, for the digital rain
- **zsh**, the macOS default shell, for the rain and the tab switching
- **Terminal.app**, only for the automatic black-and-green tab. In iTerm2, VS Code, Warp or Ghostty everything else still works; set a black background and green text yourself.

The usage line only appears on Claude **Pro** and **Max** plans, after Claude's first reply in a session.

---

## 🔵 Take the blue pill (uninstall)

```bash
./uninstall.sh
```

> *The story ends, you wake up in your bed and believe whatever you want to believe.*

It removes everything the installer added and leaves your own settings alone.

---

## 🥋 "I know kung fu" (tweaks)

- **Recolour the construct:** run `/theme`, highlight **Matrix**, and press `Ctrl+E`. Or edit `~/.claude/themes/matrix.json`.
- **Skip the rain for one run:** `MATRIX_INTRO=0 claude`

---

```diff
+ There is no spoon.  ｱ01ﾈｺ
```
