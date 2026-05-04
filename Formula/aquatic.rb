class Aquatic < Formula
  desc "Modular macOS CLI toolkit for video processing, Git tagging, and data parsing"
  homepage "https://github.com/1varunvc/aquatic"
  url "https://github.com/1varunvc/aquatic/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2b1f51b1b62a196bbe31c5dddaea6c8667c3711d3ba2e2f170f2b6cdf37536c6"
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

  def caveats
    <<~EOS
      The 'slideshow' command requires ffmpeg built with libfreetype (drawtext filter).
      The default Homebrew ffmpeg does not include this. To fix:
        brew uninstall ffmpeg
        brew install homebrew-ffmpeg/ffmpeg/ffmpeg
    EOS
  end

  test do
    assert_match "aquatic #{version}", shell_output("#{bin}/aquatic --version")
  end
end

