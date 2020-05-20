#!/bin/sh

# Update csgo
./steamcmd.sh +login anonymous +force_install_dir ../csgo +app_update 740 validate +quit

# Install plugins
if [ ! -f "/steam/pluginmarker" ]; then
  touch /steam/pluginmarker
  mkdir /steam/plugins
  echo "Installing plugins"
  cd /steam/plugins
  
  #SM und MM
  echo "Installing Sourcemod and Metamod"
  curl -sqL "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz"  | tar xz -C /steam/plugins/
  curl -sqL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6488-linux.tar.gz"  | tar xz -C /steam/plugins/
  
  #InfluxTimer
  echo "Installing InfluxTimer"
  wget -O influx.zip https://influxtimer.com/dl/influx_49_surf.zip
  echo "wget done"
  unzip influx.zip
  echo "unzip done"
  rm influx.zip
  
  
  chmod -R 777 /steam/plugins
  cp -r /steam/plugins/. /steam/csgo/csgo
  rm -rf /steam/plugins/
  cd /steam/csgo/
  echo "Finished installing plugins"
fi

# Start csgo
/steam/csgo/srcds_run -sv_maxrate 0 -sv_minrate 80000 -sv_mincmdrate 128 -sv_maxupdaterate 128 -sv_minupdaterate 128 -game csgo -console -usercon -strictportbind -port 27015 +clientport 27005 +tv_port 27020 -tickrate 128 +log on +game_type 0 +game_mode 0 +mapgroup mg_bomb +map de_dust -authkey -unsecure -insecure +rcon_password rconpw123 +sv_setsteamaccount $GSLT -net_port_try 1 +hostname hostname
