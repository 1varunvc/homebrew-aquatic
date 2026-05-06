class Aquatic < Formula
  desc "Modular macOS CLI toolkit for video processing, Git tagging, and data parsing"
  homepage "https://github.com/1varunvc/aquatic"
  url "https://github.com/1varunvc/aquatic/releases/download/v0.1.1/aquatic-0.1.1.tar.gz"
  sha256 "1200409fabd08188ef8341db3414f64ceea67d719d4d9a685a497f9116fe57b0"
  license "GPL-3.0-or-later"
  version "0.1.1"

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
    (libexec/"lib").install Dir["scripts/lib/*.sh"]
    (libexec/"dev").install Dir["scripts/dev/*.js"]

    libexec.install "VERSION"
    libexec.install "RELEASES.md"

    inreplace bin/"aquatic", 'SCRIPT_DIR="$DIR/scripts"', "SCRIPT_DIR=\"#{libexec}\""
    inreplace bin/"aquatic", 'DEV_DIR="$DIR/scripts/dev"', "DEV_DIR=\"#{libexec}/dev\""
    inreplace bin/"aquatic",
      'CURRENT_VERSION=$(cat "$DIR/VERSION")',
      "CURRENT_VERSION=$(cat \"#{libexec}/VERSION\")"
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

