require 'formula'

class AvrGdb < Formula
  homepage 'http://www.gnu.org/software/gdb/'
  version '7.8.1'
  url "http://ftp.gnu.org/gnu/gdb/gdb-#{version}.tar.gz"
  mirror "http://ftpmirror.gnu.org/gnu/gdb/gdb-#{version}.tar.gz"
  sha1 '4810d78a77064fefc05e701fc0a2193562a23afe'

  depends_on "#{tap}/avr-binutils"

  def install
    multios = `gcc --print-multi-os-directory`.chomp

    system "./configure", "--prefix=#{prefix}",
                          "--target=avr",
                          "--program-prefix=avr-"
    system "make"
    system "make install"

    # binutils already has a libiberty.a. We remove ours, because
    # otherwise, the symlinking of the keg fails
    File.unlink "#{prefix}/lib/#{multios}/libiberty.a"
  end
end
