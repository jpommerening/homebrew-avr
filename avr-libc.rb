require 'formula'

class AvrLibc < Formula
  homepage 'http://www.nongnu.org/avr-libc/'
  version '1.8.1'
  url "http://download.savannah.gnu.org/releases/avr-libc/avr-libc-#{version}.tar.bz2"
  sha1 'b56fe21b30341869aa768689b0f6a07d896b17fa'

  depends_on 'avr-gcc'

  def install
    # brew's build environment is in our way
    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'LD'
    ENV.delete 'CC'
    ENV.delete 'CXX'

    avr_gcc = Formula.factory('avr-gcc')
    build = `./config.guess`.chomp
    system "./configure", "--build=#{build}", "--prefix=#{prefix}", "--host=avr"
    system "make install"
    avr = File.join prefix, 'avr'
    # copy include and lib files where avr-gcc searches for them
    # this wouldn't be necessary with a standard prefix
    ohai "copying #{avr} -> #{avr_gcc.prefix}"
    cp_r avr, avr_gcc.prefix
  end
end
