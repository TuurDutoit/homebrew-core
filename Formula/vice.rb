require 'formula'

class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage 'http://vice-emu.sourceforge.net/'
  url 'http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/vice-2.4.tar.gz'
  sha256 'ff8b8d5f0f497d1f8e75b95bbc4204993a789284a08a8a59ba727ad81dcace10'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'giflib' => :optional
  depends_on 'lame' => :optional

  fails_with :llvm do
    build 2335
  end

  def install
    # Use Cocoa instead of X
    # Use a static lame, otherwise Vice is hard-coded to look in
    # /opt for the library.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cocoa",
                          "--without-x",
                          "--enable-static-lame",
                          # VICE can't compile against FFMPEG newer than 0.11:
                          # http://sourceforge.net/tracker/?func=detail&aid=3585471&group_id=223021&atid=1057617
                          "--disable-ffmpeg"
    system "make"
    system "make bindist"
    prefix.install Dir['vice-macosx-*/*']
    bin.install_symlink Dir[prefix/'tools/*']
  end

  def caveats
    "Cocoa apps for these emulators have been installed to #{prefix}."
  end
end
