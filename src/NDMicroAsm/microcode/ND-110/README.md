# ND-110 micro code

| File | What it is |
|---|---|
| `ND-110-RASK.uc` | The ND-110 RASK micro program (source text, version 0o13). |
| `*.CODE`, `*.LISTING.TXT`, `*.SYMBOLS.TXT`, `*.DETAILS.TXT`, `TOKENS.TXT` | Written by `ndmicroasm nd110-asm`, see [the overview](../../../docs/Microcode-Assemblers.md#files-the-assemblers-write). |
| `REFERENCE/37948L.bin`, `REFERENCE/37949L.bin` | The two EPROM images of the ND-110 3095 card, 32768 bytes each. `37948L` is the LOW chip, `37949L` the HIGH chip. They hold micro code version 0o14 (L). |

## Chip layout

A chip pair holds 8192 words of four 16-bit sub-words. Sub-word k of the word at address a is at byte
a*4+k of both chips (k = 0 is bits 15-0). The HIGH chip holds the upper byte and the LOW chip the lower byte
of each sub-word. This was found by comparing the assembled ND-120 DELILAH-L image with the ND-120 chips
(all 19544 sub-words equal); the same layout reads the ND-110 chips.

## What the source and the chips have in common

Measured by `ND110_Rask_AgainstTheEprom` in `src/tests/NDMicroAsm.Tests/TestND1X0Compiler.cs`:

- The source defines 4865 words. 4257 of them equal the chip word at the same address, so the `.CODE` image is
  in the form of the chips; nothing is inverted afterwards.
- 608 words differ. The source is version 0o13 and the chips are version 0o14: the version word (0o20) differs
  (low 16 bits 0x000B in the source, 0x000C in the chips), and 368 of the other words differ in bit 27 only.
  Why the other 239 differ was not examined.
- The chips hold 3327 words at addresses the source does not define (1279 of them zero). The source is
  not the whole control store.

The header of `ND-110-RASK.uc` says the source was exported from the printed listing by OCR in October 2022,
corrected by hand and checked against ROMs of a real 3095 card. The measurement above is the only check
repeated in this repository.

The chips came from the `reference/roms/ND110` folder of the nd-microcode-meta repository.
