<#
.SYNOPSIS
  Reassembles every micro code source in NDMicroAsm\microcode with the tool built from this repo.

.DESCRIPTION
  The assembled outputs (.CODE / .hex images, .LISTING.TXT, .SYMBOLS.TXT, .DETAILS.TXT and the
  TOKENS*.TXT token-table dumps) are kept in git next to their sources, so anyone can read a
  listing on GitHub without building anything. This script is how they are regenerated after a
  change to a source or to an assembler. Run it, then look at `git status`: a changed output is
  either the intended effect of your change or a regression, and the diff tells you which.

  The list below is the only place that says which CPU and which micro code version each source
  is assembled as. It is data, kept in a script on purpose: the tool itself takes the CPU and the
  version as arguments and knows nothing about file names.

  The ND-500 example image differs by two bytes on every run: word 0 bits 15-0 carry the
  assembly date when the source leaves them zero (ND500Compiler.StampDate). That diff is expected.

.PARAMETER Configuration
  Release (default) or Debug - which build of ndmicroasm to run.

.EXAMPLE
  .\eng\assemble-all.ps1
#>
param(
    [ValidateSet('Release', 'Debug')]
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'
$src = Split-Path -Parent $PSScriptRoot
$microcode = Join-Path $src 'NDMicroAsm\microcode'
$exe = Join-Path $src "NDMicroAsm\bin\$Configuration\net10.0\ndmicroasm.exe"

if (-not (Test-Path $exe)) {
    dotnet build (Join-Path $src 'NDMicroAsm\NDMicroAsm.csproj') -c $Configuration -nodeReuse:false
    if ($LASTEXITCODE -ne 0) { throw 'build failed' }
}

# command, source file, extra arguments
$sources = @(
    @('nd10-asm',   'NORD-10.uc'),                       # NORD-10 1k micro program, equals NORD-10-REFERENCE\NORD-10-1K-prom.hex
    @('nd10-asm',   'NORD-10-CE.uc'),                    # NORD-10/CE 4k micro program, equals NORD-10-REFERENCE\NORD-10-CE-4K-prom4k.hex
    @('nd110-asm',  'ND-110-RASK.uc'),                   # ND-110 RASK
    @('nd120-asm',  'ND-120-DELILAH-K.uc', 'K'),         # ND-120 DELILAH version K, from the printed listing
    @('nd120-asm',  'ND-120-DELILAH-L.uc', 'L'),         # ND-120 DELILAH version L, bit-exact against the L EPROM dump
    @('nd120-asm',  'ND-120-DELILAH-L-PATCH.uc', 'L'),   # version L plus COMM,LDIRV in IOXG word 2 (see the source header)
    @('nd500-asm',  'ND-500-EXAMPLE.uc'),                # ND-500 example (word 0 carries the assembly date)
    @('nd500-asm',  'CONT-STORE-10611.uc')               # the real ND-500 control store, disassembled and reassembled bit-exact
)
# No ND-5000 source is checked in: the 13 real ND-5000 images live in the nd5000uc repository and
# are round-tripped by the tests (ND5000UC_MC_DIR), not assembled from a source here.

$failed = 0
foreach ($s in $sources) {
    $file = Join-Path $microcode $s[1]
    if (-not (Test-Path $file)) { throw "source not found: $file" }
    $toolArgs = @($s[0], $file)
    if ($s.Count -gt 2) { $toolArgs += $s[2] }
    Write-Host ("  {0,-12} {1,-28} {2}" -f $s[0], $s[1], $(if ($s.Count -gt 2) { $s[2] } else { '' })) -ForegroundColor Cyan
    & $exe @toolArgs | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Host "    FAILED (exit $LASTEXITCODE)" -ForegroundColor Red; $failed++ }
}

if ($failed -gt 0) { throw "$failed source(s) failed to assemble" }
Write-Host ''
Write-Host "Done. Review the changes with: git -C `"$src`" status"
