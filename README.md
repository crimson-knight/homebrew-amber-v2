# Amber Framework V2 CLI - Homebrew Tap (retired)

The `amber-v2` formula is retired. Install the Amber V2 CLI from the Amber
Framework tap, which builds the tagged release tarball verified by sha256 and
installs its shards with `minecart install --frozen`:

```bash
brew tap amberframework/amber_cli
brew install amberframework/amber_cli/amber_cli
```

That formula installs `amber` and `amber-lsp` (v2.0.7 at the time of
retirement) and depends on `minecart`.

## Moving an existing install

```bash
brew uninstall amber-v2
brew install amberframework/amber_cli/amber_cli
amber --version
```

`brew install crimson-knight/amber-v2/amber-v2` now stops with a message that
names the replacement formula.
