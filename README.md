# Amber Framework V2 CLI - Homebrew Tap (retired)

The `amber-v2` formula is retired. `brew install crimson-knight/amber-v2/amber-v2`
stops with a message that names the replacement, `amberframework/amber_cli/amber_cli`.

The replacement builds the tagged Amber CLI v2.0.7 release tarball, sha256
`6e90f3cdba3ed87cefbf7443ab93da627af314fac5960a4b9288ae80e31f591f`, installs
`amber` and `amber-lsp`, and depends on Minecart 2025.11.25.8, sha256
`15c7c0af5f29dbd5d651fbfe90bfe1c0cd614a5e72a55ccacc2c246c6e1ed38f`. Install it
with the steps in the
[Amber CLI tap](https://github.com/amberframework/homebrew-amber_cli#install).

## Moving an existing install

1. `brew unlink amber-v2`, so the replacement can link its own `amber`. Keep the
   `amber-v2` keg installed for now.
2. Install `amberframework/amber_cli/amber_cli` as that tap describes. Homebrew
   names any other installed formula that conflicts with it (`shards-alpha`,
   legacy `amber`); unlink that formula the same way and run the install again.
3. Check the replacement: `amber --version` prints `Amber CLI v2.0.7` and
   `minecart --version` prints `Minecart 2025.11.25.8 (2026-10-06)`.
4. Only then remove the old keg: `brew uninstall amber-v2`.

If step 2 or 3 fails, `brew link amber-v2` puts the previous `amber` back while
you sort it out.
