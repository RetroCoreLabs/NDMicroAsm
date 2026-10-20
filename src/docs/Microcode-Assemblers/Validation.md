# Round-trip validation and token tables

## Round-trip validation

`tests/NDMicroAsm.Tests/TestND5000Compiler.cs` proves the ND-5000 implementation against real
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

`tests/NDMicroAsm.Tests/TestND500RoundTrip.cs` proves the ND-500 implementation the same way
against the real control store `docs\MC\CONT-STORE-10611.DATA` in the nd500uc project
(8192 words, the only preserved 144-bit binary): every word disassembles via
`ND500Disassembler` (lossless: Appendix A mnemonic or raw `FIELD=<octal>`
fallback, bits 31-0 as raw long/short arguments) and reassembles bit-exact —
8192 words, 0 mismatches. A second test generates a complete `.uc` source file
and compares the assembled image byte for byte (all 147456 bytes identical).
The same flow is available on the command line:

```
ndmicroasm nd500-disasm <controlstore.DATA> <output.uc>
ndmicroasm nd500-asm <output.uc>        (writes <output>.CODE)
```

The ND-500 token table is additionally validated by unit tests against the
Appendix A values directly (`tests/NDMicroAsm.Tests/TestND500Compiler.cs`, 22 tests).
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
