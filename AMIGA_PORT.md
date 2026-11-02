# Amiga port intake: Open Surge

- Port Atlas: [g-open-surge](https://www.amicradle.com/ports/#g-open-surge)
- Priority: `P2`
- Atlas decision: `evaluate`
- Upstream source: `https://github.com/alemart/opensurge`
- Atlas source pin: `Unverified`
- Imported commit: `61975c23e7e877a55dfcab0e10f035907ae4ecb4`
- Rights state: `review`

## Target contract

Primary target: AmigaOS 3.x / AmiCradle AC090 / Motorola 68040 + FPU.

Use the OPEN platform libraries where applicable: OpenGPU, OpenAudio/OpenAHI, OpenInput, OpenSocket and measured OpenMulticore work. Preserve a correct 68040 fallback and do not assume Roadshow.

No build, runtime, playability or release claim is made by this source-intake commit. Upstream submodules are not initialised. Original commercial game data remains external.

## Rights and data boundary

review; Allegro/Lua dependency and assets licence review.
