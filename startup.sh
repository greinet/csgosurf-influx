#!/bin/sh

# Update csgo
./steamcmd.sh +login anonymous +force_install_dir ../csgo +app_update 740 validate +quit

# Install plugins
if [ ! -f "/steam/csgo/pluginmarker" ]; then
  touch /steam/csgo/pluginmarker
  mkdir /steam/plugins
  echo "Installing plugins"
  cd /steam/plugins
  
  #server.cfg
  mkdir cfg
  echo "sv_maxrate 0
sv_minrate 80000
sv_mincmdrate 128
sv_maxupdaterate 128
sv_minupdaterate 128" >> cfg/server.cfg
  
  #SM und MM
  echo "Installing Sourcemod and Metamod"
  curl -sqL "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz"  | tar xz -C /steam/plugins/
  curl -sqL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6488-linux.tar.gz"  | tar xz -C /steam/plugins/
  
  #Set Sourcemod admin
  echo $ADMIN"      99:z" >> /steam/plugins/addons/sourcemod/configs/admins_simple.ini
  
  #InfluxTimer
  echo "Installing InfluxTimer"
  wget -O influx.zip https://influxtimer.com/dl/influx_49_surf.zip
  echo "wget done"
  unzip influx.zip
  echo "unzip done"
  rm influx.zip
  
  #Mapzones
  curl -O -J -L 'https://forums.alliedmods.net/attachment.php?attachmentid=160857&d=1487121637'
  unzip csgomaps.zip
  cp -r mapinis/* addons/sourcemod/influxzones/
  rm csgomaps.zip
  rm -rf __MACOSX
  rm -rf mapinis
  
  #Downloading Maps
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B-gvqLVXDjSVX3ZnLXJ4YkdJX2c' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=0B-gvqLVXDjSVX3ZnLXJ4YkdJX2c" -O tier-1.tar.gz && rm -rf /tmp/cookies.txt && tar -xzvf tier-1.tar.gz && bunzip2 tier_1/* && mv tier_1 maps && rm tier-1.tar.gz
  
  #Creating maplist and mapcycle
  ls -1 | sed -e 's/\.bsp$//' >> /steam/plugins/mapcycle.txt
  ls -1 | sed -e 's/\.bsp$//' >> /steam/plugins/maplist.txt
  
  #Creating mapgroup
  input="/steam/plugins/maplist.txt"
  number=0
  while IFS= read -r line
  do
    echo "                \"$line\" \"$number\"" >> gamemodes_server.txt
    number=$(( number + 1 ))
  done < "$input"

  echo "            }
        }
    }
}" >> /steam/plugins/gamemodes_server.txt
  
  #Moving files
  chmod -R 777 /steam/plugins
  cp -r /steam/plugins/. /steam/csgo/csgo
  rm -rf /steam/plugins/
  cd /steam/csgo/
  echo "Finished installing plugins"
fi

# Start csgo
/steam/csgo/srcds_run -game csgo -console -usercon -strictportbind -port 27015 +clientport 27005 +tv_port 27020 -tickrate 128 +log on +game_type 0 +game_mode 0 +mapgroup surfmaps +map surf_aircontrol_ksf -authkey -unsecure -insecure +rcon_password rconpw123 +sv_setsteamaccount $GSLT -net_port_try 1 +hostname hostname
