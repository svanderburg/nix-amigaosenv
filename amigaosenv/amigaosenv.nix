{stdenv, uae, procps, amigaDiskImage, kickstartROMFile}:
{name, src, buildCommand, buildInputs ? []}:

stdenv.mkDerivation {
  inherit name;
  
  buildInputs = [ uae procps ];
  
  buildCommand = ''
    # Create virtual harddisk
    mkdir hd
    cd hd
    
    # Symlink AmigaOS stuff
    
    for i in ${amigaDiskImage}/{C,Classes,Expansion,Fonts,L,Libs,Locale,Prefs,Rexxc,S,Storage,System,Tools,Utilities,WBStartup}
    do
        ln -s "$i"
    
        # Symlink icons
        if [ -f "$i.info" ]
        then
            ln -sf "$i.info"
        fi
    done

    # Copy the geek gadgets environment and fix permissions
    
    cp -av ${amigaDiskImage}/GG .
    chmod 755 GG
    
    cd GG
    
    for i in `find . -type d` `find . -type f`
    do
        chmod 755 $i
    done
    
    # Install build inputs
    
    for i in ${toString buildInputs}
    do
        cp -av $i/* .
    done
    
    cd ..
    
    # Copy source file
    
    mkdir T
    cd T
    
    stripHash ${src}
    cp -av ${src} $strippedName
    
    if [ -d "$strippedName" ]
    then
        chmod -R 755 "$strippedName"
    fi
    
    # Create build script
    
    echo "src=$strippedName" > buildinstructions.sh
    
    cat >> buildinstructions.sh << "EOF"
    ${buildCommand}
    EOF
    
    cat > build.sh << "EOF"
    ( sh -e buildinstructions.sh
      
      if [ $? = 0 ]
      then
          echo "success" > /OUT/done
      else
          echo "failure" > /OUT/done
      fi
    ) 2>&1 | tee /OUT/log.txt
    EOF
    
    cd ../..
    
    # Create output directory
    mkdir -p $out
    
    # Create UAE config file
    export HOME=$(pwd)
    
    cat > .uaerc <<EOF
    config_description=UAE default configuration
    use_gui=no
    kickstart_rom_file=${kickstartROMFile}
    sound_output=none
    fastmem_size=8
    chipmem_size=4
    cpu_speed=max
    cpu_type=68ec020
    gfx_linemode_windowed=double
    filesystem2=rw,:HD0:$(pwd)/hd,1
    filesystem=rw,HD0:$(pwd)/hd
    filesystem2=rw,:OUT:$out,0
    filesystem=rw,OUT:$out
    EOF
    
    # We require a X11 display (Yes, I know it's impure)
    export DISPLAY=:0
    
    # Start UAE
    uae &
    
    # Wait until the build starts generating output
    while [ ! -f $out/log.txt ]
    do
        sleep 1
    done
    
    # Try to display some of the output while the build is running
    tail -f $out/log.txt &
    
    # Wait until the build indicates that it has finished
    while [ ! -f $out/done ]
    do
        sleep 1
    done
    
    # Kill the emulator and tail processes
    pkill uae
    sleep 1
    pkill tail
    
    # Check the build status
    [ "$(cat $out/done)" = "success" ]
    
    # Remove some temp stuff
    cd $out
    rm done
    
    rm -f `find . -name _UAEFSDB.___`
  '';
}
