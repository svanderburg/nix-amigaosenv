{stdenv, fetchurl, lhasa, bchunk, cdrtools}:
{baseDiskImage}:

# Important source of instructions: http://aminet.net/dev/gg/0README-GG.txt

let
  urls = {
    GG-misc = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/GG-misc-bin.tgz;
      sha256 = "1jlrsk3ws18p389ndq2m2i2z60v6wps1xanb5j82h8ir8lslrvlw";
    };
    binutils = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/binutils-2.9.1-bin.tgz;
      sha256 = "1q24sd5j9g2c80vkdrmdjh7qbkafsyhdhpl57wbs9d1i2r9x0qzv";
    };
    bison = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/bison-1.27-bin.tgz;
      sha256 = "0w0vrmwbdsj9087da3fmh07bb4cg58c43yr4gvfi2hxxwc1pfz3r";
    };
    diffutils = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/diffutils-2.7-bin.tgz;
      sha256 = "1g5nz0hl5c0ajy8w5bgy5z8hk9jv0i5rfhfsljbq3v1mnjjc6skq";
    };
    fd2inline = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/fd2inline-1.11-bin.tgz;
      sha256 = "14hbb4dygcfhm6dlzpm70wbd95pgijhx9ljpa9y3l7d8qx065klj";
    };
    fifolib = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/fifolib-38.4-bin.tgz;
      sha256 = "01b6khg14nac0mk6jzs83f8dcqz8a6ncz43j5l7kzbf2n5564065";
    };
    fileutils = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/fileutils-4.0-bin.tgz;
      sha256 = "0jk65rynraa87m8nlfa7nryc8jq8hhb7xsmy24z1hvx5l05alz54";
    };
    findutils = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/findutils-4.1-bin.tgz;
      sha256 = "02p7ckfl5hd2mk6zmjhwsdrq7n3wq4gjil4r5lgbrxfsq23cwhm0";
    };
    flex = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/flex-2.5.4a-bin.tgz;
      sha256 = "15cns5sk9dna5qrghl8m906s1cj99a5s54ia4npwdmfcqrgs1lpr";
    };
    gcc = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/egcs-1.1.2-bin.tgz;
      sha256 = "1q0y2ik6xfvvwmb1a78xalfjac698kdiin5vw0isg287lsvibf43";
    };
    grep = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/grep-2.2-bin.tgz;
      sha256 = "1xhnnwlvb2ckrkj5xq98fp3spkdzf4f0qpr37n1ijfx2dn1bn99d";
    };
    gzip = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/gzip-1.2.4-bin.tgz;
      sha256 = "08v0fbivj5wgn1g4rfhxdairgvz6kp1nclwxb1qa2a9sg3mmbk1w";
    };
    ixemul = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/ixemul-48.0-bin.tgz;
      sha256 = "0bq6k1zvrhb6893ijrbhn2bx4a6r5b285wv07p5xdps6p4rx7gi5";
    };
    ixemul-env = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/ixemul-48.0-env-bin.tgz;
      sha256 = "1s17083am628asi7m8ylix1z0i8vrnrn3y3q0qjid5zx5z3jzdf0";
    };
    ixemul-inc = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/ixemul-48.0-inc-bin.tgz;
      sha256 = "1g2z3x7y651r0j1r7b3i0r7lk4ciqdangc9izpggpz788ggwzwid";
    };
    libamiga = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/libamiga-bin.tgz;
      sha256 = "0w8mz63mqac3nf5ci2lkxd9q56f7ppv9b6zyx78rnrwgyp7nji4d";
    };
    libm = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/libm-5.4-bin.tgz;
      sha256 = "06ssfghm1hbb1mnzr80wy5dppykcz40cf9q5ly1ix5d5cpdss5nx";
    };
    libnix = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/libnix-1.2-bin.tgz;
      sha256 = "1sd4kdknc8wc60aipmxbzrh2i053nkvbk51xgp9m3k9cmb8ybaaw";
    };
    make = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/make-3.77-bin.tgz;
      sha256 = "1dmbd25vmhk46yzs0k94ynrafyqz2acvvk5d7b4i5hyrmjp0g8ay";
    };
    patch = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/patch-2.5-bin.tgz;
      sha256 = "0pwck6wr14a8g1czs23i40qi615bnavga3ck7aavg688am6n8bj5";
    };
    pdksh = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/pdksh-5.2.12-bin.tgz;
      sha256 = "132r7daf7cl5bv72i52map459l2bk80m9rza2dvw1nsw9zjci0p2";
    };
    sed = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/sed-3.02-bin.tgz;
      sha256 = "0pa20z0z7fc3n1k4wdcfis2kq9a8z8kdxj6zx2fr5fxk0h52dwwq";
    };
    sh-utils = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/sh-utils-1.16-bin.tgz;
      sha256 = "0xhql6qjcrrv58ranjc4z45zix5mr3iihc22zqcvd38zdsj28kcv";
    };
    tar = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/tar-1.12-bin.tgz;
      sha256 = "1ap9zaj5s018kl2vf0kscx64sy99mnw1jzn1qygn7mp0kpqibgqy";
    };
    termcap = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/termcap-1.3-bin.tgz;
      sha256 = "1acn0pjabm3bwihy6inl92yr9vdb1zdx4brx57vp11fvg60xl96r";
    };
    textutils = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/textutils-1.22-bin.tgz;
      sha256 = "0fnfmcz6cd3y5krjxlhhap5r5fr9xh4f94yfibs6pjad3d2cxprs";
    };
    gawk = fetchurl {
      url = ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/gawk-3.0.3-bin.tgz;
      sha256 = "0hmy79rnix74043w4npljfsi8mcdvkp7nawz1532ag4jm9ajkrym";
    };
    lha = fetchurl {
      url = http://aminet.net/util/arc/lha.run;
      sha256 = "08d639pjq9kxas1b3m6x9fvahs7pvhhykzgilrzysgncs6qxsj6s";
    };
    geekgadgetsBin = fetchurl {
      url = https://archive.org/download/cdrom-geek-gadgets-1/ADE-1.bin;
      sha256 = "1j77l0n76gwpmlmwq03nf9wgkbwrg88kdqk47vzyn5vm828zhbir";
    };
    geekgadgetsCue = fetchurl {
      url = https://archive.org/download/cdrom-geek-gadgets-1/ADE-1.cue;
      sha256 = "1crk8ygiccxxxzyc2cf5xdimk9mdsbic65zb8aj6jniin4mihgmr";
    };
  };
