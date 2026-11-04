#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
STOVE=${STOVE:-"$HOME/AmigaChrome/stoves/os32-gcc16"}
PREFIX="$STOVE/prefix"
SYSROOT="$PREFIX/m68k-amigaos"
PORT_PREFIX=${AMIGA_PORT_PREFIX:-"$ROOT/build/amigaos3-prefix"}
BUILD_DIR=${BUILD_DIR:-"$ROOT/build/amigaos3"}
CC="$PREFIX/bin/m68k-amigaos-gcc"

if [ ! -x "$CC" ]; then
    echo "missing OpenAmigaGCC compiler: $CC" >&2
    exit 2
fi

missing=0
require_file() {
    if [ ! -e "$1" ]; then
        echo "missing target dependency: $1" >&2
        missing=1
    fi
}

require_file "$PORT_PREFIX/include/allegro5/allegro.h"
require_file "$PORT_PREFIX/include/surgescript.h"
require_file "$PORT_PREFIX/include/physfs.h"
require_file "$PORT_PREFIX/lib/liballegro_monolith-static.a"
require_file "$PORT_PREFIX/lib/libsurgescript-static.a"
require_file "$PORT_PREFIX/lib/libphysfs.a"
require_file "$PORT_PREFIX/lib/libogg.a"
require_file "$PORT_PREFIX/lib/libvorbis.a"
require_file "$PORT_PREFIX/lib/libvorbisfile.a"

if [ "$missing" -ne 0 ]; then
    echo "OpenSurge configuration deferred until the three target libraries above are staged." >&2
    exit 3
fi

cmake -S "$ROOT" -B "$BUILD_DIR" \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT/ports/amigaos3/toolchain.cmake" \
    -DAMIGA_STOVE="$STOVE" \
    -DAMIGA_PORT_PREFIX="$PORT_PREFIX" \
    -DOPEN_SURGE_AMIGAOS3=ON \
    -DOPEN_SURGE_AMIGA_PROFILE="${OPEN_SURGE_AMIGA_PROFILE:-OFF}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
    -DGAME_RUNINPLACE=ON \
    -DGAME_DISTDIR=dist \
    -DALLEGRO_MONOLITH=ON \
    -DSURGESCRIPT_STATIC=ON \
    -DWANT_FASTDRAW=OFF \
    -DWANT_PLAYMOD=OFF \
    -DWANT_BUILD_DATE=OFF \
    -DGAME_BUILD_VERSION=amigaos3-rc3

cmake --build "$BUILD_DIR" --parallel
