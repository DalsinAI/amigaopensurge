# OpenSurge 0.6.1.3 for classic AmigaOS

This is an early 68040/68881 preview build. Keep `opensurge` beside all the
asset folders in this archive and start it from that directory.

## Target

- classic AmigaOS 3.x
- Motorola 68040 with an FPU
- OpenGPU-compatible OpenGL and the AmigaChrome SDL2 runtime path

The executable is statically linked. Its display, input, timer, audio, PNG,
JPEG, TrueType, ZIP, WAV, and Ogg/Vorbis paths are present in the binary.

## Known limitations

- This cross-build has not yet been started on an AmigaOS installation.
- Native file chooser windows are disabled; the relevant import and browse
  actions report failure instead of opening a chooser.
- Opening web links is disabled until an `OpenURL.library` adapter is added.
- Performance and memory requirements still need measuring on target hardware.

Please capture `opensurge.log` and the exact AmigaOS/OpenGPU configuration when
reporting the first runtime result.
