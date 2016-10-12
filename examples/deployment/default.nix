{ nixpkgs ? <nixpkgs>
, system ? builtins.currentSystem
, useUAE ? true
}:

let
  pkgs = import nixpkgs { inherit system; };
  
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xorg // self);
  
  self = {
    amigaosenv = callPackage ../../amigaosenv {
      inherit useUAE;
    };
    
    hello = callPackage ./hello { };
    
    print_hello = callPackage ./print-hello { };
    
    hello_intuition = callPackage ./hello-intuition { };
    
    wavepak = callPackage ./wavepak { };
  };
in
self
