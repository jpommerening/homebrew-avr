require 'formula'

class Swig13 < Formula
  homepage 'http://www.swig.org/'
  version '1.3.40'
  url "http://sourceforge.net/projects/swig/files/swig/swig-#{version}/swig-#{version}.tar.gz"
  sha1 '7e7a426579f2d2d967b731abf062b33aa894fb4e'

  option :universal

  depends_on 'pcre'
  depends_on :python  # assure swig find the "right" python

  keg_only "This thing is older than your grandma."

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
