{amigaosenv, fetchurl}:

amigaosenv.mkDerivation {
  name = "hello-2.1.1";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/hello/hello-2.1.1.tar.gz;
    sha256 = "1md7jsfd8pa45z73bz1kszpp01yw6x5ljkjk2hx7wl800any6465";
  };
  buildCommand = ''
    tar xfvz $src
    cd hello-2.1.1
    ./configure --prefix=/OUT
    make || true # Ignoring missing perl2man is ok
    make install || true
  '';
}
