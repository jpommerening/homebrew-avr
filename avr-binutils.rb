require 'formula'

class AvrBinutils < Formula
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.23.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gun/binutils/binutils-2.23.1.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  sha1 '587fca86f6c85949576f4536a90a3c76ffc1a3e1'

  def install

    if MacOS.version == :lion
      ENV['CC'] = ENV.cc
    end

    ENV['CPPFLAGS'] = "-I#{include}"

    args = ["--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--disable-nls",
            "--target=avr",
            "--enable-install-libbfd"]

    # brew's build environment is in our way
    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'LD'
    ENV.delete 'CC'
    ENV.delete 'CXX'

    if MacOS.version == :lion
      ENV['CC'] = ENV.cc
    end

    system "./configure", *args

    system "make"
    system "make install"
  end

  def patches
    patchdir = path.realpath.dirname.to_s

    # Support for -C in avr-size. See issue 
    # https://github.com/larsimmisch/homebrew-avr/issues/9
    [ 'file://' + patchdir + '/patches/avr-binutils-size.patch' ]
  end

end
