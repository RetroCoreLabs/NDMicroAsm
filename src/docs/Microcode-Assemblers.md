# Microcode Assemblers

`ndmicroasm` assembles micro code for six Norsk Data CPU generations. Each CPU has its own page with
the source dialect, where the token values come from, the output format and the proof.

| CPU | Micro word | Control store | Command | Detail page |
|-----|-----------|---------------|---------|-------------|
| NORD-10, NORD-10/CE | 32 bits | 1k words (NORD-10), 4k words (NORD-10/CE) | `nd10-asm`, `nd10-disasm` | [NORD-10](Microcode-Assemblers/NORD-10.md) |
| ND-100 | 64 bits, 48 used | 2048 words (3033S), plus the CX bank from 0o4000 (3033E-CX) | `nd100-asm` | [ND-100](Microcode-Assemblers/ND-100.md) |
| ND-110 | 64 bits | 64K | `nd110-asm` | [ND-110](Microcode-Assemblers/ND-110.md) |
| ND-120 | 64 bits | 64K | `nd120-asm` (versions K and L) | [ND-120](Microcode-Assemblers/ND-120.md) |
| ND-500 | 144 bits, 9 parts | 8K | `nd500-asm`, `nd500-disasm` | [ND-500](Microcode-Assemblers/ND-500.md) |
| ND-5000 | 128 bits, 8 parts | 16K | `nd5000-asm`, `nd5000-disasm`, `nd5000-listing` | [ND-5000](Microcode-Assemblers/ND-5000.md) |

All six use the token-OR model of the original Norsk Data micro assemblers: each mnemonic contributes a
fixed bit pattern to the micro word, the assembler ORs the contributions of one instruction together,
and two mnemonics setting the same bit is an error.

The ND-100, ND-110 and ND-120 share one assembler class (`ND1X0/Compiler.cs`) and one source dialect, which
is written down on the [ND-110](Microcode-Assemblers/ND-110.md) page. The NORD-10, ND-500 and ND-5000
each have their own dialect on their own page.

## Disassemblers

This tool has a disassembler for the NORD-10, ND-500 and ND-5000 only. Their output reassembles to the
exact original words. For the ND-100, ND-110 and ND-120 the
[VS Code extension](https://retrocorelabs.github.io/vscode-nd-microcode/) and the
[nd100uc web page](https://retrocorelabs.github.io/nd100uc/) disassemble.

## Files the assemblers write

Every assembler writes its files next to the source file. The ND-100, ND-110 and ND-120 assembler writes
five kinds (read from `ND1X0/Compiler.cs` and from the files in `NDMicroAsm/microcode/ND-110/`):

| File | Holds |
|------|-------|
| `NAME.CODE` | The control store image. For the ND-100, ND-110 and ND-120: 10-byte records, address (2 bytes) and word (8 bytes), little-endian. |
| `NAME.LISTING.TXT` | Every source line with its line number and the micro address it was assembled at. |
| `NAME.SYMBOLS.TXT` | The labels, sorted by address, as `000020=VERSN`. |
| `NAME.DETAILS.TXT` | For each word: every mnemonic with its value and description, the word in hexadecimal, in four octal groups and in binary. |
| `TOKENS.TXT` | A dump of the token table that was used (`TOKENS-L.TXT` for ND-120 version L). |

The NORD-10 assembler also writes `NAME.hex` in the prom.hex format.

## Checked against a second implementation

The TypeScript assembler of the VS Code extension gives the same output as this tool for the NORD-10,
ND-100, ND-110, ND-120 and ND-500 sources in `NDMicroAsm/microcode/`, and for the 13 ND-5000 images
(disassemble, then assemble). The one difference is the ND-500 example, whose word 0 holds the assembly
date. This was measured on 21 October 2026 and is not a test in this repository.

## More

- [Round-trip validation and token tables](Microcode-Assemblers/Validation.md)
