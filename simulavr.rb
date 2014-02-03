require 'formula'

class Simulavr < Formula
  homepage 'http://savannah.nongnu.org/projects/simulavr/'
  url 'http://download.savannah.gnu.org/releases/simulavr/simulavr-1.0.0.tar.gz'
  sha1 'e7cacc74be974793bd9c18330ec8d128fbd17d42'
  head 'https://github.com/jpommerening/simulavr.git'

  depends_on 'jpommerening/avr/avr-binutils'
  depends_on 'jpommerening/avr/avr-libc'
  depends_on 'jpommerening/avr/swig-1.3'

  if build.head?
    depends_on 'autoconf'
  end

  def patches
    patchdir = path.realpath.dirname.to_s

    unless build.head?
      [ patchdir + '/patches/simulavr-1.0.0-resize.patch' ]
    else
      [ patchdir + '/patches/simulavr-HEAD-glibtool.patch' ]
    end
  end

  def install
    multios = `gcc --print-multi-os-directory`.chomp
    osrelease = `/usr/sbin/sysctl -n kern.osrelease`.chomp
    binutils = Formula.factory('jpommerening/avr/avr-binutils')

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
