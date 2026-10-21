# ND-120 micro code

| File | What it is |
|---|---|
| `ND-120-DELILAH-K.uc` | DELILAH micro program, version K, written from the printed listing. Assemble with `nd120-asm <file> K`. |
| `ND-120-DELILAH-L.uc` | DELILAH micro program, version L. Assemble with `nd120-asm <file> L`. |
| `*.CODE`, `*.LISTING.TXT`, `*.SYMBOLS.TXT`, `*.DETAILS.TXT`, `TOKENS.TXT`, `TOKENS-L.TXT` | Written by `ndmicroasm nd120-asm`, see [the overview](../../../docs/Microcode-Assemblers.md#files-the-assemblers-write). |
| `REFERENCE/AM27256_45132L.bin`, `REFERENCE/AM27256_45133L.bin` | The two EPROM images of the ND-120 card, 32768 bytes each. `45132L` is the LOW chip, `45133L` the HIGH chip. Micro code version 0o14 (L). |

## Chip layout

A chip pair holds 8192 words of four 16-bit sub-words. Sub-word k of the word at address a is at byte
a*4+k of both chips (k = 0 is bits 15-0). The HIGH chip holds the upper byte and the LOW chip the lower byte
of each sub-word.

## Proof

Measured by the tests in `src/tests/NDMicroAsm.Tests/TestND1X0Compiler.cs`:

- `ND-120-DELILAH-L.uc` assembled as version L: all 4886 words equal the chip word at the same address
  (19544 of 19544 sub-words). The ND-120 image is in the form of the chips with no inversion of bits 22-27.
- `ND-120-DELILAH-K.uc` is version K, a different micro program text from L; 292 of its 4885 words differ
  from the L chips (measured with the same layout, not a test).
- The chips hold 3306 words at addresses the source does not define. They are not examined.

The chips came from the `reference/roms/ND120` folder of the nd-microcode-meta repository.
