# Contributing to NDMicroAsm

Thanks for looking. This file says how to get a build running, what the code is expected to look
like, and what will get a change sent back.

---

## Getting a build

| # | Requirement | How to check |
|---|---|---|
| 1 | The .NET SDK version pinned in `src/global.json` | `dotnet --info` |
| 2 | PowerShell 7 or newer | `$PSVersionTable.PSVersion` |

```powershell
# from the repository root
.\src\build.ps1
```

`build.ps1` builds, runs the tests, and publishes `ndmicroasm` as a single self-contained
executable with no loose DLLs beside it and no .NET install needed on the target machine. It
**stops before publishing if any test fails**. Useful switches: `-Configuration Debug`,
`-SkipTests` when you know why, `-Clean`.

Everything the build needs is on nuget.org; there is no local package feed.

### The round-trip tests against the original control store dumps

Three test fixtures compare the assemblers against real Norsk Data micro code images that are
not in this repository:

| Tests | Image | Where it lives | Environment variable |
|---|---|---|---|
| `TestND500RoundTrip` | `CONT-STORE-10611.DATA`, the only preserved ND-500 control store | `docs/MC` in the nd500uc project | `ND500UC_MC_DIR` |
| `TestND5000Compiler`, `TestND5000Listing` | the 13 preserved ND-5000 `.DATA` images and the `.LABE` label file | `docs/MC` in the nd5000uc repository | `ND5000UC_MC_DIR` |

Point each variable at that folder and the tests run; leave it unset and they skip themselves
(never fail). The NORD-10 PROM dumps are in this repository, so that round trip always runs.

> [!IMPORTANT]
> Pass **`-nodeReuse:false`** on every `dotnet build` and `dotnet test` you run by hand.
> `build.ps1` already does. Node reuse is on by default and leaves MSBuild worker processes
> behind that hold a lock on the output DLL; the next build then quietly keeps the old binary and
> **the tests report green against stale code.**

### Regenerating the assembled outputs

The `.CODE`, `.hex`, `.LISTING.TXT`, `.SYMBOLS.TXT`, `.DETAILS.TXT` and `TOKENS*.TXT` files next
to the sources in `src/NDMicroAsm/microcode` are kept in git so a listing can be read on GitHub
without a build. After a change to a source or to an assembler, regenerate them all:

```powershell
# from the repository root
.\src\eng\assemble-all.ps1
```

Then read `git status`: a changed output is either the intended effect of your change or a
regression, and the diff tells you which. The ND-500 example image changes by two bytes on every
run; word 0 carries the assembly date, as the original assembler required.

---

## What the code is expected to look like

 - **No LINQ, and no `foreach`.** Use index-based `for` loops. Where a hot path allocates, use
   `Span<T>`, `ArrayPool<T>`, `stackalloc` or a ring buffer.
 - **Every public member has an XML documentation comment** that says what the member does and,
   where the code follows a manual, which manual. The build fails on a missing one
   (`GenerateDocumentationFile` with warnings as errors) and the API site is generated from them.
   No `<list>` tags and no entity escapes such as `&lt;` in a comment; write the sentence so the
   character is not needed.
 - **Naming follows the RetroCore Labs C# standard**: PascalCase types, methods and public
   members, camelCase locals and parameters. One adjustment for this code: a constant that names
   a hardware quantity keeps the manual's upper-case spelling (`WORD_PARTS`,
   `CONTROL_STORE_WORDS`, `ADDRESS_MASK`, the field names in `ND10Fields`, `ND500Fields` and
   `ND5000Fields`), because that is the name a reader finds in the micro code listings and the
   manuals.
 - **Unit tests only**, in the existing test project. Never add a standalone program that prints
   something and exits - it cannot fail a build.
 - **No FluentAssertions.** Use NUnit's own asserts.
 - **Keep the comments, and add more.** A comment that records a manual reference, a bit position,
   or the reason a thing is NOT done the obvious way is the most valuable line in the file. Never
   delete one because a style guide prefers less; replace one only when it has become factually
   wrong.
 - **Plain words.** In code, comments, commit messages and documentation alike. No jargon where a
   normal word works.
 - **Run `dotnet format`** from `src` if whitespace drifts; the build enforces the `.editorconfig`
   rules, including the file header on every `.cs` file.
 - **The sub-command names of `ndmicroasm` are a contract.** Other repositories call
   `nd500-disasm`, `nd500-asm`, `nd10-asm`, `nd10-disasm` and `nd5000-listing` by name. Add
   commands; do not rename them.
 - **`ND500Tokens.cs` and `ND5000Tokens.cs` are generated tables.** Do not edit the token rows by
   hand; the header of each file says where the source table lives.

### Naming

Root namespace = project name. The standard is `NAMING.md`, kept beside the repositories. The
organisation is **RetroCoreLabs**; the old name `HackerCorpLabs` is retired and must not appear in
anything new.

---

## Documentation changes

```powershell
# from the repository root
python src\eng\check-docs.py
```

It must exit 0. It fails on a relative link that does not resolve, a relative link that escapes
the repository root, a machine-specific absolute path, and a Mermaid diagram that is malformed or
breaks `MERMAID_COLOR_STANDARDS.md`.

A document added to `src/docs/`, or a README added to a folder under `src/NDMicroAsm/microcode/`,
goes on the documentation site through the Guides tree, which a script writes from the files git
tracks. Commit the document first, then:

```powershell
# from the repository root
python src\docfx\gen_toc.py
```

and commit the changed `src/docs/toc.yml`. The docs workflow runs the same script with `--check`
and fails when the tree is stale. How to build the site locally is in
[src/docfx/README.md](../src/docfx/README.md).

> [!WARNING]
> **Never put an absolute path in anything committed here.** A drive letter or a home directory is
> correct on exactly one machine, and this repository is public. A path inside the repository goes
> repo-relative; a sibling repository is named, not located; anything outside is described. A
> variable such as `%USERPROFILE%` or `~` is fine - that is the portable way to name a per-user
> location.

A README follows `README-TEMPLATE.md`, beside the repositories: one sentence at the top that a
stranger to the subject understands, four badges that can each be wrong, install before
build-from-source, licence last.

---

## Submitting a change

 1. Branch off `main`. Do not commit to `main` directly.
 2. One logical change per commit. A commit message says **what changed and why**, in plain
    words - the subject line in the imperative, then a blank line, then the reasoning. If you
    measured something, put the number in the message.
 3. `.\src\build.ps1` passes, including the tests, before you open the pull request.
 4. Say in the pull request what you verified and how. "Tests pass" on its own is not useful;
    "the NORD-10/CE source still assembles to the 4k PROM dump byte for byte, 111 tests, all
    green" is.
 5. If something is still broken or unfinished, say so plainly. A known gap that is written down
    is fine. One that is hidden is not.

---

## Licence

By contributing you agree your work is licensed under the MIT licence in [LICENSE](../LICENSE).
