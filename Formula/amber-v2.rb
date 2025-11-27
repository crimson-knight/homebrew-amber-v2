class AmberV2 < Formula
  desc "Amber Framework V2 CLI - Web application framework for Crystal"
  homepage "https://amberframework.org"
  license "MIT"
  head "https://github.com/amberframework/amber_cli.git", branch: "main"

  # Uncomment and update when a release version is available:
  # url "https://github.com/crimson-knight/amber_cli/archive/refs/tags/v2.0.0.tar.gz"
  # sha256 "UPDATE_WITH_ACTUAL_SHA256_HASH"
  # version "2.0.0"

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
