# Amber Framework V2 CLI - Homebrew Tap (retired)

The `amber-v2` formula is retired. Install the Amber V2 CLI from the Amber
Framework tap, `amberframework/amber_cli/amber_cli`. It builds the tagged
v2.0.7 release tarball (sha256
`6e90f3cdba3ed87cefbf7443ab93da627af314fac5960a4b9288ae80e31f591f`), installs
its shards with `minecart install --frozen`, and installs `amber` and
`amber-lsp`. It depends on `minecart` 2025.11.25.8 (sha256
`15c7c0af5f29dbd5d651fbfe90bfe1c0cd614a5e72a55ccacc2c246c6e1ed38f`).

## Moving an existing install

Each step runs only when the one before it passed. `amber-v2` stays installed
(only unlinked) until the replacement is installed and answers, and
`HOMEBREW_NO_AUTOREMOVE=1` keeps Homebrew from removing unrelated packages.

```bash
brew update
brew tap amberframework/amber_cli
# Both formula files must be the reviewed ones before Homebrew is allowed to load them.
TAP="$(brew --repository amberframework/amber_cli)/Formula" &&
  shasum -a 256 "$TAP/amber_cli.rb" | grep -q "^e127275857579f8d2b5462fc15b76097fdf05d7a9ef940c378ba3a32def6dd08 " &&
  shasum -a 256 "$TAP/minecart.rb" | grep -q "^ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37 " &&
  brew trust --tap amberframework/amber_cli &&
  HOMEBREW_NO_AUTO_UPDATE=1 brew fetch --build-from-source \
    amberframework/amber_cli/amber_cli amberframework/amber_cli/minecart &&
  brew unlink amber-v2 &&
  { ! brew list --formula shards-alpha >/dev/null 2>&1 || HOMEBREW_NO_AUTOREMOVE=1 brew uninstall shards-alpha; } &&
  { ! brew list --formula amber >/dev/null 2>&1 || HOMEBREW_NO_AUTOREMOVE=1 brew uninstall amber; } &&
  HOMEBREW_NO_AUTO_UPDATE=1 brew install --build-from-source amberframework/amber_cli/amber_cli &&
  amber --version | grep -q "2\.0\.7" &&
  minecart --version &&
  HOMEBREW_NO_AUTOREMOVE=1 brew uninstall amber-v2
```

### If a step fails

Remove whatever part of the replacement was installed, then relink the old CLI:

```bash
{ ! brew list --formula amber_cli >/dev/null 2>&1 ||
    HOMEBREW_NO_AUTOREMOVE=1 brew uninstall --ignore-dependencies amber_cli; } &&
  { ! brew list --formula minecart >/dev/null 2>&1 ||
    HOMEBREW_NO_AUTOREMOVE=1 brew uninstall --ignore-dependencies minecart; } &&
  brew link amber-v2 &&
  amber --version
# Then, only if the migration removed shards-alpha:
HOMEBREW_NO_AUTO_UPDATE=1 brew install crimson-knight/tap/shards-alpha && shards-alpha --version
```

`brew install crimson-knight/amber-v2/amber-v2` now stops with a message that
names the replacement formula.
