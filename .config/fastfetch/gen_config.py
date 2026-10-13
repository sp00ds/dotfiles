"""Generate the closed-box fastfetch config.

Usage: gen_config.py OUT.jsonc [--preview | --small]
--small: arch_small text logo instead of the wallpaper image.
--preview: no logo, columns relative to the text block (for HTML rendering).
"""
import json
import sys

TOTAL = 90          # right border column; terminal is 91 wide
PAD_L, PAD_R = 1, 2  # logo padding
BOX_W = 53          # box width including both borders
LOGO_W = TOTAL - BOX_W - PAD_L - PAD_R
TEXT_START = PAD_L + LOGO_W + PAD_R  # columns before the box starts

out, preview, small = sys.argv[1], "--preview" in sys.argv, "--small" in sys.argv
if small:  # fallback for terminals without kitty graphics: small Arch logo, same box
    PAD_L, LOGO_W, PAD_R = 2, 14, 3
    TEXT_START = PAD_L + LOGO_W + PAD_R
off = 0 if preview else TEXT_START
RIGHT = off + BOX_W  # absolute column of right border
END = f"\u001b[{RIGHT}G{{#90}}│"

D = "{#90}"


def key(branch, icon, label):
    return f"{D}│ {branch}{{#}} {{#36}}{chr(icon)} {label}"


def row(t, branch, icon, label, fmt, **extra):
    m = {"type": t, "key": key(branch, icon, label), "format": fmt + END}
    m.update(extra)
    return m


def custom(fmt):
    return {"type": "custom", "format": fmt + END}


def header(icon, name):
    return custom(f"{D}│ {{#1;34}}{chr(icon)}  {name}")


blank = custom(f"{D}│")
BAR = "{percentage-bar} {percentage} {#90}{used} / {total}"
DISK = "{size-percentage-bar} {size-percentage} {#90}{size-used} / {size-total}"

title_text = "sridhar@archxps"
top_fill = BOX_W - 1 - (3 + len(title_text) + 1)  # "╭" + "─ " + title + " " + fill + "╮"
modules = [
    {"type": "title",
     "format": f"{D}╭─ {{#1;34}}{{user-name}}{D}@{{#1;36}}{{host-name}} {D}" + "─" * top_fill + "╮"},
    blank,
    header(0xF061A, "hardware"),
    row("host", "├", 0xF0322, "host", "{name}"),
    row("cpu", "├", 0xF0EE0, "cpu", "Intel Core i5-12500H {#90}({cores-physical}c/{cores-logical}t)"),
    row("gpu", "├", 0xF08AE, "gpu", "{name}"),
    row("display", "├", 0xF0379, "display", "{width}x{height} @ {refresh-rate} Hz"),
    row("memory", "├", 0xF035B, "memory", BAR),
    row("swap", "├", 0xF04E1, "swap", BAR),
    row("disk", "├", 0xF02CA, "root", DISK, folders="/"),
    row("disk", "├", 0xF02CA, "home", DISK, folders="/home"),
    row("battery", "└", 0xF0079, "battery", "{capacity-bar} {capacity} {#90}{status}"),
    blank,
    header(0xF003B, "software"),
    row("os", "├", 0xF08C7, "os", "{name} {arch}"),
    row("kernel", "├", 0xF033D, "kernel", "{release}"),
    row("wm", "├", 0xF056E, "wm", "{pretty-name} {version} {#90}({protocol-name})"),
    row("terminal", "├", 0xF018D, "term", "{pretty-name} {version}"),
    row("terminalfont", "├", 0xF06D6, "font", "{name} {size}pt"),
    row("shell", "├", 0xF1183, "shell", "{pretty-name} {version}"),
    row("packages", "└", 0xF03D6, "pkgs", "{pacman} pacman {#90}·{#} {flatpak-all} flatpak"),
    blank,
    header(0xF051F, "status"),
    row("uptime", "├", 0xF0150, "uptime", "{days}d {hours}h {minutes}m"),
    row("localip", "└", 0xF0A5F, "network", "{ipv4} {#90}({ifname})"),
    blank,
    custom(f"{D}│  " + " ".join(f"{{#3{i}}}●" for i in range(8)) + "  " + " ".join(f"{{#9{i}}}●" for i in range(8))),
    {"type": "custom", "format": f"{D}╰" + "─" * (BOX_W - 2) + "╯"},
]
ROWS = len(modules)

logo = {"type": "none"} if preview else {
    "type": "builtin", "source": "arch_small", "color": {"1": "cyan", "2": "blue"},
    "padding": {"top": 3, "left": PAD_L, "right": PAD_R},
} if small else {
    "type": "kitty-direct",
    "source": "~/.config/fastfetch/logo.png",
    "width": LOGO_W,
    "height": ROWS,
    "padding": {"top": 0, "left": PAD_L, "right": PAD_R},
}

config = {
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
    "logo": logo,
    "display": {
        "separator": " ",
        "key": {"width": 16},
        "color": {"keys": "cyan"},
        "size": {"binaryPrefix": "si", "ndigits": 1},
        "bar": {"char": {"elapsed": "■", "total": "■"}, "width": 12, "border": None, "color": {"total": "90"}},
        "percent": {"type": ["bar", "num"], "color": {"green": "36", "yellow": "34", "red": "31"}},
    },
    "modules": modules,
}

header_comment = f"""// fastfetch: closed box beside a wallpaper strip. Generated layout:
//   {PAD_L} pad + {LOGO_W}-col logo + {PAD_R} pad + {BOX_W}-col box = right border at col {TOTAL}
//   (half-width kitty window is 91 cols). Logo is ~/.config/fastfetch/logo.png (a fixed 680x1176 crop of a photo).
// Colors are terminal palette numbers so they follow Noctalia:
//   36 cyan = labels, 34 blue = section headers, 90 = dim frame. \\u001b[NG jumps to column N.
"""
with open(out, "w") as f:
    f.write(header_comment + json.dumps(config, indent=2, ensure_ascii=False) + "\n")
print(f"logo {LOGO_W}x{ROWS}, text starts after col {TEXT_START}, right border col {RIGHT}")
