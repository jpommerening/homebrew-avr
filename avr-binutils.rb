require 'formula'

class AvrBinutils < Formula
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  version '2.24'
  url "http://ftp.gnu.org/gnu/binutils/binutils-#{version}.tar.bz2"
  mirror "http://ftpmirror.gnu.org/binutils/binutils-#{version}.tar.bz2"
  sha1 '7ac75404ddb3c4910c7594b51ddfc76d4693debb'

  def patches
    patchdir = path.realpath.dirname.to_s

    [ 'file://' + patchdir + '/patches/binutils-2.24-install-libiberty.patch' ]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--disable-nls",
            "--target=avr",
            "--enable-install-libbfd",
            "--enable-install-libiberty"]

    # brew's build environment is in our way
    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'LD'
    ENV.delete 'CC'
    ENV.delete 'CXX'

    ENV['CPPFLAGS'] = "-I#{include}"

    system "./configure", *args

    system "make"
    system "make install"
  end
end
