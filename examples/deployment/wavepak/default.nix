{amigaosenv, fetchurl, kickstartROMFile, baseDiskImage, useUAE}:

amigaosenv.mkDerivation {
  name = "wavepak";
  src = fetchurl {
    url = http://aminet.net/mus/misc/wavepak.lha;
    sha256 = "1441c7h042wac5h8aw6n5hj30yai3k9mdis0a2dp77kp8sqnf2dx";
  };
  buildCommand = ''
    /C/lha x $src
    cd wavepak
    rm -f wavepak # Let's remove the prebuilt binary
    gcc -noixemul -o wavepak wavepak.c
    mkdir /OUT/bin
    cp wavepak /OUT/bin
  '';
  inherit kickstartROMFile baseDiskImage useUAE;
}
