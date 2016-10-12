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
In order to use this Nix function, a basic AmigaOS installation with Geek Gadgets
must be manually created and a few settings have to be made in order to use this
function.

Obtaining all prerequisites
---------------------------
First, the Geek Gadgets toolset, system headers and the LhA archiver must be
downloaded. These packages can be obtained by entering the `scripts` directory
and running the following script:

```bash
$ export GG_SOURCE=~/ggdownloads # Preferred location where the downloaded packages must be stored
$ ./download-prerequisites.sh
```

The resulting packages are stored in `$GG_SOURCE`. This environment variable is
also used by the geek gadgets installation script, which we will use later.

Installing the Amiga Workbench
------------------------------
The next step is creating an Amiga Workbench installation, which must be done
manually. The legal way to obtain the Amiga Kickstart ROM images as well as the
Workbench disk images by ordering one of the [Cloanto's Amiga Forever](http://www.amigaforever.com)
discs.

UAE must be instructed to mount a directory on the host filesystem as a hard
disk device. On this hard disk device, the Amiga Workbench must be installed.

Furhermore, as LhA is the most popular archiving format this must also be
installed, which can be done by running the following instructions on the
AmigaOS CLI:

```
> T:
> Protect lha.run +e
> lha.run
> Copy lha_68k C:lha
```

These instructions provide an `lha` executable in the `C:` assignment containing
executables.

Installing Geek Gadgets
-----------------------
After installing a basic Amiga Workbench installation, the Geek Gadgets packages
must be installed. Furthermore, a few adaptions to the Workbench must be made so
that the Geek Gadgets utilities can be properly used and build instructions can
be automated:

```bash
$ export AMIGABASE=~/amigabase # Directory where the AmigaOS filesystem is stored containing the Workbench installation
$ ./install-geekgadgets.sh
```

Configuring the Nix build function
----------------------------------
In order to let the Nix function find the Amiga Kickstart ROM and the Amiga
Workbench, the `amigaosenv/default.nix` file must be adapted:

```nix
kickstartROMFile = /path/to/the/kickstart/kick.rom; # Location of the kick.rom file, which UAE uses
amigaDiskImage = /path/to/amigabase; # Location to the Amiga Workbench installation containing Geek Gadgets
```

Relaxing Nix's purity restrictions
----------------------------------
To make the Nix builds work, we must "cheat" a bit by breaking Nix's purity
facilities. First, ensure that the sandboxing setting has been disabled or set
to `relaxed`, by editing the `/etc/nix/nix.conf` file add adding the following
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
$ nix-build -A hello
```

By default, the AmigaOS build function uses the vanilla UAE to execute builds.
Alternatively, FS-UAE, a more advanced and newer version of UAE can be used. Its
only drawback compared to the vanilla UAE is that it carries out builds much
slower.

```bash
$ nix-build --arg useUAE false -A hello
```
