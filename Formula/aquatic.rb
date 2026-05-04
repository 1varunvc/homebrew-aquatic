class Aquatic < Formula
  desc "Modular macOS CLI toolkit for video processing, Git tagging, and data parsing"
  homepage "https://github.com/1varunvc/aquatic"
  url "https://github.com/1varunvc/aquatic/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "85e741dcc366761f99d3b7e0fb20fc48b576c56ac194e77a895fdf4b25885ab3"
  license "GPL-3.0-or-later"
  version "0.1.0"

  depends_on :macos
  depends_on "bash"
  depends_on "ffmpeg"
  depends_on "gh"
  depends_on "jq"
  depends_on "node"

  def install
    bin.install "aquatic"

    libexec.install Dir["scripts/*.sh"]
    libexec.install Dir["scripts/*.txt"]
    (libexec/"dev").install Dir["scripts/dev/*.js"]

    libexec.install "VERSION"
    libexec.install "RELEASES.md"

    inreplace bin/"aquatic", 'SCRIPT_DIR="$DIR/scripts"', "SCRIPT_DIR=\"#{libexec}\""
    inreplace bin/"aquatic", 'DEV_DIR="$DIR/scripts/dev"', "DEV_DIR=\"#{libexec}/dev\""
    inreplace bin/"aquatic",
      'CURRENT_VERSION=$(cat "$DIR/VERSION")',
      "CURRENT_VERSION=$(cat \"#{libexec}/VERSION\")"
    inreplace bin/"aquatic",
      'local RELEASES_FILE="$DIR/RELEASES.md"',
      "local RELEASES_FILE=\"#{libexec}/RELEASES.md\""
  end

  test do
    assert_match "aquatic #{version}", shell_output("#{bin}/aquatic --version")
  end
end

