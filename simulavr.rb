require 'formula'

class Simulavr < Formula
  homepage 'http://www.nongnu.org/simulavr/'
  version '1.0.0'
  url "http://download.savannah.gnu.org/releases/simulavr/simulavr-#{version}.tar.gz"
  head 'https://github.com/jpommerening/simulavr.git'
  sha1 'e7cacc74be974793bd9c18330ec8d128fbd17d42'

  depends_on 'avr-binutils'
  depends_on 'avr-libc'

  if build.head?
    depends_on 'libtool'
    depends_on 'autoconf'
    depends_on 'automake'
    depends_on 'swig'
  else
    depends_on 'swig-13'
  end

  def patches
    patchdir = path.realpath.dirname.to_s

    if build.head?
      [ 'file://' + patchdir + '/patches/simulavr-HEAD-gtest.patch' ]
    else
      [ 'file://' + patchdir + '/patches/simulavr-1.0.0-resize.patch',
        'file://' + patchdir + '/patches/simulavr-1.0.0-avrgcc4.9.2-darwin.patch' ]
    end
  end

  def install
    multios = `gcc --print-multi-os-directory`.chomp
    osrelease = `/usr/sbin/sysctl -n kern.osrelease`.chomp
    binutils = Formula.factory('avr-binutils')

    if build.head?
      system "./bootstrap"
    end

    system "./configure", "--with-bfd=#{binutils.opt_prefix}/#{multios}-apple-darwin#{osrelease}/avr",
                          "--with-libiberty=#{binutils.opt_prefix}/lib/#{multios}",
                          "--prefix=#{prefix}",
                          "LDFLAGS=-lz"
    system "make"
    system "make install"
  end
end
