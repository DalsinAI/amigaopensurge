#!/usr/bin/env python3
"""Open Surge's own build and package checks (host, no stove): the port's
toolchain and Allegro's both get -m68040 -msoft-float; the dependencies
build into a scratch prefix at pinned commits, not into the stove; the
package step gates soft float, keeps the benchmark builds out and ships the
licences. MIT, Copyright (c) 2026 AmiCradle Team."""
import json, re, sys
from pathlib import Path

PKG = Path(__file__).resolve().parents[1]
ROOT = PKG.parent
fails = []
def check(ok, what):
    print(("ok   " if ok else "FAIL ") + what)
    if not ok:
        fails.append(what)

tc = (ROOT / "ports/amigaos3/toolchain.cmake").read_text()
check('set(AMIGA_CPU_FLAGS "-m68040 -msoft-float"' in tc and "-m68881" not in tc, "the port's toolchain is soft float")
deps = (ROOT / "ports/amigaos3/build-dependencies.sh").read_text()
check('AMIGA_CPU_FLAGS=${AMIGA_CPU_FLAGS:-"-m68040 -msoft-float"}' in deps, "build-dependencies.sh defaults to soft float")
check('-DAMIGA_CPU_FLAGS="$AMIGA_CPU_FLAGS"' in deps, "and passes it to Allegro's own toolchain")
check("-m68881" not in deps, "build-dependencies.sh has no -m68881")
pins = re.findall(r"^fetch_(?:source|commit) (\S+) https://\S+(?: \S+)? \\\n\s+([0-9a-f]{40})$", deps, re.M)
check(sorted(n for n, _ in pins) == ["amigaallegro", "ogg", "physfs", "surgescript", "vorbis"],
      "every dependency is pinned to a commit")
check('PREFIX=${AMIGA_PORT_PREFIX:-' in deps and "AMIGA_SYSROOT/port-deps" not in deps.split("PREFIX=")[1].split("\n")[0],
      "dependencies install into the port's own prefix, not the stove")
pkg = (PKG / "build-amiga.sh").read_text()
check('AMIGA_PORT_PREFIX="$BUILD/prefix"' in pkg and 'BUILD_DIR="$BUILD/game"' in pkg, "the package build works in scratch folders")
check('AMIGA_CPU_FLAGS="-m68040 -msoft-float"' in pkg, "the package build asks for soft float")
check("soft-float.sh" in pkg and '"$BUILD/deps-build" "$BUILD/game"' in pkg, "it checks the dependencies' objects and the game's")
check('rm -f "$ROOT/opensurge"' in pkg and 'EXE="$ROOT/opensurge"' in pkg, "it starts without a stale executable")
check('rm -f "$D"/opensurge-*' in pkg, "the benchmark and fallback executables stay out")
check("-name '*.obj'" in (PKG / "soft-float.sh").read_text(), "soft-float.sh finds CMake's .obj objects")
spec = json.loads((PKG / "installer.json").read_text())
check(spec["modules"] == ["SDL2.module", "GL.module"] and spec["data"] == [], "SDL2 and GL modules; the data are in the drawer")
port = (ROOT / "AMIGA_PORT.md").read_text()
check("Rights state: `engine GPL-3.0" in port and "licenses" in port, "the rights review is closed with the licences named")
check((ROOT / "licenses").is_dir() and any((ROOT / "licenses").iterdir()), "upstream's licences drawer is there to ship")
allow = [l for l in (PKG / "fpu-allow.txt").read_text().splitlines() if l and not l.startswith("#")]
check(len(allow) > 0 and all("  # " in l for l in allow), "every fpu-allow line has its reason")
print(f"opensurge build and package: {len(fails)} failed")
sys.exit(1 if fails else 0)
