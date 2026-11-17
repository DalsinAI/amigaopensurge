# OpenSurge 0.6.1.3 for classic AmigaOS

This is the fourth release candidate: one soft-float binary for every 68040 and
68060, and the stove's fpuauto takes the FPU when there is one. Install it with
Install-OpenSurge, or keep `opensurge` beside all the asset folders in its
drawer and start it from there.

## Target

- classic AmigaOS 3.x
- Motorola 68040 or 68060 with an FPU
- OpenGPU-compatible OpenGL and the AmigaChrome SDL2 runtime path

## Validated configuration

- AmigaOS 3.2.3 in an AmigaChrome AC090 Cradle lab
- OpenGPU/OpenGL through the existing `SDL2.module`
- windowed and fullscreen rendering, toggled with F10
- Waterworks foreground tiles, collision, HUD, player and colour palette

The pinned `amigaallegro` build now uses normal unlimited deferred bitmap
batching. It avoids synchronous texture-binding queries and does not back up all
dirty bitmaps on every swap; bitmap backup remains enabled for resize and
fullscreen context changes. Windowed-to-fullscreen testing retains the blue
palette and the complete title and Green Hill level layers.

Release builds use `-O3` and link-time optimisation. A controlled Cradle run of
the same scripted first-level interval measured about 20% less time across the
instrumented update/render/present phases than the non-LTO Release build. The
largest reductions were about 31% in scene update and 13% in scene render. These
are emulator measurements, not physical-68040 guarantees.

OpenSurge game data may be supplied as a stored (uncompressed) ZIP. Compatibility
packs are cached in the user-data directory and invalidated by engine revision,
game ID, archive size and archive timestamp. Music streaming uses larger Amiga
buffers to reduce Vorbis decoder wakeups, and routine log writes are batched.

The executable is statically linked. Its display, input, timer, audio, PNG,
JPEG, TrueType, ZIP, WAV, and Ogg/Vorbis paths are present in the binary.

## Known limitations

- Native file chooser windows are disabled; the relevant import and browse
  actions report failure instead of opening a chooser.
- Opening web links is disabled until an `OpenURL.library` adapter is added.
- Performance and memory requirements still need measuring on physical 68040
  hardware.

Please capture `logfile.txt` and the exact AmigaOS/OpenGPU configuration when
reporting a runtime problem.
