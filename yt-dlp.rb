class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://github.com/yt-dlp/yt-dlp/archive/refs/tags/2021.04.03.tar.gz"
  sha256 "757a315b4c6bb10aa9289727e85a49ce303cec3ee066bdb1b96203584051af3d"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git"

  depends_on "python@3.9"
  depends_on "aria2" => :recommended

  def install
    virtualenv_install_with_resources
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
