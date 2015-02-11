require 'formula'

class AvrGdb < Formula
  homepage 'http://www.gnu.org/software/gdb/'
  version '7.8.1'
  url "http://ftp.gnu.org/gnu/gdb/gdb-#{version}.tar.gz"
  mirror "http://ftpmirror.gnu.org/gnu/gdb/gdb-#{version}.tar.gz"
  sha1 '36a9c4d365bf937f80eec13451bc6cc5eb94e562'

  depends_on 'avr-binutils'

  def install
    args = ["--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--disable-nls",
            "--target=avr",
            "--disable-install-libbfd",
            "--disable-install-libiberty"]

    system "./configure", *args

    system "make"
    system "make install"

    File.unlink "#{prefix}/share/info/bfd.info",
                "#{prefix}/share/info/configure.info",
                "#{prefix}/share/info/standards.info"
  end
end
