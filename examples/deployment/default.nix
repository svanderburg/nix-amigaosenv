{ nixpkgs ? <nixpkgs>
, system ? builtins.currentSystem
, useUAE ? true
, kickstartROMFile
, baseDiskImage
}:

let
  pkgs = import nixpkgs { inherit system; };
  
  emulatorSettings = {
    inherit kickstartROMFile baseDiskImage useUAE;
  };
  
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xorg // self // emulatorSettings);
  
  self = {
    amigaosenv = callPackage ../../amigaosenv { };
    
    hello = callPackage ./hello { };
    
    print_hello = callPackage ./print-hello { };
    
    hello_intuition = callPackage ./hello-intuition { };
    
    wavepak = callPackage ./wavepak { };
  };
in
self
