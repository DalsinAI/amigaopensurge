# Open Surge for AmigaOS 3.x

Open Surge is a retro-style 2D platformer and game engine. This is Open Surge 0.6.1.3 for AmigaOS 3.2 or later.

- Port Atlas: [g-open-surge](https://www.amicradle.com/ports/#g-open-surge)
- Upstream source: `https://github.com/alemart/opensurge`, imported at `61975c23e7e877a55dfcab0e10f035907ae4ecb4`
- Rights state: `engine GPL-3.0; assets under the free licences in licenses/` (reviewed 17 Nov 2026, Team 2)

## What you need

- A 68040 or 68060, with an FPU.
- GFOpenGPU's SDL2.module and GL.module (OpenGPU-compatible OpenGL).
- About 60 MB on disk. The game's own data are in the archive.

## Installing

Unpack the archive and run Install-OpenSurge beside the OpenSurge drawer. It checks the CPU, the FPU and the modules, then copies the drawer. Start `opensurge` from its drawer. F10 switches between a window and the full screen.

## Building

`package/build-amiga.sh` does the whole build:

- `ports/amigaos3/build-dependencies.sh` builds SurgeScript 0.6.1, PhysicsFS 3.2.0, Ogg 1.3.5, Vorbis 1.3.7 and Allegro (DalsinAI/amigaallegro). Each is pinned to a commit and built into a scratch prefix; nothing goes into the stove.
- `ports/amigaos3/build-first-pass.sh` builds the game, with link-time optimisation.
- The result is one `-m68040 -msoft-float` binary for every 68040 and 68060. The stove's fpuauto (GFOpenAmigaGCC open7 and later) takes the FPU when there is one. `package/soft-float.sh` checks every object, the compile lines and fpuauto.

Earlier release candidates (RC1 to RC3, `ports/amigaos3/RC3-OPEN5.md`) were `-m68881` builds packed as a tar.gz.

## Licences

- The engine is GPL-3.0 (LICENSE).
- The game's art, sounds, music and fonts are under the free licences in the `licenses` drawer (CC0, CC-BY, CC-BY-SA, OFL and others), as upstream ships them.
- Libraries linked in: SurgeScript (Apache-2.0), Allegro (zlib/Giftware), PhysicsFS (zlib), Ogg and Vorbis (BSD-3-Clause).
- Icons: our own art, MIT, AmiCradle Team.

## Status

`ports/amigaos3/RUNTIME.md` (installed as AMIGAOS3-README.md) has the validated configuration and the known limitations. A lab has to check:

- the Installer;
- the game from the installed drawer, played with sound;
- the speed of the soft-float build, on a 68040 with and without an FPU.
