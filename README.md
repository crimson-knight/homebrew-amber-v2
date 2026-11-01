# Amber Framework V2 CLI - Homebrew Tap (retired)

The `amber-v2` formula is retired. Install the Amber V2 CLI from the Amber
Framework tap, `amberframework/amber_cli/amber_cli`. It builds the tagged
release tarball verified by sha256, installs its shards with
`minecart install --frozen`, and installs `amber` and `amber-lsp` (v2.0.7 at the
time of retirement).

Follow the [versioned installation guide](https://amberframework.org/docs/v2/getting-started/installation/).
It trusts the tap with `brew trust --tap amberframework/amber_cli` (which covers
`amber_cli` and its `minecart` dependency), checks out the audited tap commit,
and installs with `HOMEBREW_NO_AUTO_UPDATE=1`, so the formula revision you
install is the one that was reviewed.

## Moving an existing install

Keep the working `amber-v2` keg until the replacement is installed and checked:

```bash
brew unlink amber-v2
# The replacement conflicts with these; remove any that are installed:
brew list --formula shards-alpha >/dev/null 2>&1 && brew uninstall shards-alpha
brew list --formula amber >/dev/null 2>&1 && brew uninstall amber
# Then run the installation guide's commands (tap trust, audited tap commit,
# HOMEBREW_NO_AUTO_UPDATE=1 brew install amberframework/amber_cli/amber_cli).
amber --version            # expect Amber CLI v2.0.7
minecart --version
brew uninstall amber-v2    # only once both commands above work
```

If the replacement install fails, `brew link amber-v2` puts the previous
`amber` back on your PATH, and `brew install crimson-knight/tap/shards-alpha`
restores shards-alpha if you removed it above.

`brew install crimson-knight/amber-v2/amber-v2` now stops with a message that
names the replacement formula.
