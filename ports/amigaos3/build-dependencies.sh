#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
PREFIX=${AMIGA_PORT_PREFIX:-"$ROOT/build/amigaos3-prefix"}
SOURCE_ROOT=${SOURCE_ROOT:-"$ROOT/build/deps-src"}
BUILD_ROOT=${BUILD_ROOT:-"$ROOT/build/deps-build"}
TOOLCHAIN="$ROOT/ports/amigaos3/toolchain.cmake"
PATCH_ROOT="$ROOT/ports/amigaos3/patches"
AMIGA_STOVE_PATH=${STOVE:-"$HOME/AmigaChrome/stoves/os32-gcc16"}
AMIGA_SYSROOT="$AMIGA_STOVE_PATH/prefix/m68k-amigaos"
AMIGA_SDK_DEPS="$AMIGA_SYSROOT/port-deps"

fetch_source() {
    name=$1
    url=$2
    tag=$3
    expected=$4
    destination="$SOURCE_ROOT/$name"

    if [ ! -d "$destination/.git" ]; then
        git clone --depth 1 --branch "$tag" "$url" "$destination"
    fi

    actual=$(git -C "$destination" rev-parse HEAD)
    if [ "$actual" != "$expected" ]; then
        echo "$name source mismatch: expected $expected, found $actual" >&2
        exit 2
    fi
}

apply_once() {
    source_dir=$1
    patch_file=$2

    if git -C "$source_dir" apply --check "$patch_file" 2>/dev/null; then
        git -C "$source_dir" apply "$patch_file"
    elif git -C "$source_dir" apply --reverse --check "$patch_file" 2>/dev/null; then
        : # already applied
    else
        echo "patch does not apply cleanly: $patch_file" >&2
        exit 2
    fi
}

mkdir -p "$PREFIX" "$SOURCE_ROOT" "$BUILD_ROOT"

fetch_source surgescript https://github.com/alemart/surgescript.git v0.6.1 \
    56bd599302bbca1eea91d0dc8353257845b314ea
apply_once "$SOURCE_ROOT/surgescript" \
    "$PATCH_ROOT/surgescript-0.6.1-amiga-alignment.patch"

cmake -S "$SOURCE_ROOT/surgescript" -B "$BUILD_ROOT/surgescript" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN" \
    -DAMIGA_PORT_PREFIX="$PREFIX" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DWANT_SHARED=OFF \
    -DWANT_STATIC=ON \
    -DWANT_EXECUTABLE=OFF \
    -DWANT_BUILD_DATE=OFF
cmake --build "$BUILD_ROOT/surgescript" --parallel
cmake --install "$BUILD_ROOT/surgescript"

fetch_source physfs https://github.com/icculus/physfs.git release-3.2.0 \
    eb3383b532c5f74bfeb42ec306ba2cf80eed988c
apply_once "$SOURCE_ROOT/physfs" \
    "$PATCH_ROOT/physfs-3.2.0-amiga-platform.patch"

cmake -S "$SOURCE_ROOT/physfs" -B "$BUILD_ROOT/physfs" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN" \
    -DAMIGA_PORT_PREFIX="$PREFIX" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DPHYSFS_BUILD_SHARED=OFF \
    -DPHYSFS_BUILD_STATIC=ON \
    -DPHYSFS_BUILD_TEST=OFF \
    -DPHYSFS_BUILD_DOCS=OFF \
    -DPHYSFS_ARCHIVE_ZIP=ON \
    -DPHYSFS_ARCHIVE_7Z=OFF \
    -DPHYSFS_ARCHIVE_GRP=OFF \
    -DPHYSFS_ARCHIVE_WAD=OFF \
    -DPHYSFS_ARCHIVE_HOG=OFF \
    -DPHYSFS_ARCHIVE_MVL=OFF \
    -DPHYSFS_ARCHIVE_QPAK=OFF \
    -DPHYSFS_ARCHIVE_SLB=OFF \
    -DPHYSFS_ARCHIVE_ISO9660=OFF \
    -DPHYSFS_ARCHIVE_VDF=OFF
cmake --build "$BUILD_ROOT/physfs" --parallel
cmake --install "$BUILD_ROOT/physfs"

fetch_source allegro5 https://github.com/liballeg/allegro5.git 5.2.11.3 \
    9e58c5e03af16810e8cfecec719e69ce4a76b49b
apply_once "$SOURCE_ROOT/allegro5" \
    "$PATCH_ROOT/allegro-5.2.11.3-sdl-no-glu.patch"

cmake -S "$SOURCE_ROOT/allegro5" -B "$BUILD_ROOT/allegro5" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN" \
    -DAMIGA_PORT_PREFIX="$PREFIX" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DALLEGRO_SDL=ON \
    -DSHARED=OFF \
    -DWANT_MONOLITH=ON \
    -DWANT_ALLOW_SSE=OFF \
    -DWANT_DOCS=OFF \
    -DWANT_TESTS=OFF \
    -DWANT_EXAMPLES=OFF \
    -DWANT_DEMO=OFF \
    -DWANT_OPENAL=OFF \
    -DWANT_VIDEO=OFF \
    -DWANT_NATIVE_DIALOG=OFF \
    -DWANT_IMAGE_FREEIMAGE=OFF \
    -DWANT_IMAGE_WEBP=OFF \
    -DWANT_IMAGE_JPG=ON \
    -DWANT_IMAGE_PNG=ON \
    -DWANT_PHYSFS=OFF \
    -DSDL2_INCLUDE_DIR="$AMIGA_SYSROOT/include/SDL2" \
    -DSDL2_LIBRARY_TEMP="$AMIGA_SYSROOT/lib/libSDL2.a" \
    -DOPENGL_gl_LIBRARY="$AMIGA_SYSROOT/lib/libGL.a" \
    -DOPENGL_INCLUDE_DIR="$AMIGA_SYSROOT/include" \
    -DFREETYPE_INCLUDE_DIRS="$AMIGA_SDK_DEPS/include/freetype2" \
    -DFREETYPE_LIBRARY="$AMIGA_SDK_DEPS/lib/libfreetype.a" \
    -DPNG_PNG_INCLUDE_DIR="$AMIGA_SDK_DEPS/include" \
    -DPNG_LIBRARY="$AMIGA_SDK_DEPS/lib/libpng.a" \
    -DZLIB_INCLUDE_DIR="$AMIGA_SDK_DEPS/include" \
    -DZLIB_LIBRARY="$AMIGA_SDK_DEPS/lib/libz.a" \
    -DJPEG_INCLUDE_DIR="$AMIGA_SDK_DEPS/include" \
    -DJPEG_LIBRARY="$AMIGA_SDK_DEPS/lib/libjpeg.a" \
    -DALLEGRO_HAVE_FSEEKO=0 \
    -DALLEGRO_HAVE_FTELLO=0 \
    -DALLEGRO_HAVE_STRERROR_R=0 \
    -DALLEGRO_HAVE_STRERROR_S=0
cmake --build "$BUILD_ROOT/allegro5" --parallel
cmake --install "$BUILD_ROOT/allegro5"

echo "Installed AmigaOS target dependencies in $PREFIX"
