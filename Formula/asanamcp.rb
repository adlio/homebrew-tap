class Asanamcp < Formula
  desc "MCP server for Asana API"
  homepage "https://github.com/adlio/asanamcp"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adlio/asanamcp/releases/download/v0.3.1/asanamcp-aarch64-apple-darwin.tar.xz"
      sha256 "78a22b2a91c38dc581633100efb4a703d7b138271a1fb3bf3a281f29dc241ba2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adlio/asanamcp/releases/download/v0.3.1/asanamcp-x86_64-apple-darwin.tar.xz"
      sha256 "17446c554b9dca2dff4c859ed62b35abc21b258a9257e2e5842f57dae54a48ce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adlio/asanamcp/releases/download/v0.3.1/asanamcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "79600e0580a06a6a381ee8b58e2d7cf36e8e2f1204062cae346d89f7f042c68e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adlio/asanamcp/releases/download/v0.3.1/asanamcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "530a2bb568ea11aa0b73db376ea8a86d7a215219eb7e3c77054eefa4c47dbf39"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "asanamcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "asanamcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "asanamcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "asanamcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
