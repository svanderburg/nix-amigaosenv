{stdenv, fetchurl, fsuae, uae, lndir, procps, lhasa, bchunk, cdrtools, useUAE ? true}:

rec {
  mkGGDiskImage = import ./diskimage.nix {
    baseDiskImage = /home/sander/amigabaseimage;
    inherit stdenv fetchurl lhasa bchunk cdrtools;
  };
  
  mkDerivation = import ./amigaosenv.nix {
    kickstartROMFile = /home/sander/temp/kickrom/kick.rom;
    amigaDiskImage = mkGGDiskImage;
    inherit stdenv fsuae uae lndir procps useUAE;
  };
}
