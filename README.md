# NDMicroAsm

[![build](https://github.com/RetroCoreLabs/NDMicroAsm/actions/workflows/build.yml/badge.svg)](https://github.com/RetroCoreLabs/NDMicroAsm/actions/workflows/build.yml)
[![release](https://img.shields.io/github/v/release/RetroCoreLabs/NDMicroAsm)](https://github.com/RetroCoreLabs/NDMicroAsm/releases)
[![licence](https://img.shields.io/github/license/RetroCoreLabs/NDMicroAsm)](LICENSE)
[![downloads](https://img.shields.io/github/downloads/RetroCoreLabs/NDMicroAsm/total)](https://github.com/RetroCoreLabs/NDMicroAsm/releases)

**NDMicroAsm is a command-line tool that assembles and disassembles the micro code of six generations of Norsk Data CPUs, from the NORD-10 of the 1970s to the ND-5000.**

**[Documentation site](https://retrocorelabs.github.io/NDMicroAsm/)** - the guides and the API reference, built by `.github/workflows/docs.yml`.

[What it does](#what-you-can-use-it-for) · [Quick start](#quick-start) · [Building](#building-from-source) · [About Norsk Data micro code](#about-norsk-data-micro-code)

<!-- Reserved for a 5-15 second recording; uncomment once the file exists.
![ndmicroasm assembling the ND-110 RASK micro program, then opening the listing it wrote beside the source.](src/docs/images/readme/demo.gif)
-->

**Latest build:** https://github.com/RetroCoreLabs/NDMicroAsm/releases/latest

## Why it exists

A Norsk Data CPU is microprogrammed: the instruction set the machine presents to its programs
is implemented by micro code in a control store, and the control store of each generation has
its own word size, field layout and assembler mnemonics. The original assemblers ran on the
machines themselves and are gone. To study, repair or re-create that micro code today, the
source form has to be readable and the binary form has to be reproducible.

This tool reads the micro code source dialect of each CPU, writes the control store image and
a listing, and, for the generations where real control store dumps survive, disassembles those
dumps back to source that reassembles bit for bit. That round trip is what proves the token
tables right.

## What you can use it for

- **Assemble ND-100 micro code** from the sources of the 3033S and 3033E-CX cards (the printed Norsk Data
  listing, with its labels and comments, written back from the scan); the images equal the PROM dumps
  byte for byte. The 32 bit floating point listing is there too.
- **Assemble ND-110 and ND-120 micro code** from the `.uc` sources of the RASK and DELILAH
  micro programs in this repository, for example to build the control store an emulator loads.
- **Read a micro program as a listing**, with every mnemonic's meaning from the manual beside
  the word it sets.
- **Disassemble a real control store dump** (NORD-10 PROM, ND-500 PACKED18, ND-5000 `.DATA`)
  to source, change it, and assemble it back.
- **Check a reconstruction against the hardware**: the NORD-10 sources in this repository
  assemble to the two real PROM dumps byte for byte.

## Status

No tagged release yet; `VersionPrefix` is 0.1.0.

| CPU | Micro word | Assembler | Disassembler | Proof |
|---|---|---|---|---|
| NORD-10, NORD-10/CE | 32 bits | yes | yes | both real PROM dumps (1k and 4k) round-trip bit-exact; the checked-in sources assemble to them byte for byte |
| ND-100 | 64 bits (48 used) | yes | no (in the nd-microcode-meta tools) | the 3033S and 3033E-CX sources (written back from the printed listing, instruction words from the chips) assemble to the PROM images byte for byte and split back to the chips with 0 differences (checked 19 October 2026); the 32 bit floating point listing assembles but has no chip dump to be compared with |
| ND-110 | 64 bits | yes | no | the RASK micro program assembles; its listing and symbol files are in the repository |
| ND-120 | 64 bits | yes (versions K and L) | no | the DELILAH-L source assembles to the same image, byte for byte, that the NDMicroCpu emulator runs (checked 18 October 2026); the L EPROM dump itself is not in this repository, so that comparison is not repeated here |
| ND-500 | 144 bits, 9 parts | yes | yes | CONT-STORE-10611, the only preserved ND-500 control store, round-trips byte for byte |
| ND-5000 | 128 bits, 8 parts | yes | yes | all 13 preserved micro code images (212,992 words) round-trip with 0 mismatches |

Test suite: 113 tests, all passing (measured 19 October 2026).

## Prerequisites

| # | Requirement | Needed for | How to check |
|---|---|---|---|
| P1 | .NET SDK 10.0.302 or a later 10.0 feature band (`src/global.json`) | building | `dotnet --list-sdks` |
| P2 | PowerShell 7 or newer | `build.ps1` and the `eng` scripts | `$PSVersionTable.PSVersion` |

## Quick start

**Pre-built binaries** are on the [Releases page](../../releases).

```powershell
# from the repository root
.\src\build.ps1
.\src\publish\win-x64\ndmicroasm.exe nd110-asm src\NDMicroAsm\microcode\ND-110\ND-110-RASK.uc
```

`ndmicroasm` with no arguments prints every command:

| Command | What it does |
|---|---|
| `nd10-asm <source.uc>` | NORD-10 MICMAC source to `.hex` (prom.hex format) and `.CODE` |
| `nd10-disasm <prom.hex> <out.uc>` | lossless disassembly of a NORD-10 PROM dump |
| `nd100-asm <source.uc>` | ND-100 source to `.CODE` (bits 22-27 inverted, as the PROMs hold them), listing, symbols, details |
| `nd110-asm <source.uc>` | ND-110 source to `.CODE`, listing, symbols, details |
| `nd120-asm <source.uc> [K\|L]` | the same with the ND-120 token table; `L` applies the version-L fixup |
| `nd500-asm <source.uc>` | ND-500 source to an 8K-word PACKED18 image |
| `nd500-disasm <image.DATA> <out.uc>` | lossless disassembly of an ND-500 control store |
| `nd5000-asm <source.uc>` | ND-5000 source to a 16K-word `.DATA` image |
| `nd5000-disasm <image.DATA> <out.uc>` | lossless disassembly of an ND-5000 control store |
| `nd5000-listing <image.DATA> <labels.LABE> <out.md>` | a validated markdown listing in the nd5000uc format |

Every assembler writes its outputs next to the source file. The exit code is 0 on success and 1
on any error.

## Building from source

```powershell
# from the repository root
cd src
dotnet build -nodeReuse:false
dotnet test -nodeReuse:false
```

The tests that compare against the original ND-500 and ND-5000 control store dumps skip
themselves unless `ND500UC_MC_DIR` and `ND5000UC_MC_DIR` point at the `docs/MC` folders of the
nd500uc and nd5000uc projects; see [CONTRIBUTING.md](.github/CONTRIBUTING.md).
`src\eng\assemble-all.ps1` regenerates every assembled output in `src/NDMicroAsm/microcode`.

## Current limitations

- **No ND-110 or ND-120 disassembler.** The 64-bit micro words are assembled from source only.
  The nd100uc repository holds a web disassembler for those control stores.
- **Four NORD-10 mnemonics have no known bit value** (ORCAR, SHAR, SHLI, DNO). Neither PROM
  dump uses them, so they are not in the table.
- **The ND-500 example image carries the assembly date** in word 0, as the original assembler
  required, so it differs by two bytes on every run.

## About Norsk Data micro code

Norsk Data was a Norwegian computer maker, in business from 1967 into the early 1990s, whose
NORD-10, ND-100 and ND-500 lines ran universities, industry and the military across Europe.
Each CPU was microprogrammed: a control store of wide micro words, one per clock, defined the
machine's instruction set, and ND documented the micro word format and the assembler mnemonics
for each generation in its microprogrammer's guides. Those guides, the surviving listings and a
handful of real control store dumps are what this tool is built from. The micro code is the
ground truth for emulating these machines faithfully.

## Releases

| Artifact | Target | How it is built |
|---|---|---|
| `ndmicroasm-win-x64.exe` | Windows 64-bit | `.github/workflows/release.yml`, `dotnet publish` single-file self-contained |
| `ndmicroasm-linux-x64.tar.gz` | Linux 64-bit | same workflow, Linux runner |
| `ndmicroasm-osx-x64.tar.gz`, `ndmicroasm-osx-arm64.tar.gz` | macOS Intel and Apple silicon | same workflow, macOS runners |

### Cutting a release

```bash
git tag v<VERSION>
git push origin v<VERSION>
```

The push runs the test job, then one publish job per platform, then attaches the four files to
a GitHub release named after the tag. The tag is the version number of the binaries. One failed
platform means no release at all.

## Documentation

- [Documentation site](https://retrocorelabs.github.io/NDMicroAsm/) - the guides below and the
  API reference, generated from the XML comments
- [ND-500 and ND-5000 assemblers](src/docs/ND500-ND5000-Assemblers.md) - the source dialects,
  where the token values come from, the output formats and how the round trips are validated
- [NORD-10 reference PROM dumps](src/NDMicroAsm/microcode/NORD-10/REFERENCE/README.md) - the two
  real images the NORD-10 sources are checked against
- [DocFX site](src/docfx/README.md) - how the API reference is built

## Origins

The assemblers began as the `ND110Compile` project of the ND-110 micro code emulator repository
and were moved here, unchanged in function, in October 2026. The NORD-10 bit positions follow
Anders Magnusson's MICMAC reconstruction (micmac.awk and dismac.c, 2024), checked against the
real PROM dumps.

## Contributing

See [CONTRIBUTING.md](.github/CONTRIBUTING.md). Security problems go through
[SECURITY.md](.github/SECURITY.md), never a public issue.

## Licence

MIT. See [LICENSE](LICENSE).
