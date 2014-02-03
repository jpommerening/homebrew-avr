require 'formula'

class AvrGdb < Formula
  homepage 'http://www.gnu.org/software/gdb/'
  url 'ftp://ftp.gnu.org/gnu/gdb/gdb-7.6.1.tar.gz'
  sha1 '13beaab7d28f8591777c9271f0c20a22c70d6252'

  depends_on 'jpommerening/avr/avr-binutils'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--target=avr",
                          "--program-prefix=avr-"
    system "make"
    system "make install"
  end
end
