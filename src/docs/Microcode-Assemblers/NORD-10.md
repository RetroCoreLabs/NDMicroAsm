# NORD-10 assembler

Classes: `ND10Compiler`, `ND10Disassembler`.

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
- **Sources in `NDMicroAsm/microcode/NORD-10/`**: `NORD-10.uc` is the 1k micro program in the
  manual's own layout, with the manual's labels, comments and mnemonic order
  read from the PDF listing pages; `NORD-10-CE.uc` is the 4k NORD-10/CE
  micro program (the same 1k plus the extension, which has no known listing
  and is the disassembly with `L<address>` labels). The dumps they must
  reproduce are in `NDMicroAsm/microcode/NORD-10/REFERENCE/` with a README on where they
  come from.
- **Command line**: `ndmicroasm nd10-disasm <prom.hex> <out.uc>` and
  `ndmicroasm nd10-asm <source.uc>`.
- **Tests**: `tests/NDMicroAsm.Tests/TestND10Compiler.cs` (token values from the manual,
  the dialect) and `tests/NDMicroAsm.Tests/TestND10RoundTrip.cs` (both dumps disassemble
  and reassemble bit for bit; both sources assemble to the dumps byte for
  byte).
