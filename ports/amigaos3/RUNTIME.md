# OpenSurge 0.6.1.3 for classic AmigaOS

This is the first 68040/68881 release candidate. Keep `opensurge` beside all the
asset folders in this archive and start it from that directory.

## Target

- classic AmigaOS 3.x
- Motorola 68040 with an FPU
- OpenGPU-compatible OpenGL and the AmigaChrome SDL2 runtime path

## Validated configuration

- AmigaOS 3.2.3 in an AmigaChrome AC090 Cradle lab
- OpenGPU/OpenGL through the existing `SDL2.module`
- windowed and fullscreen rendering, toggled with F10
- Waterworks foreground tiles, collision, HUD, player and colour palette

The pinned `amigaallegro` build keeps deferred bitmap drawing enabled but caps
each held OpenGL submission at one six-vertex quad. Larger submissions currently
lose level layers on this graphics path. This correctness guard is explicit and
reproducible; raising the limit remains a post-release optimisation gate.

The executable is statically linked. Its display, input, timer, audio, PNG,
JPEG, TrueType, ZIP, WAV, and Ogg/Vorbis paths are present in the binary.

## Known limitations

- Native file chooser windows are disabled; the relevant import and browse
  actions report failure instead of opening a chooser.
- Opening web links is disabled until an `OpenURL.library` adapter is added.
- Performance and memory requirements still need measuring on physical 68040
  hardware.

Please capture `opensurge.log` and the exact AmigaOS/OpenGPU configuration when
reporting a runtime problem.
