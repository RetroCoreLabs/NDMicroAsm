# ND-100 reference PROM images

The three files here are the ground truth for the ND-100 assembler of this project.
`ND-100-3033S.uc` and `ND-100-3033E-CX.uc` in the folder above must assemble to them byte for byte;
`src/tests/NDMicroAsm.Tests/TestND100Compiler.cs` checks that.

| File | Words | What it is |
|---|---|---|
| `3033S-microcode.CODE` | 2048 | The 16 microcode PROMs of the 3033S card, combined into 64-bit words. |
| `3033E-CX-microcode.CODE` | 2008 | The 16 microcode PROMs of the base bank of the 3033E-CX card. |
| `3033E-CX-microcode_ext.CODE` | 1529 | The 16 PROMs of the extension bank of the 3033E-CX card; the record addresses start at 0o4000. |

Format: records of 10 bytes, a 16-bit address and a 64-bit word, both little endian, in address order;
words that are all zero are left out. The words are in the form of the chips: bits 22-27 are inverted
(see `../README.md`).

## Where they come from

The chip dumps (Signetics 82S185 PROMs, 2K x 4) are in the `nd-microcode-meta` repository, folder
`reference/roms/ND100`. The files here were made from them with `tools/nd100-combine.py` of that
repository, a Python program that shares no code with this assembler:

```
python3 tools/nd100-combine.py combine --variant 3033S --indir reference/roms/ND100/3033S --outdir <folder>
python3 tools/nd100-combine.py combine --variant 3033E-CX --indir reference/roms/ND100/3033E-CX --outdir <folder>
```

SHA-1 of the files:

```
6f7ceb4a1a29f636bf02b8f4cae6b2319f1db6a9  3033S-microcode.CODE
6cdf9e988a72db33322a0ac8c10093d265f90903  3033E-CX-microcode.CODE
3e329df15b9fa1e6a8b5e5b34abf42c5e1bf25ea  3033E-CX-microcode_ext.CODE
```
