#!/usr/bin/env python3
"""Decode KBDTABLES from a built kbd DLL and compare with the .klc LAYOUT."""
import struct, sys
dll, arch, klc = sys.argv[1], sys.argv[2], sys.argv[3]
d = open(dll, "rb").read()
pe = struct.unpack_from("<I", d, 0x3c)[0]
nsec = struct.unpack_from("<H", d, pe+6)[0]; opt = pe+24
magic = struct.unpack_from("<H", d, opt)[0]
base = struct.unpack_from("<Q", d, opt+24)[0] if magic == 0x20b else struct.unpack_from("<I", d, opt+28)[0]
sh = opt + struct.unpack_from("<H", d, pe+20)[0]
secs = [struct.unpack_from("<8sIIII", d, sh+40*i) for i in range(nsec)]
def off(rva):
    for n, vs, va, rs, ro in secs:
        if va <= rva < va+max(vs, rs): return ro + rva - va
    raise ValueError(hex(rva))
exp = struct.unpack_from("<I", d, opt + (112 if magic == 0x20b else 96))[0]
nfun, nnames, afun, anames = struct.unpack_from("<IIII", d, off(exp)+20)
name = d[off(struct.unpack_from("<I", d, off(anames))[0]):].split(b"\0")[0]
frva = struct.unpack_from("<I", d, off(afun))[0]; f = off(frva)
if arch == "amd64":
    assert d[f:f+3] == b"\x48\x8d\x05"; t = frva + 7 + struct.unpack_from("<i", d, f+3)[0]
elif arch in ("i386", "wow64"):
    assert d[f] == 0xb8, d[f:f+8].hex(); t = struct.unpack_from("<I", d, f+1)[0] - base
elif arch == "arm64":
    a, b = struct.unpack_from("<II", d, f)
    imm = ((a >> 29) & 3) | (((a >> 5) & 0x7ffff) << 2)
    page = ((base + frva) & ~0xfff) + (imm << 12)
    t = page + ((b >> 10) & 0xfff) - base
W = 8 if arch != "i386" else 4
def ptr(rva):
    v = struct.unpack_from("<Q" if W == 8 else "<I", d, off(rva))[0]
    return v - base if v else 0
print(f"{dll}: export {name.decode()} -> KBDTABLES rva {t:#x}")
fields = {}
o = t
for nm in ["mods","vkw","dead","kn","kne","knd","vsc"]:
    fields[nm] = ptr(o); o += W
fields["maxvsc"] = d[off(o)]; o += W
fields["e0"] = ptr(o); o += W; fields["e1"] = ptr(o); o += W
fields["flags"], fields["lgmax"], fields["lgsz"] = struct.unpack_from("<IBB", d, off(o)); o += 8
fields["lig"] = ptr(o); o += W
fields["type"], fields["sub"] = struct.unpack_from("<II", d, off(o))
assert fields["flags"] == 0x10001 and fields["type"] == 4 and fields["maxvsc"] == 0x80, fields
# modifiers
m = fields["mods"]; bits = []
vb = ptr(m)
i = 0
while True:
    vk, mb = d[off(vb)+2*i], d[off(vb)+2*i+1]
    if vk == 0: break
    bits.append((vk, mb)); i += 1
maxm = struct.unpack_from("<H", d, off(m+W))[0]
modnum = list(d[off(m+W+2):off(m+W+2)+maxm+1])
assert bits == [(0x10,1),(0x11,2),(0x12,4)] and modnum == [0,1,2,15,15,15,3,4], (bits, modnum)
# vk->wchar tables
tables = {}
tt = fields["vkw"]
while True:
    p = ptr(tt); n, sz = d[off(tt+W)], d[off(tt+W+1)]
    if not p: break
    q = off(p)
    while d[q]:
        vk, attr, w = d[q], d[q+1], struct.unpack_from(f"<{n}H", d, q+2)
        sg = None
        if attr & 0x02:   # SGCAPS: შემდეგი ჩანაწერი (VK 0xFF) = Caps, Caps+Shift
            q += sz; assert d[q] == 0xFF, f"SGCAPS without 0xFF row for vk {vk:#x}"
            sg = list(struct.unpack_from(f"<{n}H", d, q+2))
            assert sg[2:] == list(w[2:]), f"SGCAPS row for vk {vk:#x}: Ctrl/AltGr columns differ"
            sg = sg[:2]
        if vk != 0xFF: tables.setdefault(vk, (attr, w, sg))
        q += sz
    tt += 2*W
# scan code -> vk
vsc = [struct.unpack_from("<H", d, off(fields["vsc"])+2*i)[0] for i in range(0x80)]
# key name sample
kn = ptr(fields["kn"]+W); s = off(kn); keyname = d[s:d.index(b"\0\0", s)+1].decode("utf-16le")
# compare with klc
VKN = {"OEM_1":0xBA,"OEM_PLUS":0xBB,"OEM_COMMA":0xBC,"OEM_MINUS":0xBD,"OEM_PERIOD":0xBE,"OEM_2":0xBF,
       "OEM_3":0xC0,"OEM_4":0xDB,"OEM_5":0xDC,"OEM_6":0xDD,"OEM_7":0xDE,"OEM_102":0xE2,"SPACE":0x20,"DECIMAL":0x6E}
lay = open(klc, encoding="utf-16").read().split("LAYOUT")[1].split("KEYNAME")[0]
bad = 0; n = 0; prev = None
for line in lay.splitlines():
    fl = line.split()
    if line.startswith("//"): continue
    if len(fl) >= 5 and fl[0] == "-1" and prev:          # SGCap-ის Caps სტრიქონი
        want = [int(x, 16) for x in fl[3:5]]
        if tables[prev][2] != want:
            bad += 1; print("MISMATCH caps", fl, tables[prev][2])
        continue
    if len(fl) < 8 or len(fl[0]) != 2: continue
    sc = int(fl[0], 16); vk = VKN.get(fl[1], ord(fl[1]) if len(fl[1]) == 1 else None)
    want = [0xF000 if x == "-1" else int(x, 16) for x in fl[3:8]]
    attr, got, _ = tables[vk]
    prev = vk if fl[2] == "SGCap" else None
    got = list(got) + [0xF000]*(5-len(got))
    if fl[1] == "DECIMAL": want, got = want[:1], got[:1]
    capw = 2 if fl[2] == "SGCap" else int(fl[2])
    if fl[1] == "DECIMAL": vsc[sc] = vk
    if (vsc[sc] & 0xff) != vk or got != want or (fl[1] != "DECIMAL" and attr != capw):
        bad += 1; print("MISMATCH", fl, hex(vsc[sc]), attr, [hex(x) for x in got])
    n += 1
print(f"  {n} keys checked, {bad} mismatches; numpad '5' -> {chr(tables[0x65][1][0])}; keyname[1] = {keyname!r}")
sys.exit(1 if bad else 0)
