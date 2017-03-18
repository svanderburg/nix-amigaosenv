{stdenv, uae, fsuae, lndir, procps, mkGGEnabledDiskImage}:
{name, src ? null, buildCommand, buildInputs ? [], kickstartROMFile, baseDiskImage, amigaModel ? "A4000/040", useUAE}:

let
  diskImage = mkGGEnabledDiskImage {
    inherit baseDiskImage;
  };
  
  generateEmulatorConfig = if useUAE then ''
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
  ''
  else
  ''
    cat > config.fs-uae <<EOF
    hard_drive_0 = $(pwd)/hd
    hard_drive_0_label = HD0
    hard_drive_1 = $out
    hard_drive_1_label = OUT
    kickstart_file = ${kickstartROMFile}
    amiga_model = ${amigaModel}
    uae_fastmem_size = 8
    uae_sound_output = none
    automatic_input_grab = 0
    uae_cpu_speed = max
    EOF
  '';
  
  startUae = if useUAE then "uae & UAE_PID=$!" else "fs-uae ./config.fs-uae & UAE_PID=$!";
  
  cpOrLn = path: if useUAE then ''ln -s "${path}"'' else ''cp -rv "${path}" .'';
  
  cpOrLndir = path: if useUAE then ''lndir "${path}"'' else
    ''
      cp -rv "${path}"/* .
      chmod -R u+w .
    '';
in
stdenv.mkDerivation {
  inherit name;
  
  buildInputs = [ procps ] ++ (if useUAE then [ uae lndir ] else [ fsuae ]);
  
  __noChroot = true;
  
  buildCommand = ''
    # Create virtual harddisk
    mkdir hd
    cd hd
    
    # Symlink AmigaOS stuff
    
    for i in ${diskImage}/{C,Classes,Expansion,Fonts,L,Libs,Locale,Prefs,Rexxc,S,Storage,System,Tools,Utilities,WBStartup}
    do
        ${cpOrLn "$i"}
    
        # Symlink icons
        if [ -f "$i.info" ]
        then
            ${cpOrLn "$i.info"}
        fi
    done

    # Symlink the geek gadgets environment
    
    mkdir GG
    cd GG
    ${cpOrLndir "${diskImage}/GG"}
    
    # Symlink build inputs
    
    for i in ${toString buildInputs}
    do
        ${cpOrLndir "$i"}
    done
    
    cd ..
    
    # Copy source file
    
    mkdir T
    cd T
    
    ${if src == null then "" else ''
      strippedName=$(stripHash ${src})
      cp -rv ${src} $strippedName
      
      if [ -d "$strippedName" ]
      then
          chmod -R 755 "$strippedName"
      fi
      
      echo "src=$strippedName" > buildinstructions.sh
    ''}
    
    # Create build script
    
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
    ) 2>&1 | tee /OUT/.log.txt
    EOF
    
    cd ../..
    
    chmod -R u+w hd
    
    # Create output directory
    mkdir -p $out
    
    # Create UAE config file
    export HOME=$(pwd)
    
    ${generateEmulatorConfig}
    
    # We require a X11 display (Yes, I know it's impure)
    export DISPLAY=:0
    
    # Start UAE
    ${startUae}
    
    # Wait until the build starts generating output
    while [ ! -f $out/.log.txt ]
    do
        sleep 1
    done
    
    # Try to display some of the output while the build is running
    tail -f $out/.log.txt & TAIL_PID=$!
    
    # Wait until the build indicates that it has finished
    while [ ! -f $out/done ]
    do
        sleep 1
    done
    
    # Kill the emulator and tail processes
    kill $UAE_PID
    sleep 1
    kill $TAIL_PID
    
    # Check the build status
    [ "$(cat $out/done)" = "success" ]
    
    # Remove some temp stuff
    cd $out
    rm done
    
    rm -f `find . -name _UAEFSDB.___`
  '';
}