in
stdenv.mkDerivation {
  name = "amigaos-disk-image";
  
  buildInputs = [ lhasa bchunk cdrtools ];
  
  buildCommand = ''
    # Extract lha executable for AmigaOS
    lha x ${urls.lha}
    
    mkdir -p $out
    cd $out
    
    # Copy files from the base image
    cp -rv ${baseDiskImage}/* .
    chmod u+w *
    
    # Install lha for AmigaOS
    mv $TMPDIR/lha_68k C/lha
    chmod 755 C/lha
    
    # Extract Geek Gadget packages
    mkdir -p GG
    cd GG
    
    tar xfv ${urls.GG-misc}
    tar xfv ${urls.binutils}
    tar xfv ${urls.bison}
    tar xfv ${urls.diffutils}
    tar xfv ${urls.fd2inline}
    tar xfv ${urls.fifolib}
    tar xfv ${urls.fileutils}
    tar xfv ${urls.findutils}
    tar xfv ${urls.flex}
    tar xfv ${urls.gcc}
    tar xfv ${urls.grep}
    tar xfv ${urls.gzip}
    tar xfv ${urls.ixemul}
    tar xfv ${urls.ixemul-env}
    tar xfv ${urls.ixemul-inc}
    tar xfv ${urls.libamiga}
    tar xfv ${urls.libm}
    tar xfv ${urls.libnix}
    tar xfv ${urls.make}
    tar xfv ${urls.patch}
    tar xfv ${urls.pdksh}
    tar xfv ${urls.sed}
    tar xfv ${urls.sh-utils}
    tar xfv ${urls.tar}
    tar xfv ${urls.termcap}
    tar xfv ${urls.textutils}
    tar xfv ${urls.gawk} # not mentioned in the README, but it is commonly used
    
    # Fix sh symlink

    cd bin
    rm sh
    ln -s ksh sh
    cd ..
    
    # Create a User-Startup providing the GG: assignment and Geek Gadget settings
    
    cd ..

    cat > S/User-Startup <<EOF
    Assign >NIL: GG: DH0:GG

    Execute GG:Sys/S/GG-Startup
    Stack 200000

    DH0:T
    sh build.sh
    EOF

    # Modify Startup-Sequence, so that it boots in command-line mode instead of the Workbench
    sed -i \
      -e "s|C:LoadWB|; C:LoadWB|" \
      -e "s|EndCLI|; C:EndCLI|" \
      S/Startup-Sequence
    
    # Extract os-include/ directory from the Fred Fish disk image to make it possible to use the AmigaOS APIs
    cd $TMPDIR
    bchunk ${urls.geekgadgetsBin} ${urls.geekgadgetsCue} ADE-1
    isoinfo -i ./ADE-101.iso -X -find -path '/ADE-bin/os-include/*' -print
    find . -type f -name '*;1' | while read i
    do
        mv $i ''${i: :-2}
    done
    
    mv ADE-bin/os-include $out/GG
  '';
}
