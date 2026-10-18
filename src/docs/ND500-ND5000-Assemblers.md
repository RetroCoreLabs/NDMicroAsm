# ND-500 and ND-5000 Microcode Assemblers

The compiler project assembles microcode for four Norsk Data CPU generations:

| CPU | Micro word | Storage | Control store | Token table source |
|-----|-----------|---------|---------------|--------------------|
| ND-110 | 64 bits | 4 × 16-bit parts | 64K | ND-06.031.1 Microprogrammer's Guide (`ND110Tokens.cs`) |
| ND-120 | 64 bits | 4 × 16-bit parts | 64K | ND-06.031.1 + version K/L fixups (`ND120Tokens.cs`) |
| ND-500 | **144 bits** | **9 × 16-bit parts CS8..CS0** | 8K | ND-30.013.02 Appendix A, all 721 mnemonics (`ND500Tokens.cs`) |
| ND-5000 | **128 bits** | **8 × 16-bit parts** | 16K | `microcode-5000-def.json` from the nd5000uc project, 609 tokens (`ND5000Tokens.cs`) |

All four use the same token-OR model the original Norsk Data micro assemblers used:
each mnemonic contributes a fixed bit pattern to the micro word, the assembler ORs
the contributions of one instruction together, and two mnemonics setting the same
bit is an error.

## ND-500 (`ND500Compiler`)

Implemented from ND-05.012.01 "ND-500 Micro Program Guide" chapter 14.

- **Micro word**: 144 bits = nine 16-bit control store parts, CS8 = bits 143-128
  down to CS0 = bits 15-0.
- **Token values**: `ND500Tokens.cs` is generated from the 721-entry Appendix A of
  ND-30.013.02 "Test Micro Program Descriptions for ND-500" — the printout of the
  original assembler value file `N500-MNE-VALUES:DATA` — transcribed in the nd500uc
  repository (`docs\ND500-MNEMONIC-VALUES.md` there).
- **Source dialect** (authentic, per guide ch. 14):
  - mnemonics separated by spaces; instruction terminated by `;`, may span lines
  - `#` preceded by whitespace starts a comment; `#` inside a token is a register
    select (`A,AL#17`, `B,X#0`); `%` also accepted as comment character
  - `nnnn/` as first element sets the control store address (octal)
  - `NAME:` as first symbol defines a label; a label reference places the address
    in micro word bits 28-16
  - one octal integer = short argument → bits 15-0 (`A,XD,SARG` selects it)
  - two octal integers `n,n` = long argument → bits 31-0 (`A,XD,LARG`)
  - all constants octal; optional trailing `B` accepted
  - authentic errors: "OR-ing rejected due to overlapping of MNE-values",
    "Attempt to write on former entry", location counter upper limit
  - word 0 bits 15-0 carry the assembly date (year bits 15-9, month 8-5,
    day 4-0), stamped when the assembled code leaves them free — same as the
    original N500 assembler
- **Output**: `.CODE` = full 8K control store image, PACKED18 (18 bytes per word,
  CS8 first, big-endian per part), 147456 bytes. The nd500uc web disassembler
  auto-detects this format — drop the file onto it to inspect the result.
- **Example**: `ND110Compile/uCode/ND-500-EXAMPLE.uc`.

## ND-5000 (`ND5000Compiler` / `ND5000Disassembler`)

- **Micro word**: 128 bits = eight 16-bit parts, Words[0] = bits 127-112 down to
  Words[7] = bits 15-0.
- **Token values**: `ND5000Tokens.cs` is generated from
  `docs\microcode-5000-def.json` in the nd5000uc repository (ND-05.022.1 Microprogram
  Guide appendix). Memory-operation tokens are split contributions (code bit 3 →
  word bit 41, code bits 2-0 → bits 34-32) exactly as the hardware encodes them.
  The canonical non-overlapping field partition lives in `ND5000Fields.cs`.
- **Source dialect**: same as ND-500 (`;`, `#`/`%` comments, `nnnn/`, labels,
  overlap = error) with these differences:
  - label references land in the ND-5000 jump-target field, bits 31-16
  - `FIELDNAME=<octal>` raw field syntax places a value directly in any named
    field (range- and overlap-checked) — the escape hatch for fields without a
    mnemonic for the wanted value
  - no date-stamp behavior (that is ND-500 specific)
- **Output**: full 16K image, 16 bytes per word big-endian (byte 0 = bits
  127-120), 262144 bytes — byte-identical format to the original `MICRO-*.DATA`
  files.
- **`ND5000Disassembler`**: a *lossless* disassembler — every set bit in a word is
  represented by either a mnemonic token or a raw `FIELD=<octal>` fallback, so its
  output reassembles to the exact original word. (The nd5000uc *web* disassembler
  is for human reading and deliberately suppresses defaults; it cannot round-trip.)

## NORD-10 (`ND10Compiler` / `ND10Disassembler`)

The oldest member: the NORD-10 micro program of ND-06.010.01 "NORD-10/S
MICROPROGRAM" (1974). Files: `ND10Tokens.cs`, `ND10Fields.cs`,
`ND10Compiler.cs`, `ND10Disassembler.cs`.

