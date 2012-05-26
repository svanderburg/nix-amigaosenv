{stdenv, uae, lndir, procps}:

{
  mkDerivation = import ./amigaosenv.nix {
    kickstartROMFile = /home/sander/temp/kickrom/kick.rom;
    amigaDiskImage = /home/sander/image;
    inherit stdenv uae lndir procps;
  };
}
