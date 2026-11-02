#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
BUILD_DIR=${BUILD_DIR:-"$ROOT/build/amigaos3"}
OUTPUT_DIR=${OUTPUT_DIR:-"$ROOT/build/packages"}
ARCHIVE_NAME=${ARCHIVE_NAME:-"opensurge-0.6.1.3-amigaos3-68040-rc1.tar.gz"}

if [ ! -f "$BUILD_DIR/cmake_install.cmake" ]; then
    echo "missing configured AmigaOS build: $BUILD_DIR" >&2
    exit 2
fi

cmake --install "$BUILD_DIR" --strip
mkdir -p "$OUTPUT_DIR"
tar -C "$ROOT" -czf "$OUTPUT_DIR/$ARCHIVE_NAME" dist
sha256sum "$OUTPUT_DIR/$ARCHIVE_NAME" > "$OUTPUT_DIR/$ARCHIVE_NAME.sha256"

echo "Created $OUTPUT_DIR/$ARCHIVE_NAME"
