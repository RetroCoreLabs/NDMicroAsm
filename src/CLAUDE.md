# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this is

NDMicroAsm: the micro code assemblers and disassemblers for NORD-10, ND-110, ND-120, ND-500 and
ND-5000, as one command-line tool, `ndmicroasm`. One project, one test project, no packages
published. The README at the repository root is the user-facing description; this file is the
working notes.

## Layout

The repository root holds only `README.md`, `LICENSE`, `.gitignore`, `.gitattributes` and
`.github/`. Everything else is under `src/`:

- `src/NDMicroAsm/` - the tool. `Program.cs` is the command line; one assembler per CPU
  generation (`ND10Compiler`, `Compiler` for ND-110/ND-120, `ND500Compiler`, `ND5000Compiler`),
  the disassemblers, the token tables and the field tables.
- `src/NDMicroAsm/microcode/` - the micro code sources and every assembled output, kept in git.
- `src/tests/NDMicroAsm.Tests/` - NUnit tests, including the round trips against real dumps.
- `src/eng/assemble-all.ps1` - regenerates every output in `microcode/`.
- `src/docs/` - documents that are not the README. `src/docfx/` - the API site.

Run `dotnet` from `src/`, always with `-nodeReuse:false`.

## Rules that the build enforces

- `TreatWarningsAsErrors`, `EnforceCodeStyleInBuild` and `GenerateDocumentationFile` are on in
  `Directory.Build.props`. A public member without an XML comment, a wrong file header or a
  style violation fails the build. Fix the cause; never add `NoWarn` or a `#pragma`.
- Every `.cs` file starts with the header in `.editorconfig` (`file_header_template`).
- No LINQ, no `foreach`, no FluentAssertions. Index-based `for` loops.
- `ND500Tokens.cs` and `ND5000Tokens.cs` are generated tables; do not edit token rows by hand.

## Facts worth knowing

- The command names `nd500-disasm`, `nd500-asm`, `nd10-asm`, `nd10-disasm` and `nd5000-listing`
  are used by other repositories. Add commands, never rename these.
- The CPU-side emulator does not use this code. It loads the `.CODE` files this tool writes. The
  emulator lives in the NDMicroCpu repository.
- The ND-500 and ND-5000 round-trip tests need the original dumps from the nd500uc and nd5000uc
  repositories; set `ND500UC_MC_DIR` and `ND5000UC_MC_DIR` to their `docs/MC` folders. Unset,
  those tests skip.
- The ND-500 example image differs by two bytes on every assembly: word 0 bits 15-0 carry the
  date (`ND500Compiler.StampDate`).
- Regenerating the outputs with `assemble-all.ps1` must change nothing except that date stamp.
  Anything else that changes is a regression or an intended change; say which.
