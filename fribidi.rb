class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/archive/v1.0.9.tar.gz"
  sha256 "ef6f940d04213a0fb91a0177b2b57df2031bf3a7e2cd0ee2c6877a160fc206df"

  head do
    url "https://github.com/fribidi/fribidi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  def install
    ENV.append "CXXFLAGS", "-Ofast -flto -march=native -mtune=native"
    ENV.append "CFLAGS",   "-Ofast -flto -march=native -mtune=native"
    ENV.append "LDFLAGS",  "-Ofast -flto -march=native -mtune=native"

    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match /a simple TSet that/, shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
