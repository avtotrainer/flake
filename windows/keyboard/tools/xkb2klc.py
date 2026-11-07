#!/usr/bin/env python3
"""ge(ergonomic) + ge-custom (xkb) -> Windows MSKLC .klc

usage: xkb2klc.py <ergonomic.xkb> <ge-custom> <out.klc>
"""
import re, sys
ERGO, CUSTOM, OUT = sys.argv[1:4]
G = "an ban gan don en vin zen tan in kan las man nar on par zhar rae san tar un phar khar ghan qar shin chin can jil cil char xan jhan hae he hie we har hoe fi".split()
KS = {f"Georgian_{n}": 0x10D0+i for i, n in enumerate(G)}
KS.update(dict(asciitilde=0x7e, grave=0x60, minus=0x2d, underscore=0x5f, equal=0x3d, plus=0x2b,
  braceleft=0x7b, bracketleft=0x5b, braceright=0x7d, bracketright=0x5d, backslash=0x5c, bar=0x7c,
  colon=0x3a, semicolon=0x3b, quotedbl=0x22, apostrophe=0x27, less=0x3c, comma=0x2c, greater=0x3e,
  period=0x2e, question=0x3f, slash=0x2f, EuroSign=0x20ac, registered=0xae, trademark=0x2122, yen=0xa5,
  copyright=0xa9, paragraph=0xb6, section=0xa7, dagger=0x2020, doubledagger=0x2021, sterling=0xa3,
  multiply=0xd7, cent=0xa2, notsign=0xac, mu=0xb5, exclam=0x21, at=0x40, numbersign=0x23, dollar=0x24,
  percent=0x25, asciicircum=0x5e, ampersand=0x26, asterisk=0x2a, degree=0xb0, parenleft=0x28,
  parenright=0x29, guillemotleft=0xab, guillemotright=0xbb))
def cp(s):
    if s == "noSymbol": return None
    if s.startswith("0x0100"): return int(s[6:], 16)
    if s in KS: return KS[s]
    if len(s) == 1: return ord(s)
    sys.exit(f"unknown keysym {s}")
def parse(path):
    keys = {}
    for m in re.finditer(r'key\s+<(\w+)>\s*\{([^}]*)\[([^\]]*)\]', open(path).read()):
        name, pre, syms = m.groups()
        keys[name] = ([cp(x.strip()) for x in syms.split(",")], "ALPHABETIC" in pre)
    return keys
keys = parse(ERGO); keys.update(parse(CUSTOM))
# xkb key -> (scancode, VK)
POS = {"TLDE":("29","OEM_3"),"AE11":("0c","OEM_MINUS"),"AE12":("0d","OEM_PLUS"),
 "AD11":("1a","OEM_4"),"AD12":("1b","OEM_6"),"BKSL":("2b","OEM_5"),"AC10":("27","OEM_1"),
 "AC11":("28","OEM_7"),"LSGT":("56","OEM_102"),"AB08":("33","OEM_COMMA"),"AB09":("34","OEM_PERIOD"),
 "AB10":("35","OEM_2")}
for i, c in enumerate("1234567890"): POS[f"AE{i+1:02d}"] = (f"{2+i:02x}", c)
for i, c in enumerate("QWERTYUIOP"): POS[f"AD{i+1:02d}"] = (f"{0x10+i:02x}", c)
for i, c in enumerate("ASDFGHJKL"):  POS[f"AC{i+1:02d}"] = (f"{0x1e+i:02x}", c)
for i, c in enumerate("ZXCVBNM"):    POS[f"AB{i+1:02d}"] = (f"{0x2c+i:02x}", c)
CTRL = {"OEM_4":0x1b, "OEM_6":0x1d, "OEM_5":0x1c, "OEM_102":0x1c}
h = lambda v: "-1" if v is None else f"{v:04x}"
rows = []
order = sorted(POS, key=lambda k: int(POS[k][0], 16))
for k in order:
    syms, alpha = keys[k]
    syms = (syms + [None]*4)[:4]
    sc, vk = POS[k]
    cap = 5 if alpha else 0          # 5 = CapsLock -> Shift და AltGr-ის დონეებზეც (FOUR_LEVEL_ALPHABETIC)
    rows.append(f"{sc}\t{vk}\t\t{cap}\t{h(syms[0])}\t{h(syms[1])}\t{h(CTRL.get(vk))}\t{h(syms[2])}\t{h(syms[3])}")
rows.append("39\tSPACE\t\t0\t0020\t0020\t0020\t-1\t-1")
rows.append("53\tDECIMAL\t\t0\t002e\t002e\t-1\t-1\t-1")
KEYNAME = """KEYNAME

01	Esc
0e	Backspace
0f	Tab
1c	Enter
1d	Ctrl
2a	Shift
36	"Right Shift"
37	"Num *"
38	Alt
39	Space
3a	"Caps Lock"
3b	F1
3c	F2
3d	F3
3e	F4
3f	F5
40	F6
41	F7
42	F8
43	F9
44	F10
45	Pause
46	"Scroll Lock"
47	"Num 7"
48	"Num 8"
49	"Num 9"
4a	"Num -"
4b	"Num 4"
4c	"Num 5"
4d	"Num 6"
4e	"Num +"
4f	"Num 1"
50	"Num 2"
51	"Num 3"
52	"Num 0"
53	"Num Del"
54	"Sys Req"
57	F11
58	F12
7c	F13
7d	F14
7e	F15
7f	F16
80	F17
81	F18
82	F19
83	F20
84	F21
85	F22
86	F23
87	F24

KEYNAME_EXT

1c	"Num Enter"
1d	"Right Ctrl"
35	"Num /"
37	"Prnt Scrn"
38	"Right Alt"
45	"Num Lock"
46	Break
47	Home
48	Up
49	"Page Up"
4b	Left
4d	Right
4f	End
50	Down
51	"Page Down"
52	Insert
53	Delete
54	<00>
56	Help
5b	"Left Windows"
5c	"Right Windows"
5d	Application
"""
out = f'''KBD\tkbdgemtv\t"Georgian (Ergonomic, Mtavruli) - avto"

COPYRIGHT\t"(c) 2026 avtotrainer"

COMPANY\t"avtotrainer"

LOCALENAME\t"ka-GE"

LOCALEID\t"00000437"

VERSION\t1.0

SHIFTSTATE

0\t//Column 4
1\t//Column 5 : Shft
2\t//Column 6 :       Ctrl
6\t//Column 7 :       Ctrl Alt
7\t//Column 8 : Shft  Ctrl Alt

LAYOUT\t\t;an extra '@' at the end is a dead key

//SC\tVK_\t\tCap\t0\t1\t2\t6\t7
//--\t----\t\t----\t----\t----\t----\t----\t----

{chr(10).join(rows)}

{KEYNAME}
DESCRIPTIONS

0409\tGeorgian (Ergonomic, Mtavruli) - avto

LANGUAGENAMES

0409\tGeorgian (Georgia)

ENDKBD
'''
open(OUT, "w", encoding="utf-16", newline="\r\n").write(out)
print(f"{OUT}: {len(rows)} keys")
