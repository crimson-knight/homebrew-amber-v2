# Amber Framework V2 CLI - Homebrew Tap (retired)

The `amber-v2` formula is retired. Install the Amber V2 CLI from the Amber
Framework tap, `amberframework/amber_cli/amber_cli`. It builds the tagged
v2.0.7 release tarball (sha256
`6e90f3cdba3ed87cefbf7443ab93da627af314fac5960a4b9288ae80e31f591f`), installs
its shards with `minecart install --frozen`, and installs `amber` and
`amber-lsp`. It depends on `minecart` 2025.11.25.8 (sha256
`15c7c0af5f29dbd5d651fbfe90bfe1c0cd614a5e72a55ccacc2c246c6e1ed38f`).

`brew install crimson-knight/amber-v2/amber-v2` now stops with a message that
names the replacement formula.

## Moving an existing install

If `amber_cli` is already installed, run `brew uninstall amber-v2` and stop here.
Otherwise run this block; each step runs only if the one before it passed. The
old kegs (`amber-v2`, and `shards-alpha` or legacy `amber` if present) are only
unlinked, so they stay installed and trusted, until the replacement is installed
and every command reports its exact version. Both replacement formula files must
be the reviewed ones (whole-file sha256) before Homebrew may load them, and only
those two formulae are trusted.

```bash
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_AUTOREMOVE=1 HOMEBREW_NO_INSTALL_CLEANUP=1
! brew list --formula amber_cli >/dev/null 2>&1 &&
  ! brew list --formula minecart >/dev/null 2>&1 &&
  brew update && brew tap amberframework/amber_cli &&
  TAP="$(brew --repository amberframework/amber_cli)/Formula" &&
  shasum -a 256 "$TAP/amber_cli.rb" | grep -q "^e127275857579f8d2b5462fc15b76097fdf05d7a9ef940c378ba3a32def6dd08 " &&
  shasum -a 256 "$TAP/minecart.rb" | grep -q "^ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37 " &&
  brew trust --formula amberframework/amber_cli/amber_cli amberframework/amber_cli/minecart &&
  brew fetch --build-from-source amberframework/amber_cli/amber_cli amberframework/amber_cli/minecart &&
  brew unlink amber-v2 &&
  { ! brew list --formula shards-alpha >/dev/null 2>&1 || brew unlink shards-alpha; } &&
  { ! brew list --formula amber >/dev/null 2>&1 || brew unlink amber; } &&
  brew install --build-from-source amberframework/amber_cli/amber_cli &&
  [ "$("$(brew --prefix amber_cli)/bin/amber" --version)" = "Amber CLI v2.0.7" ] &&
  "$(brew --prefix amber_cli)/bin/amber-lsp" --version | grep -q "^amber-lsp 1\.0\.0 (amber_cli 2\.0\.7," &&
  [ "$("$(brew --prefix minecart)/bin/minecart" --version | cut -d" " -f1-2)" = "Minecart 2025.11.25.8" ] &&
  brew uninstall amber-v2
```

Afterward, remove a still-unlinked `shards-alpha` or legacy `amber` with
`brew uninstall` once you no longer need it.

### If a step fails

The old kegs are still installed. In the same terminal, remove what this attempt
installed (the block above stops at its first line if either replacement was
already present) and relink:

```bash
{ ! brew list --formula amber_cli >/dev/null 2>&1 || brew uninstall --ignore-dependencies amber_cli; } &&
  { ! brew list --formula minecart >/dev/null 2>&1 || brew uninstall --ignore-dependencies minecart; } &&
  brew link amber-v2 &&
  { ! brew list --formula shards-alpha >/dev/null 2>&1 || brew link shards-alpha; } &&
  { ! brew list --formula amber >/dev/null 2>&1 || brew link amber; } &&
  amber --version
```
