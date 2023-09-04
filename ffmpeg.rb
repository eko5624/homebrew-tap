class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-6.0.tar.xz"
  sha256 "57be87c22d9b49c112b6d24bc67d42508660e6b718b3db89c44e47e289137082"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  head "https://github.com/FFmpeg/FFmpeg.git", branch: "master"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  option "with-librsvg", "Enable SVG files as inputs via librsvg"
  option "with-libssh", "Enable SFTP protocol via libssh"
  option "with-libvmaf", "Enable libvmaf scoring library"
  option "with-openh264", "Enable OpenH264 library"
  option "with-rav1e", "Enable Rav1e AV1 encoder library"
  option "with-snappy", "Enable HAP/Snappy library"
  option "with-tesseract", "Enable the tesseract OCR engine"
  option "with-zeromq", "Enable using libzeromq to receive commands sent through a libzeromq client"

  depends_on "pkg-config" => :build

  depends_on "aribb24"
  depends_on "dav1d"
  depends_on "eko5624/tap/aom"
  depends_on "eko5624/tap/jpeg-xl"
  depends_on "eko5624/tap/libass"
  depends_on "eko5624/tap/libmysofa"
  depends_on "eko5624/tap/libplacebo"
  depends_on "fdk-aac"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "lame"
  depends_on "libbluray"
  depends_on "libbs2b"
  depends_on "librist"
  depends_on "libsoxr"
  depends_on "libvidstab"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opencore-amr"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "rubberband"
  depends_on "sdl2"
  depends_on "speex"
  depends_on "srt"
  depends_on "svt-av1"
  depends_on "theora"
  depends_on "webp"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"
  depends_on "xz"
  depends_on "zimg"

  depends_on "game-music-emu" => :optional
  depends_on "libcaca" => :optional
  depends_on "libgsm" => :optional
  depends_on "libmodplug" => :optional
  depends_on "librsvg" => :optional
  depends_on "libssh" => :optional
  depends_on "libvmaf" => :optional      # Avoiding building Rust
  depends_on "openh264" => :optional
  depends_on "rav1e" => :optional        # Avoiding building Rust
  depends_on "snappy" => :optional       # Build issue on macOS 10.13
  depends_on "tesseract" => :optional    # Build issue on macOS <10.15
  depends_on "two-lame" => :optional
  depends_on "zeromq" => :optional       # Avoiding building Boost

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxv"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  fails_with gcc: "5"

  # Fix for QtWebEngine, do not remove
  # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=270209
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/ffmpeg/-/raw/5670ccd86d3b816f49ebc18cab878125eca2f81f/add-av_stream_get_first_dts-for-chromium.patch"
    sha256 "57e26caced5a1382cb639235f9555fc50e45e7bf8333f7c9ae3d49b3241d3f77"
  end

  def install
    args = %W[
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --prefix=#{prefix}

      --enable-gpl
      --enable-nonfree
      --enable-version3

      --enable-opencl
      --enable-pthreads
      --enable-shared

      --enable-frei0r
      --enable-libaom
      --enable-libaribb24
      --enable-libass
      --enable-libbluray
      --enable-libbs2b
      --enable-libdav1d
      --enable-libfdk-aac
      --enable-libfontconfig
      --enable-libfreetype
      --enable-libjxl
      --enable-libmp3lame
      --enable-libmysofa
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-libopenjpeg
      --enable-libopus
      --enable-libplacebo
      --enable-librist
      --enable-librubberband
      --enable-libsoxr
      --enable-libspeex
      --enable-libsrt
      --enable-libsvtav1
      --enable-libtheora
      --enable-libvidstab
      --enable-libvorbis
      --enable-libvpx
      --enable-libwebp
      --enable-libx264
      --enable-libx265
      --enable-libxml2
      --enable-libxvid
      --enable-libzimg
      --enable-lzma
      --enable-openssl

      --disable-htmlpages
      --disable-podpages
      --disable-txtpages

      --disable-libjack
      --disable-indev=jack
    ]

    # Needs corefoundation, coremedia, corevideo
    args += %w[--enable-videotoolbox --enable-audiotoolbox] if OS.mac?
    args << "--enable-neon" if Hardware::CPU.arm?

    args << "--enable-libcaca" if build.with? "libcaca"
    args << "--enable-libgme" if build.with? "game-music-emu"
    args << "--enable-libgsm" if build.with? "libgsm"
    args << "--enable-libmodplug" if build.with? "libmodplug"
    args << "--enable-libopenh264" if build.with? "openh264"
    args << "--enable-librav1e" if build.with? "rav1e"
    args << "--enable-librsvg" if build.with? "librsvg"
    args << "--enable-libsnappy" if build.with? "snappy"
    args << "--enable-libssh" if build.with? "libssh"
    args << "--enable-libtesseract" if build.with? "tesseract"
    args << "--enable-libtwolame" if build.with? "two-lame"
    args << "--enable-libvmaf" if build.with? "libvmaf"
    args << "--enable-libzmq" if build.with? "zeromq"

    # args << "--enable-hardcoded-tables"
    args << "--enable-lto"
    args << "--optflags=-Ofast"

    opts  = Hardware::CPU.arm? ? "-mcpu=native " : "-march=native -mtune=native "
    args << ("--extra-cflags="    + opts)
    args << ("--extra-cxxflags="  + opts)
    args << ("--extra-objcflags=" + opts)
    args << ("--extra-ldflags="   + opts)

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }

    # Fix for Non-executables that were installed to bin/
    mv bin/"python", pkgshare/"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