- **Micro word**: 32 bits, one per ROM word. Bits 31-30 select one of four
  formats: ARITHMETIC (00), INTERBLOCK (01), JUMP (10), LOOP (11). The bit
  layout of each format is in the header of `ND10Tokens.cs`.
- **Control store**: 1k words (standard NORD-10) or 4k words (NORD-10/CE).
- **Token values**: the MICMAC mnemonic names and descriptions come from
  section 3.1 of the manual; the bit positions were taken from Anders
  Magnusson's MICMAC reconstruction (micmac.awk / dismac.c in his
  nord10-microcode tools) and then checked against both real PROM dumps by
  the round-trip tests. A few spellings come from the manual's listing
  rather than its table: `ZERO` for the zero test (the table says `Z`, both
  work), `COND` + `CO17` for a conditional word with condition 7, `JMP,CAR`
  as one word, `CALL` for a subroutine jump (the bits are a plain JMP),
  `GREM` for condition 3, `BIO`/`BIR3`/`BM`/`BMISC` for the internal
  register operands, and `ORSHT` carrying bit 10 with bit 18.
- **Source dialect** (MICMAC, as the manual's listing prints it):
  - one micro instruction per line, `%` starts a comment
  - a first item of four octal digits (`0122`) or `nnnn:` sets the address
  - `NAME,` defines a label; a label reference is the jump address, also
    with an offset (`NOINV+1`); `*3` is the current address plus 3
  - a bare octal number ORs into the word as it is (a jump address, or bits
    with no mnemonic such as the odd bit 28 of word 1064 of the 1k dump)
  - an 8-digit hexadecimal word after the address is checked against the
    assembled word (the disassembler's echo of the original)
  - overlapping mnemonics and a doubly written address are errors
- **Output**: `.hex` in the prom.hex format of the dumps (one uppercase
  8-digit hexadecimal word per line, LF, 1024 or 4096 lines) and a
  big-endian binary `.CODE`.
- **Sources in `uCode/`**: `NORD-10.uc` is the 1k micro program in the
  manual's own layout, with the manual's labels, comments and mnemonic order
  read from the PDF listing pages; `NORD-10-CE.uc` is the 4k NORD-10/CE
  micro program (the same 1k plus the extension, which has no known listing
  and is the disassembly with `L<address>` labels). The dumps they must
  reproduce are in `uCode/NORD-10-REFERENCE/` with a README on where they
  come from.
- **Command line**: `ND110Compile nd10-disasm <prom.hex> <out.uc>` and
  `ND110Compile nd10-asm <source.uc>`.
- **Tests**: `TestND110/TestND10Compiler.cs` (token values from the manual,
  the dialect) and `TestND110/TestND10RoundTrip.cs` (both dumps disassemble
  and reassemble bit for bit; both sources assemble to the dumps byte for
  byte).

## Round-trip validation

`TestND110/TestND5000Compiler.cs` proves the ND-5000 implementation against real
microcode: every word of **all 13 preserved ND-5000 microcode images** in
the `docs\MC` folder of the nd5000uc repository (MICRO-5200/5500/5700/5800 in all revisions,
the MIC-*-90-500 variants, and CONTROL-STORE.DATA) is disassembled to tokens and
reassembled:

```
13 images x 16384 words = 212992 words, 0 mismatches, all 128 bits exact
```

This simultaneously validates the token table, the field partition, the
assembler and the disassembler against ground truth. The test auto-skips
(NUnit `Assume`) on machines without the microcode images.

`TestND110/TestND500RoundTrip.cs` proves the ND-500 implementation the same way
against the real control store `docs\MC\CONT-STORE-10611.DATA` in the nd500uc project
(8192 words, the only preserved 144-bit binary): every word disassembles via
`ND500Disassembler` (lossless: Appendix A mnemonic or raw `FIELD=<octal>`
fallback, bits 31-0 as raw long/short arguments) and reassembles bit-exact —
8192 words, 0 mismatches. A second test generates a complete `.uc` source file
and compares the assembled image byte for byte (all 147456 bytes identical).
The same flow is available on the command line:

```
ND110Compile nd500-disasm <controlstore.DATA> <output.uc>
ND110Compile nd500-asm <output.uc>        (writes <output>.CODE)
```

The ND-500 token table is additionally validated by unit tests against the
Appendix A values directly (`TestND110/TestND500Compiler.cs`, 22 tests).
The `FIELDNAME=<octal>` raw field syntax and a `StampDate` switch (turn off
date stamping for bit-exact round trips) now exist on the ND-500 side too;
field names live in `ND500Fields.cs`.

## Regenerating the token tables

Both generated tables carry a header comment naming their source. To regenerate:

- `ND500Tokens.cs`: parse `docs\ND500-MNEMONIC-VALUES.md` in the nd500uc project
  (721 rows of `mnemonic | F1..F9 octal | comment`) into `AddToken` calls,
  F1 = CS8 first.
- `ND5000Tokens.cs`: walk `microcode-5000-def.json` fieldGroups; emit one token
  per field value with a real mnemonic (skip parenthesized placeholders, keep
  meaningful defaults like `D,NONE` and `TBC,NOOP`); contribution =
  value << lowBit; memory ops split across bits 41 / 34-32; fail loudly on
  duplicate mnemonics.
