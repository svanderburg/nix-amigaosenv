{stdenv, fsuae, uae, lndir, procps, useUAE ? true}:

{
  mkDerivation = import ./amigaosenv.nix {
    kickstartROMFile = /home/sander/temp/kickrom/kick.rom;
    amigaDiskImage = /home/sander/amigabase;
    inherit stdenv fsuae uae lndir procps useUAE;
  };
}
