{amigaosenv, hello, kickstartROMFile, baseDiskImage, useUAE}:

amigaosenv.mkDerivation {
  name = "print-hello";
  buildInputs = [ hello ];
  buildCommand = ''
    hello > /OUT/hello.txt
    [ "`grep "Hello, world" /OUT/hello.txt`" != "" ]
  '';
  inherit kickstartROMFile baseDiskImage useUAE;
}
