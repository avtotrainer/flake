#!/usr/bin/env bash
# Windows-ის კლავიატურის განლაგებების აგება xkb წყაროებიდან.
#   kbdgemtv — Georgian (Ergonomic, Mtavruli) - avto : NixOS-ის ge-custom (Shift/Caps → მთავრული)
#   kbdgeqmt — Georgian (QWERTY, Mtavruli)            : ge(basic); Shift — როგორც ჩვეულებრივ, Caps Lock → მთავრული
# შედეგი თითოეულზე: klc/<id>.klc, build/<id>/<arch>/<id>.dll, dist/<id>-windows-<ver>{,-x64}.zip
set -euo pipefail
cd "$(dirname "$0")"
GE_CUSTOM=../../modules/nixos/xkb/symbols/ge-custom     # ერგონომიკულის ერთადერთი წყარო — NixOS-ის განლაგება

mkdir -p build dist klc

# psd1-ის Tests: Name, Vk, Sc, Mods (Shift/Caps/AltGr), Expect (კოდი)
test_line() { printf "    @{ Name = '%s'; Vk = %s; Sc = %s; Mods = @(%s); Expect = %s }\r\n" "$@"; }

layout() { # id text desc dllver pkgver caps tests-fn xkb...
  local id=$1 text=$2 desc=$3 dllver=$4 pkgver=$5 caps=$6 tests=$7; shift 7
  local B=build/$id
  echo "== $id ($text)"
  mkdir -p "$B"
  python3 tools/xkb2klc.py --dll "$id" --text "$text" --caps "$caps" --out "klc/$id.klc" "$@"
  python3 tools/klc2c.py "klc/$id.klc" "$B/kbdlayout_tables.inc"
  sed -e "s/@DLL@/$id/g" -e "s/@TEXT@/$text/g" -e "s/@DESC@/$desc/g" \
      -e "s/@VERSION4@/$dllver/g" -e "s/@VERSIONC@/${dllver//./,}/g" src/kbdlayout.rc.in > "$B/kbdlayout.rc"
  llvm-rc /FO "$B/kbdlayout.res" "$B/kbdlayout.rc"

  for spec in "amd64 x86_64-pc-windows-msvc x64" "i386 i686-pc-windows-msvc x86" \
              "arm64 aarch64-pc-windows-msvc arm64" "wow64 i686-pc-windows-msvc x86 -DKBD_WOW64"; do
    set -- $spec
    mkdir -p "$B/$1"
    clang --target="$2" -O2 -c src/kbdlayout.c -o "$B/$1/kbdlayout.obj" -I"$B" \
      -fno-stack-protector -fno-builtin -ffreestanding -fms-extensions -Wall ${4:-}
    lld-link /nologo /dll /noentry /nodefaultlib /machine:"$3" /subsystem:native \
      /merge:.rdata=.data /merge:.text=.data /merge:.bss=.data /section:.data,RE \
      /guard:no /release /dynamicbase /Brepro \
      /out:"$B/$1/$id.dll" "$B/$1/kbdlayout.obj" "$B/kbdlayout.res"
    python3 tools/verify_kbd.py "$B/$1/$id.dll" "$1" "klc/$id.klc" | tail -1
  done

  # საინსტალაციო პაკეტი: installer/* + layout.psd1 + DLL-ები
  local PKG=$B/pkg/$id
  rm -rf "$B/pkg" && mkdir -p "$PKG"
  cp installer/* "$PKG/"
  { printf '\xef\xbb\xbf@{\r\n'
    printf "  Dll   = '%s.dll'\r\n  Text  = '%s'\r\n  Version = '%s'\r\n  Tests = @(\r\n" "$id" "$text" "$pkgver"
    $tests
    printf '  )\r\n}\r\n'; } > "$PKG/layout.psd1"
  printf '%s, v%s\r\nინსტალაცია: install.cmd\r\nჰენდაუტი: docs/windows/ (github.com/avtotrainer/flake)\r\n' "$text" "$pkgver" > "$PKG/README.txt"
  for a in amd64 i386 arm64 wow64; do mkdir -p "$PKG/$a" && cp "$B/$a/$id.dll" "$PKG/$a/"; done
  rm -f dist/"$id"-windows-"$pkgver"*.zip
  (cd "$B/pkg" && python3 - "$id" "$pkgver" <<'PY'
import os, sys, zipfile
i, v = sys.argv[1:3]
for name, skip in ((f"{i}-windows-{v}.zip", ()), (f"{i}-windows-{v}-x64.zip", ("i386", "arm64"))):
    z = zipfile.ZipFile(f"../../../dist/{name}", "w", zipfile.ZIP_DEFLATED, compresslevel=9)
    for r, _, fs in sorted(os.walk(i)):
        if os.path.basename(r) in skip: continue
        for f in sorted(fs): z.write(os.path.join(r, f))
    z.close()
PY
  )
}

tests_ergonomic() {   # Q: ჩ / Ჩ / Ჩ
  test_line 'Q'          0x51 0x10 ""        0x10E9
  test_line 'Shift+Q'    0x51 0x10 "'Shift'" 0x1CA9
  test_line 'CapsLock+Q' 0x51 0x10 "'Caps'"  0x1CA9
}
tests_qwerty() {      # W: წ / ჭ / Წ / Ჭ;  Q: Shift → ლათინური Q, Caps → Ქ
  test_line 'W'                0x57 0x11 ""               0x10EC
  test_line 'Shift+W'          0x57 0x11 "'Shift'"        0x10ED
  test_line 'CapsLock+W'       0x57 0x11 "'Caps'"         0x1CAC
  test_line 'CapsLock+Shift+W' 0x57 0x11 "'Caps','Shift'" 0x1CAD
  test_line 'Shift+Q'          0x51 0x10 "'Shift'"        0x0051
  test_line 'CapsLock+Q'       0x51 0x10 "'Caps'"         0x1CA5
}

layout kbdgemtv "Georgian (Ergonomic, Mtavruli) - avto" "Georgian (Ergonomic, Mtavruli)" 1.0.0.1 1.1.0 alpha \
       tests_ergonomic src/ergonomic.xkb "$GE_CUSTOM"
layout kbdgeqmt "Georgian (QWERTY, Mtavruli)" "Georgian (QWERTY, Mtavruli)" 1.0.0.1 1.0.0 sgcaps \
       tests_qwerty src/ge-basic.xkb

ls -l dist/
