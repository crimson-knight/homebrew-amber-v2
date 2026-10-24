class AmberV2 < Formula
  desc "Amber Framework V2 CLI - Web application framework for Crystal"
  homepage "https://amberframework.org"
  license "MIT"
  head "https://github.com/amberframework/amber_cli.git", branch: "main"

  # Retired: amberframework/amber_cli/amber_cli installs the tagged V2 release tarball,
  # verified by sha256, and resolves its shards with `minecart install --frozen`.
  disable! date:                "2026-10-24",
           because:             "is replaced by the sha256-pinned amber_cli release formula",
           replacement_formula: "amberframework/amber_cli/amber_cli"

  depends_on "crystal"
  depends_on "libpq"
  depends_on "libyaml"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "sqlite"

  # Conflicts with the original amber formula
  conflicts_with "amber", because: "both install an `amber` binary"

  def install
    # Install shards dependencies (no --production since HEAD doesn't include shard.lock)
    system "shards", "install"

    # Build the CLI
    system "shards", "build", "--release", "--no-debug"

    # Install the binary
    bin.install "bin/amber"
  end

  def caveats
    <<~EOS
      Amber Framework V2 CLI has been installed!

      This is Amber Framework V2 which uses:
        - Grant ORM (replaces Granite)
        - Native Asset Pipeline (no Webpack/npm required)
        - crimson-knight/amber as the framework dependency

      To create a new Amber V2 application:
        amber new my_app

      For more information, visit:
        https://amberframework.org

      Note: This formula conflicts with the original 'amber' formula.
      If you have the original installed, you must uninstall it first:
        brew uninstall amber
    EOS
  end

  test do
    assert_match "amber version", shell_output("#{bin}/amber --version")

    # Test that new command shows help
    assert_match "Generates a new Amber project", shell_output("#{bin}/amber new --help")
  end
end
