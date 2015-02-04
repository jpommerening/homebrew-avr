require 'formula'

# print avr-gcc's builtin include paths
# `avr-gcc -print-prog-name=cc1plus` -v

class AvrGcc < Formula
  homepage 'http://gcc.gnu.org'
  version '4.9.2'
  url "http://ftp.gnu.org/gnu/gcc/gcc-#{version}/gcc-#{version}.tar.bz2"
  mirror "http://ftpmirror.gnu.org/gnu/gcc/gcc-#{version}/gcc-#{version}.tar.bz2"
  sha1 '79dbcb09f44232822460d80b033c962c0237c6d8'

  depends_on 'avr-binutils'
  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'

  def options
    [
     ['--disable-cxx', 'Don\'t build the g++ compiler'],
    ]
  end

  def nocxx?
    ARGV.include? '--disable-cxx'
  end

  def install
    gmp = Formula.factory 'gmp'
    mpfr = Formula.factory 'mpfr'
    libmpc = Formula.factory 'libmpc'

    # brew's build environment is in our way
    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'AS'
    ENV.delete 'LD'
    ENV.delete 'NM'
    ENV.delete 'RANLIB'

    args = [
            "--target=avr",
            "--disable-libssp",
            "--disable-nls",
            "--with-dwarf2",
            # Sandbox everything...
            "--prefix=#{prefix}",
            "--with-gmp=#{gmp.prefix}",
            "--with-mpfr=#{mpfr.prefix}",
            "--with-mpc=#{libmpc.prefix}",
            # ...except the stuff in share...
            "--datarootdir=#{share}",
            # ...and the binaries...
            "--bindir=#{bin}",
            # This shouldn't be necessary
            "--with-as=/usr/local/bin/avr-as",
            "--with-ld=/usr/local/bin/avr-ld"
           ]

    # The C compiler is always built, C++ can be disabled
    languages = %w[c]
    languages << 'c++' unless nocxx?

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system '../configure', "--enable-languages=#{languages.join(',')}", *args
      system 'make'

      # At this point `make check` could be invoked to run the testsuite. The
      # deja-gnu and autogen formulae must be installed in order to do this.

      system 'make install'
    end
  end
end
