class AmberV2 < Formula
  desc "Amber Framework V2 CLI (retired; use amberframework/amber_cli/amber_cli)"
  homepage "https://amberframework.org"
  # The stable release lets Homebrew reach the disable! message below; head-only
  # formulae stop at "HEAD-only" before it.
  url "https://github.com/amberframework/amber_cli/releases/download/v2.0.7/amber_cli-source-2.0.7.tar.gz"
  sha256 "6e90f3cdba3ed87cefbf7443ab93da627af314fac5960a4b9288ae80e31f591f"
  license "MIT"

  # Retired: amberframework/amber_cli/amber_cli installs this same tagged V2 release,
  # verified by sha256, and resolves its shards with `minecart install --frozen`.
  disable! date:                "2026-10-24",
           because:             "is replaced by the sha256-pinned amber_cli release formula",
           replacement_formula: "amberframework/amber_cli/amber_cli"

  def install
    odie "amber-v2 is retired; install amberframework/amber_cli/amber_cli"
  end
end
