Nix AmigaOS environment
=======================
This package contains a function for the
[Nix package manager](http://nixos.org/nix) that automatically builds AmigaOS
software packages using [Geek Gadgets](http://geekgadgets.back2roots.org), a GNU
build tool chain ported to AmigaOS, and an Amiga emulator (either the
["vanilla" UAE](http://amiga.technology) or
[FS-UAE](https://fs-uae.net)).

With this Nix function, one can easily build software for AmigaOS (e.g. for
porting) the same way as ordinary packages are built by using the Nix package
manager for modern platforms such as Linux.

Furthermore, this package includes several example cases demonstrating its use.

Installation
============
In order to use this Nix function, a basic Amiga Workbench installation is
required. Furthermore, we must relax some of Nix purity restrictions.

Installing the Amiga Workbench
------------------------------
To make this function work we require a minimal Amiga Workbench installation.
Unfortunately, this process cannot be automated for two reasons.

First, the Amiga kickstart ROMs and workbench discs cannot be freely
distributed. The legal way to obtain these files is by ordering one of the
[Cloanto's Amiga Forever](http://www.amigaforever.com) discs.

The second reason is that a Workbench installation requires running an
installation wizard.

To make this happen, UAE must be instructed to mount a directory of the host
filesystem as a hard disk device. On this hard disk device, the Amiga Workbench
must be installed. Consult UAE or FS-UAE's documentation for more information.

The Workbench can be installed on the hard drive by simply running its
installation wizard. No special settings are required -- a novice installation
process suffices.

Relaxing Nix's purity restrictions
----------------------------------
To make the Nix builds work, we must "cheat" a bit by breaking Nix's purity
features. First, ensure that the sandboxing setting has been disabled or set to
`relaxed`, by editing the `/etc/nix/nix.conf` file add adding the following
property:

```
build-use-sandbox = relaxed
```

in NixOS, we can relax the sandboxing settings with the following configuration
property:

```nix
nix.useSandbox = "relaxed";
```

Finally, we must ensure that external processes can connect to an X server. Use
`xhost` to authorize any process to connect:

```bash
$ xhost +
```

Usage
=====
A Nix expression that builds AmigaOS software may look like this:

```nix
{amigaosenv, dependency}:

amigaosenv.mkDerivation {
  name = "mypackage-0.1";
  src = /path/to/source.tar.gz; # Or perhaps function invocation to fetchurl
  buildInputs = [ dependency ];
  
  # Package build instructions
  buildCommand = ''
    tar xfvz $src
    cd mypackage-0.1
    ./configure --prefix=/OUT # All packages must be installed in the OUT: assignment
    make
    make install
  '';
  kickstartROMFile = /home/sander/kick.rom; # Path to the AmigaOS 3.1 Kickstart ROM file
  baseDiskImage = /home/sander/amigabaseimage; # Path to an UAE mount containing a clean Workbench 3.1 installation
  uaeUAE = true; # true means use the vanilla UAE, false implies using FS-UAE
}
```

Of course, as with ordinary Nix expressions, this expression must also be
composed by invoking it with its required function arguments. More details and
some concrete examples can be found in the `examples/` directory.

Examples
========
This package includes several example cases:

* GNU Hello, the trivial example case from the GNU project
* `hello-intuition`, a very trivial native AmigaOS application opening an intuition window displaying a friendly greeting
* [wavepak](http://aminet.net/package/mus/misc/wavepak), is a freeware utility, which can encode and decode 8SVX samples using a fibonacci or exponential-delta method

The top-level expression of these examples can be found in
`examples/deployment/default.nix` in this package. For example, GNU Hello can be
built by opening the `examples/deployment` directory and by running:

```bash
$ nix-build \
  --arg kickstartROMFile /home/sander/kick.rom \
  --arg baseDiskImage /home/sander/amigabaseimage \
  -A hello
```

By default, the AmigaOS build function uses the vanilla UAE to execute builds.
Alternatively, FS-UAE, a more advanced and newer version of UAE can be used. Its
only drawback compared to the vanilla UAE is that it carries out builds much
slower.

```bash
$ nix-build --arg useUAE false \
  --arg kickstartROMFile /home/sander/kick.rom \
  --arg baseDiskImage /home/sander/amigabaseimage \
  -A hello
```
