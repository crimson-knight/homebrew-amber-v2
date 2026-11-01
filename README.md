# Amber Framework V2 CLI - Homebrew Tap (retired)

The `amber-v2` formula is retired. `brew install crimson-knight/amber-v2/amber-v2`
stops with a message that names the replacement, `amberframework/amber_cli/amber_cli`.

The replacement builds the tagged Amber CLI v2.0.7 release tarball, sha256
`6e90f3cdba3ed87cefbf7443ab93da627af314fac5960a4b9288ae80e31f591f`, installs
`amber` and `amber-lsp`, and depends on Minecart 2025.11.25.8, sha256
`15c7c0af5f29dbd5d651fbfe90bfe1c0cd614a5e72a55ccacc2c246c6e1ed38f`. These steps use
the Amber CLI tap at commit `add328ed517dfffc6b0b07293b85fe25ae140bdc`, where
`Formula/amber_cli.rb` has sha256
`e127275857579f8d2b5462fc15b76097fdf05d7a9ef940c378ba3a32def6dd08` and
`Formula/minecart.rb` has sha256
`ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37`.

## Moving an existing install

1. `brew unlink crimson-knight/amber-v2/amber-v2`, so the replacement can link its
   own `amber`. Keep the `amber-v2` keg installed for now.
2. Tap, pin and verify the reviewed formulas, then install. Paste the block as one
   command: each step runs only if the one before it succeeded, so a hash mismatch
   stops it before `brew install`.
   ```sh
   T="$(brew tap amberframework/amber_cli >/dev/null && brew --repo amberframework/amber_cli)" &&
   git -C "$T" checkout --detach add328ed517dfffc6b0b07293b85fe25ae140bdc &&
   printf "%s  %s\n" e127275857579f8d2b5462fc15b76097fdf05d7a9ef940c378ba3a32def6dd08 "$T/Formula/amber_cli.rb" ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37 "$T/Formula/minecart.rb" | shasum -a 256 -c - &&
   HOMEBREW_NO_AUTO_UPDATE=1 brew install amberframework/amber_cli/amber_cli
   ```
   Homebrew names any other installed formula that conflicts with it
   (`shards-alpha`, legacy `amber`); unlink that formula the same way and run the
   block again.
3. Check the replacement: `type -a amber` lists the `amber_cli` keg path first,
   `amber --version` prints `Amber CLI v2.0.7`, and `minecart --version` prints
   `Minecart 2025.11.25.8 (2026-10-06)`.
4. Only then remove the old keg: `brew uninstall crimson-knight/amber-v2/amber-v2`.

If step 2 or 3 fails, put the previous `amber` back while you sort it out:
`brew unlink amberframework/amber_cli/amber_cli` (when it is linked), then
`brew link crimson-knight/amber-v2/amber-v2`. If Homebrew asks you to trust the
tap first, run `brew trust --formula crimson-knight/amber-v2/amber-v2` and link
again. Afterward, `git -C "$(brew --repo amberframework/amber_cli)" checkout main`
returns the Amber CLI tap to its normal branch.
