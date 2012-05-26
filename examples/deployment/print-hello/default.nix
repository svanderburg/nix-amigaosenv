{amigaosenv, hello}:

amigaosenv.mkDerivation {
  name = "print-hello";
  buildInputs = [ hello ];
  buildCommand = ''
    hello > /OUT/hello.txt
    [ "`grep "Hello, world" /OUT/hello.txt`" != "" ]
  '';
}
