# DocFX site

The API reference of NDMicroAsm, generated from the XML documentation comments, and the
hand-written guides, published to
GitHub Pages at https://retrocorelabs.github.io/NDMicroAsm/ by `.github/workflows/docs.yml` on
every push to `main`.

## Build it locally

DocFX is pinned in the local tool manifest `src/.config/dotnet-tools.json`, so a local build
uses the same version as the workflow. Run from `src/`:

```powershell
dotnet tool restore
Remove-Item docfx/api/*.yml -ErrorAction SilentlyContinue   # DocFX never deletes pages of removed types
dotnet docfx docfx/docfx.json --warningsAsErrors --serve
```

Then open http://localhost:8080/. Without `--serve` the site is written to `src/docfx/_site/`.
`--warningsAsErrors` is what the workflow uses: a broken link or a bad cross reference fails the
build.

## What each file is

| File | Purpose |
|---|---|
| `docfx.json` | Which project to document (`NDMicroAsm/NDMicroAsm.csproj`), the output folder and the site metadata |
| `index.md` | The landing page |
| `toc.yml` | The top navigation: Home, Guides and API Reference |
| `../docs/toc.yml` | The Guides section: each document in `src/docs/` and the NORD-10 reference dump README. A new document in `src/docs/` needs a line here |
| `api/index.md` | The hand-written front page of the API section |
| `api/*.yml`, `_site/` | Generated on every build and ignored by git |
