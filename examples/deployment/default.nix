let pkgs = import <nixpkgs> {};
in
rec {
  amigaosenv = import ../../amigaosenv {
    inherit (pkgs) stdenv uae procps;
    inherit (pkgs.xorg) lndir;
  };
  
  hello = import ./hello {
    inherit amigaosenv;
    inherit (pkgs) fetchurl;
  };
  
  print_hello = import ./print-hello {
    inherit amigaosenv hello;
  };
  
  hello_intuition = import ./hello-intuition {
    inherit amigaosenv;
  };
  
  wavepak = import ./wavepak {
    inherit amigaosenv;
    inherit (pkgs) fetchurl;
  };
}
