#!/usr/bin/env bash
# kbdgemtv — Windows-ის განლაგების აგება NixOS-ის ge-custom-იდან.
# შედეგი: kbdgemtv.klc (MSKLC-ისთვის), build/<arch>/kbdgemtv.dll, dist/kbdgemtv-windows-<VERSION>.zip
set -euo pipefail
cd "$(dirname "$0")"
VERSION=1.1.0
XKB=../../modules/nixos/xkb/symbols/ge-custom     # ერთადერთი წყარო — NixOS-ის განლაგება

mkdir -p build dist
python3 tools/xkb2klc.py src/ergonomic.xkb "$XKB" kbdgemtv.klc
python3 tools/klc2c.py kbdgemtv.klc build/kbdgemtv_tables.inc
llvm-rc /FO build/kbdgemtv.res src/kbdgemtv.rc

build() { # arch clang-target lld-machine [extra-cflags]
  mkdir -p "build/$1"
  clang --target="$2" -O2 -c src/kbdgemtv.c -o "build/$1/kbdgemtv.obj" -Ibuild \
    -fno-stack-protector -fno-builtin -ffreestanding -fms-extensions -Wall ${4:-}
  lld-link /nologo /dll /noentry /nodefaultlib /machine:"$3" /subsystem:native \
    /merge:.rdata=.data /merge:.text=.data /merge:.bss=.data /section:.data,RE \
    /guard:no /release /dynamicbase /Brepro \
    /out:"build/$1/kbdgemtv.dll" "build/$1/kbdgemtv.obj" build/kbdgemtv.res
  python3 tools/verify_kbd.py "build/$1/kbdgemtv.dll" "$1" kbdgemtv.klc
}
build amd64 x86_64-pc-windows-msvc  x64
build i386  i686-pc-windows-msvc    x86
build arm64 aarch64-pc-windows-msvc arm64
build wow64 i686-pc-windows-msvc    x86 -DKBD_WOW64

# საინსტალაციო პაკეტი
PKG=build/pkg/kbdgemtv
rm -rf build/pkg && mkdir -p "$PKG"
cp installer/* "$PKG/"
printf 'Georgian (Ergonomic, Mtavruli) - avto, v%s\r\nინსტალაცია: install.cmd\r\nჰენდაუტი: docs/windows/keyboard-install.md (avtotrainer/flake)\r\n' "$VERSION" > "$PKG/README.txt"
for a in amd64 i386 arm64 wow64; do mkdir -p "$PKG/$a" && cp "build/$a/kbdgemtv.dll" "$PKG/$a/"; done
# full: ყველა არქიტექტურა; x64: მხოლოდ amd64 + wow64 (სასკოლო კომპიუტერები, პატარა ფაილი Drive-ისთვის)
rm -f dist/kbdgemtv-windows-"$VERSION"*.zip
(cd build/pkg && python3 - "$VERSION" <<'PY'
import os, sys, zipfile
v = sys.argv[1]
for name, skip in ((f"kbdgemtv-windows-{v}.zip", ()), (f"kbdgemtv-windows-{v}-x64.zip", ("i386", "arm64"))):
    z = zipfile.ZipFile(f"../../dist/{name}", "w", zipfile.ZIP_DEFLATED, compresslevel=9)
    for r, _, fs in sorted(os.walk("kbdgemtv")):
        if os.path.basename(r) in skip: continue
        for f in sorted(fs): z.write(os.path.join(r, f))
    z.close()
PY
)
ls -l dist/
