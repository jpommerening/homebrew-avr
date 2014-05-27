require 'formula'

class Simulavr < Formula
  homepage 'http://savannah.nongnu.org/projects/simulavr/'
  url 'http://download.savannah.gnu.org/releases/simulavr/simulavr-1.0.0.tar.gz'
  sha1 'e7cacc74be974793bd9c18330ec8d128fbd17d42'
  head 'https://github.com/jpommerening/simulavr.git'

  depends_on 'jpommerening/avr/avr-binutils'
  depends_on 'jpommerening/avr/avr-libc'
  depends_on 'jpommerening/avr/swig-13'

  if build.head?
    depends_on 'autoconf'
  end

  def patches
    patchdir = path.realpath.dirname.to_s

    if build.head?
      [ 'file://' + patchdir + '/patches/simulavr-HEAD-glibtool.patch' ]
    else
      [ 'file://' + patchdir + '/patches/simulavr-1.0.0-resize.patch',
        'file://' + patchdir + '/patches/simulavr-1.0.0_avrgcc4.7.2-darwin.patch' ]
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
