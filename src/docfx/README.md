# DocFX site

The API reference of NDMicroAsm, generated from the XML documentation comments and published to
GitHub Pages at https://retrocorelabs.github.io/NDMicroAsm/ by `.github/workflows/docs.yml` on
every push to `main`.

## Build it locally

DocFX is a global .NET tool: `dotnet tool install -g docfx` once.

```powershell
# from the repository root
docfx src/docfx/docfx.json --serve
```

Then open http://localhost:8080/. Without `--serve` the site is written to `src/docfx/_site/`.

## What each file is

| File | Purpose |
|---|---|
| `docfx.json` | Which project to document (`NDMicroAsm/NDMicroAsm.csproj`), the output folder and the site metadata |
| `index.md` | The landing page |
| `toc.yml` | The top navigation: Home and API Reference |
| `api/index.md` | The hand-written front page of the API section |
| `api/*.yml`, `_site/` | Generated on every build and ignored by git |
