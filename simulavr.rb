require 'formula'

class Simulavr < Formula
  homepage 'http://savannah.nongnu.org/projects/simulavr/'
  url 'http://github.com/Traumflug/simulavr/tarball/c93f23872c85444b9bd0657755b9c674d180ae69'
  sha1 '7757d5d3656c6260d3db48345cb7ebeade7e52ae'

  depends_on 'avr-binutils'
  depends_on 'swig-1.3'

  def patches
    patchdir = path.realpath.dirname.to_s
    []
  end

  def install
    multios = `gcc --print-multi-os-dir`.chomp

    system "./configure", "--with-bfd=#{Formula.factory('avr-binutils').opt_prefix}",
                          "--with-libiberty=#{Formula.factory('avr-binutils').opt_prefix}/lib/#{multios}",
                          "--prefix=#{prefix}",
                          "LDFLAGS=-lz"
    system "make"
    system "make install"
  end
end
