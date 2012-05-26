#!/bin/sh -e

cd $AMIGABASE

# Unpack geek gadgets packages

mkdir GG
cd GG

for i in $GG_SOURCE/*.tgz
do
    tar xfvz $i
done

# Fix sh symlink

cd bin
rm sh
ln -s ksh sh
cd ..

# Install system headers
cp -av $GG_SOURCE/ftp.back2roots.org/pub/back2roots/cds/fred_fish/geekgadgets_vol1_9610/ade-bin/os-include .

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
