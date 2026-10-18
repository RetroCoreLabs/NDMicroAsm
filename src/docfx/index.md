# NDMicroAsm

Micro code assemblers and disassemblers for five generations of Norsk Data CPUs, in one
command-line tool, `ndmicroasm`:

- **NORD-10** and **NORD-10/CE**: 32-bit micro words, the MICMAC mnemonics of ND-06.010.01.
  Both real PROM dumps round-trip bit for bit.
- **ND-110** and **ND-120**: 64-bit micro words, the token tables of the ND-110 and ND-120
  Microprogrammer's Guide, ND-06.031.1 EN (versions K and L).
- **ND-500**: 144-bit micro words in nine 16-bit parts, the 721 mnemonics of Appendix A of
  ND-30.013.02. The real control store CONT-STORE-10611 round-trips byte for byte.
- **ND-5000**: 128-bit micro words in eight 16-bit parts. All 13 preserved micro code images
  round-trip bit for bit.

Every assembler writes its outputs next to the source: the control store image (`.CODE`, plus
`.hex` for the NORD-10), a listing, a symbol file and a details file.

```powershell
ndmicroasm nd110-asm microcode\ND-110-RASK.uc
ndmicroasm nd500-disasm CONT-STORE-10611.DATA CONT-STORE-10611.uc
```

The [API reference](api/index.md) describes the assembler, disassembler and token table classes
for anyone who wants to use them from code rather than from the command line.
