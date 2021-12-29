{stdenv, fetchurl, fsuae, uae, lndir, procps, lhasa, bchunk, cdrtools}:

rec {
  mkGGEnabledDiskImage = import ./diskimage.nix {
    inherit stdenv fetchurl lhasa bchunk cdrtools;
  };

  mkDerivation = import ./amigaosenv.nix {
    inherit mkGGEnabledDiskImage;
    inherit stdenv fsuae uae lndir procps;
  };
}
