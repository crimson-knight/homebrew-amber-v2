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

Paste this whole block into one bash terminal. It records what is installed,
linked and trusted before it changes anything, so `rollback_amber_v2` undoes only
what this attempt did. Each step runs only if the one before it passed; old kegs
are only unlinked until the replacement passes `check_amber_cli`; both replacement
formula files must be the reviewed ones (whole-file sha256) before Homebrew may
load them; and autoremove, install cleanup and auto-update are off throughout.

```bash
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_AUTOREMOVE=1 HOMEBREW_NO_INSTALL_CLEANUP=1
installed() { brew list --formula "$1" >/dev/null 2>&1; }
linked() { brew info --json=v2 "$1" 2>/dev/null | grep -q '"linked_keg": *"[^"]'; }
trusted() { brew trust --json v1 | grep -q "\"$1\""; }
check_amber_cli() {
  c=$(brew --prefix amber_cli) && m=$(brew --prefix minecart) &&
    out=$("$c/bin/amber" --version) && [ "$out" = "Amber CLI v2.0.7" ] &&
    out=$("$c/bin/amber-lsp" --version) && case "$out" in "amber-lsp 1.0.0 (amber_cli 2.0.7,"*) ;; *) false ;; esac &&
    out=$("$m/bin/minecart" --version) && [ "$out" = "Minecart 2025.11.25.8 (2026-10-06)" ] &&
    [ "$(readlink "$(brew --prefix)/bin/amber")" = "../Cellar/amber_cli/2.0.7/bin/amber" ]
}
had_cli=$(installed amber_cli && echo y); had_mc=$(installed minecart && echo y)
had_link_v2=$(linked amber-v2 && echo y); had_link_sa=$(linked shards-alpha && echo y)
had_link_amber=$(linked amber && echo y)
had_trust_cli=$(trusted amberframework/amber_cli/amber_cli && echo y)
had_trust_mc=$(trusted amberframework/amber_cli/minecart && echo y)
rollback_amber_v2() {
  { [ -n "$had_cli" ] || ! installed amber_cli || brew uninstall --ignore-dependencies amber_cli; } &&
    { [ -n "$had_mc" ] || ! installed minecart || brew uninstall --ignore-dependencies minecart; } &&
    { [ -n "$had_trust_cli" ] || brew untrust --formula amberframework/amber_cli/amber_cli; } &&
    { [ -n "$had_trust_mc" ] || brew untrust --formula amberframework/amber_cli/minecart; } &&
    { [ -z "$had_link_sa" ] || brew link shards-alpha; } &&
    { [ -z "$had_link_amber" ] || brew link amber; } &&
    { [ -z "$had_link_v2" ] || brew link amber-v2; }
}
if [ -n "$had_cli" ]; then
  # amber_cli is already installed: check it, then remove amber-v2.
  check_amber_cli && brew uninstall amber-v2
else
  brew update && brew tap amberframework/amber_cli &&
    TAP="$(brew --repository amberframework/amber_cli)/Formula" &&
    shasum -a 256 "$TAP/amber_cli.rb" | grep -q "^e127275857579f8d2b5462fc15b76097fdf05d7a9ef940c378ba3a32def6dd08 " &&
    shasum -a 256 "$TAP/minecart.rb" | grep -q "^ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37 " &&
    brew trust --formula amberframework/amber_cli/amber_cli amberframework/amber_cli/minecart &&
    brew fetch --build-from-source amberframework/amber_cli/amber_cli amberframework/amber_cli/minecart &&
    { [ -z "$had_link_v2" ] || brew unlink amber-v2; } &&
    { [ -z "$had_link_sa" ] || brew unlink shards-alpha; } &&
    { [ -z "$had_link_amber" ] || brew unlink amber; } &&
    brew install --build-from-source amberframework/amber_cli/amber_cli &&
    check_amber_cli &&
    brew uninstall amber-v2 ||
    { echo "Migration stopped; run: rollback_amber_v2"; false; }
fi
```

If it stops, run `rollback_amber_v2` in the same terminal. The two formulae stay
trusted after a successful migration, because Homebrew must load them to upgrade.
Remove a still-unlinked `shards-alpha` or legacy `amber` with `brew uninstall` once
you no longer need it.
