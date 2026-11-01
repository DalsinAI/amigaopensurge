# OpenSurge for classic AmigaOS 3.x

This directory establishes the first reproducible cross-build lane for the
OpenAmigaGCC 68040/68881 target used by AmigaChrome.

## Current state

- Upstream OpenSurge source is pinned by the repository commit.
- CMake can now create a classic AmigaOS executable target.
- The executable is configured to run in place so assets remain beside it.
- The build script fails early and names every missing target dependency.
- SurgeScript 0.6.1, PhysicsFS 3.2.0, and Allegro 5.2.11.3 have verified
  68k static builds.
- No successful AmigaOS binary or runtime claim exists yet.

## Dependency gate

OpenSurge 0.6.1.3 directly uses 319 Allegro 5 API symbols across 35 source
files. The available 2016 AmigaOS 4 prototype implements only about 70 symbols,
targets PPC/AmigaOS 4 interfaces, and has no clear reusable license in its
snapshot. It is useful as research evidence but is not vendored here.

The classic target uses Allegro's official experimental SDL2 backend over the
SDK's target-side SDL2 and OpenGL libraries. It needs these libraries staged under
`build/amigaos3-prefix` (or `$AMIGA_PORT_PREFIX`):

- Allegro 5.2.11.3 static monolith, including the image, font, TTF, audio,
  acodec, primitives, color, and memfile addons OpenSurge uses;
- SurgeScript 0.6.1 static library;
- PhysicsFS 3.0.2 or newer.

Run `ports/amigaos3/build-first-pass.sh` on the porting host. Until the target
libraries exist, it exits with code 3 and prints the exact missing files. Once
they are staged, the same command performs the real CMake configuration and
compile, ensuring later failures are compiler/linker evidence rather than a
paper plan.

`ports/amigaos3/build-dependencies.sh` fetches all three pinned sources, applies
the reviewed classic-Amiga compatibility patches, and cross-compiles them into
the staging prefix. The Allegro patch removes an unused GLU dependency from the
SDL backend; feature-probe overrides select the libc calls actually available on
the target.

## Canonical target

- OS: classic AmigaOS 3.x
- CPU: Motorola 68040 with 68881-compatible FPU
- compiler: OpenAmigaGCC 16.2
- runtime: libnix (`-mcrt=nix20`)
- display path: OpenGPU/OpenGL through the established AmigaChrome SDK
