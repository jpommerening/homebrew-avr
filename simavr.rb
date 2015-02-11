require 'formula'

class Simavr < Formula
  homepage 'https://github.com/buserror/simavr'
  version '1.2'
  url 'https://github.com/buserror/simavr/archive/v#{version}.tar.gz'
  sha1 'df40e36767fbac3deb9c0ccd08ef364da3dd0023'
  head 'https://github.com/buserror/simavr.git'

  depends_on 'avr-binutils'
  depends_on 'avr-libc'
  depends_on 'libelf' => :build

  def patches
    patchdir = path.realpath.dirname.to_s

    unless build.head?
      # avr-libc renamed the macro FUSE_HFUSE_DEFAULT to HFUSE_DEFAULT, meaning
      # that v1.2 needs to be patched.
      # see https://lists.nongnu.org/archive/html/avr-libc-commit/2014-04/msg00000.html
      [ 'file://' + patchdir + '/patches/simavr-v1.2-hfuse.patch' ]
    end
  end

  def install
    avr_libc = Formula.factory('avr-libc')
    avr_binutils = Formula.factory('avr-binutils')

    # install to our own prefix
    ENV["DESTDIR"] = prefix

    # tell make to prefer ENV over it's own definition of variables
    ENV["MAKE"] = "make -e"

    # homebrew puts libelf.h into it's own subdir, so we need to pass this subdir
    # to the makefile.
    ENV["CFLAGS"]  = "-O2 -Wall -g -I/usr/local/include/libelf -I/usr/include"

    # this tells the make script about where the AVR toolchain is
    ENV["AVR_ROOT"]= avr_libc.prefix
    ENV["AVR_INC"] = "#{avr_libc.prefix}/avr"
    ENV["AVR"]     = "#{avr_binutils.prefix}/bin/avr-"

    # compile
    system "make", "-e", "build-simavr"

    # install to prefix
    system "make", "-e", "install"
  end
end
