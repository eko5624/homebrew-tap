class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/c9/8d/5701194ffbfecc8af3e0f0af31febc6414e48c0f118958eabfa9ce800abb/yt-dlp-2023.1.2.tar.gz"
  sha256 "b8d7bbb5c1595f718855a31f34d8a0276a7086f5d3f542c021a8ded8b26d36ae"
  license "Unlicense"

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
  end

  depends_on "python@3.11"
  depends_on "aria2" => :recommended

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/b1/54/d1760a363d0fe345528e37782f6c18123b0e99e8ea755022fd51f1ecd0f9/mutagen-1.46.0.tar.gz"
    sha256 "6e5f8ba84836b99fe60be5fb27f84be4ad919bbb6b49caa6ae81e70584b55e58"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/5d/22/575c7dd7c86843e07a791cfa2143e7292d6b380f5a7cce966a49b9d6c9f4/pycryptodomex-3.16.0.tar.gz"
    sha256 "e9ba9d8ed638733c9e95664470b71d624a6def149e2db6cc52c1aca5a6a2df1d"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/85/dc/549a807a53c13fd4a8dac286f117a7a71260defea9ec0c05d6027f2ae273/websockets-10.4.tar.gz"
    sha256 "eef610b23933c54d5d921c92578ae5f89813438fded840c2e9809d378dc765d3"
  end

  def install
    ENV.append "PYTHONOPTIMIZE", 1
    if build.head?
      python3 = "python3.11"
      system python3, "devscripts/update-version.py"
      system python3, "devscripts/make_lazy_extractors.py"
      system "make", "lazy-extractors", "yt-dlp", "completions"
    end
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/yt-dlp.1"
    bash_completion.install "completions/bash/yt-dlp"
    fish_completion.install "completions/fish/yt-dlp.fish"
    zsh_completion.install "completions/zsh/_yt-dlp"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
