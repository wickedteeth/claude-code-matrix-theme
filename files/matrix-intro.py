#!/usr/bin/env python3
"""Matrix digital-rain intro shown before Claude Code starts. Press any key to skip."""
import random
import select
import shutil
import sys
import termios
import time
import tty

GLYPHS = "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ0123456789Z:.=*+-<>"
HEAD = "\033[1;38;2;220;255;220m"
TRAIL = "\033[38;2;0;255;65m"
DIM = "\033[38;2;0;120;30m"
RESET = "\033[0m"

RAIN_SECONDS = 2.2


def key_pressed():
    return bool(select.select([sys.stdin], [], [], 0)[0])


def out(s):
    sys.stdout.write(s)


def rain(cols, rows):
    drops = [random.randint(-rows, 0) for _ in range(cols)]
    lengths = [random.randint(6, rows) for _ in range(cols)]
    end = time.time() + RAIN_SECONDS
    while time.time() < end:
        buf = []
        for x in range(0, cols, 2):
            y = drops[x]
            if 0 <= y < rows:
                buf.append(f"\033[{y + 1};{x + 1}H{HEAD}{random.choice(GLYPHS)}")
            if 0 <= y - 1 < rows:
                buf.append(f"\033[{y};{x + 1}H{TRAIL}{random.choice(GLYPHS)}")
            if 0 <= y - 4 < rows:
                buf.append(f"\033[{y - 3};{x + 1}H{DIM}{random.choice(GLYPHS)}")
            tail = y - lengths[x]
            if 0 <= tail < rows:
                buf.append(f"\033[{tail + 1};{x + 1}H ")
            drops[x] += 1
            if tail >= rows:
                drops[x] = random.randint(-rows // 2, 0)
                lengths[x] = random.randint(6, rows)
        out("".join(buf))
        sys.stdout.flush()
        if key_pressed():
            return False
        time.sleep(0.045)
    return True



def main():
    if not sys.stdin.isatty() or not sys.stdout.isatty():
        return
    cols, rows = shutil.get_terminal_size()
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    try:
        tty.setcbreak(fd)
        out("\033[?1049h\033[?25l\033[40m\033[2J")
        rain(cols, rows)
    except KeyboardInterrupt:
        pass
    finally:
        termios.tcsetattr(fd, termios.TCSAFLUSH, old)  # also discards the skip keypress
        out(f"{RESET}\033[2J\033[?25h\033[?1049l")
        sys.stdout.flush()


if __name__ == "__main__":
    main()
