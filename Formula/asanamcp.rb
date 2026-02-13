class Asanamcp < Formula
  desc "MCP server for Asana API"
  homepage "https://github.com/adlio/asanamcp"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adlio/asanamcp/releases/download/v0.3.2/asanamcp-aarch64-apple-darwin.tar.xz"
      sha256 "acd665ed0cec1e062084fd16bbcfb6ffab656e0cbe408d0056f42218b500ac46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adlio/asanamcp/releases/download/v0.3.2/asanamcp-x86_64-apple-darwin.tar.xz"
      sha256 "9d7995f3da5c80afef85fd654b5940ee95975ec04125947a2709e9f5f922aa0d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adlio/asanamcp/releases/download/v0.3.2/asanamcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9524e193e87acb86c710c819028a41b4bda72a272c779c3f2c1d0a96f86b369c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adlio/asanamcp/releases/download/v0.3.2/asanamcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f7f2322cf2768bfe4049d3e57345070f01e149a5290cc1ec7144b9d2893d36b8"
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
