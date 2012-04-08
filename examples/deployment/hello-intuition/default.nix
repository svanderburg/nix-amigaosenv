{amigaosenv}:

amigaosenv.mkDerivation {
  name = "hello-intuition";
  src = ../../src/hello-intuition;
  buildCommand = ''
    cd hello-intuition
    make
    mkdir -p /OUT/bin
    cp hello /OUT/bin
  '';
}
