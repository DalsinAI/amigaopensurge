# OpenSurge for classic AmigaOS 3.x

This directory establishes the first reproducible cross-build lane for the
OpenAmigaGCC 68040/68881 target used by AmigaChrome.

## Current state

- Upstream OpenSurge source is pinned by the repository commit.
- CMake can now create a classic AmigaOS executable target.
- The executable is configured to run in place so assets remain beside it.
- The build script fails early and names every missing target dependency.
- No successful AmigaOS binary or runtime claim exists yet.

## Dependency gate

OpenSurge 0.6.1.3 directly uses 319 Allegro 5 API symbols across 35 source
files. The available 2016 AmigaOS 4 prototype implements only about 70 symbols,
targets PPC/AmigaOS 4 interfaces, and has no clear reusable license in its
snapshot. It is useful as research evidence but is not vendored here.

The classic target therefore needs these libraries staged under
`build/amigaos3-prefix` (or `$AMIGA_PORT_PREFIX`):

- Allegro 5.2.7-compatible AmigaOS monolith library, including the addons OpenSurge uses;
- SurgeScript 0.6.1 static library;
- PhysicsFS 3.0.2 or newer.

Run `ports/amigaos3/build-first-pass.sh` on the porting host. Until the target
libraries exist, it exits with code 3 and prints the exact missing files. Once
they are staged, the same command performs the real CMake configuration and
compile, ensuring later failures are compiler/linker evidence rather than a
paper plan.

## Canonical target

- OS: classic AmigaOS 3.x
- CPU: Motorola 68040 with 68881-compatible FPU
- compiler: OpenAmigaGCC 16.2
- runtime: libnix (`-mcrt=nix20`)
- display path: OpenGPU/OpenGL through the established AmigaChrome SDK
