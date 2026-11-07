#!/usr/bin/env python3
"""<layout>.klc -> kbdlayout_tables.inc (VK_TO_WCHARS tables for src/kbdlayout.c)

usage: klc2c.py <in.klc> <out.inc>
"""
import re, sys
KLC, OUT = sys.argv[1:3]
txt = open(KLC, encoding="utf-16").read()
lay = txt.split("LAYOUT")[1].split("KEYNAME")[0]
VK = {"OEM_1":0xBA,"OEM_PLUS":0xBB,"OEM_COMMA":0xBC,"OEM_MINUS":0xBD,"OEM_PERIOD":0xBE,"OEM_2":0xBF,
      "OEM_3":0xC0,"OEM_4":0xDB,"OEM_5":0xDC,"OEM_6":0xDD,"OEM_7":0xDE,"OEM_102":0xE2,
      "SPACE":0x20,"DECIMAL":0x6E}
rows = []
wch = lambda xs: ["0xF000" if x == "-1" else "0x"+x for x in xs]
for line in lay.splitlines():
    f = line.split()
    if line.startswith("//"): continue
    if len(f) >= 5 and f[0] == "-1" and rows and rows[-1][1] == "SGCap":   # SGCap: Caps / Caps+Shift
        rows[-1] = rows[-1][:4] + (wch(f[3:5]),)
        continue
    if len(f) < 8 or not re.fullmatch(r"[0-9a-f]{2}", f[0]): continue
    vk = VK.get(f[1], ord(f[1]) if len(f[1]) == 1 else None)
    rows.append((vk, f[2] if f[2] == "SGCap" else int(f[2]), wch(f[3:8]), f[1], None))
ATTR = {0:"0", 1:"CAPLOK", 4:"CAPLOKALTGR", 5:"CAPLOK|CAPLOKALTGR", "SGCap":"SGCAPS"}
main = []
for vk, cap, ch, n, sg in rows:
    if n == "DECIMAL": continue
    main.append(f"  {{0x{vk:02X}, {ATTR[cap]}, {{{', '.join(ch)}}}}}, /* {n} */")
    if cap == "SGCap":   # SGCAPS-ის შემდეგ მოდის სტრიქონი VK=0xFF. Caps Lock-ის დროს Windows მთლიანად ამ
        # სტრიქონს კითხულობს, ამიტომ Ctrl/AltGr სვეტები იგივე უნდა იყოს, თორემ Caps+AltGr არაფერს დაწერს
        main.append(f"  {{0xFF, 0, {{{', '.join(sg + ch[2:])}}}}}, /* {n}: Caps, Caps+Shift, Ctrl, AltGr, Shift+AltGr */")
extra = """  {0x09, 0, {'\\t','\\t',WCH_NONE,WCH_NONE,WCH_NONE}}, /* TAB */
  {0x6B, 0, {'+','+',WCH_NONE,WCH_NONE,WCH_NONE}}, /* ADD */
  {0x6F, 0, {'/','/',WCH_NONE,WCH_NONE,WCH_NONE}}, /* DIVIDE */
  {0x6A, 0, {'*','*',WCH_NONE,WCH_NONE,WCH_NONE}}, /* MULTIPLY */
  {0x6D, 0, {'-','-',WCH_NONE,WCH_NONE,WCH_NONE}}, /* SUBTRACT */
  {0x08, 0, {0x08,0x08,0x7F,WCH_NONE,WCH_NONE}}, /* BACK */
  {0x1B, 0, {0x1B,0x1B,0x1B,WCH_NONE,WCH_NONE}}, /* ESCAPE */
  {0x0D, 0, {'\\r','\\r','\\n',WCH_NONE,WCH_NONE}}, /* RETURN */
  {0x03, 0, {0x03,0x03,0x03,WCH_NONE,WCH_NONE}}, /* CANCEL */"""
dec = [r for r in rows if r[3] == "DECIMAL"][0][2][0]
open(OUT, "w").write(
  "static const VK_TO_WCHARS5 aVkToWch5[] = {\n" + "\n".join(main) + "\n" + extra +
  "\n  {0, 0, {0,0,0,0,0}}\n};\n\n"
  "static const VK_TO_WCHARS1 aVkToWch1[] = {\n" +
  "".join(f"  {{0x{0x60+i:02X}, 0, {{'{i}'}}}},\n" for i in range(10)) +
  f"  {{0x6E, 0, {{{dec}}}}}, /* DECIMAL */\n  {{0, 0, {{0}}}}\n}};\n")
print(len(main), "main keys")
