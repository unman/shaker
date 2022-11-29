#!/usr/bin/bash
if [ "`id -u`" -ne 0 ]; then
  exec sudo "$0"
  exit 99
fi
target_file='/rw/config/wireguard.conf'
cd /rw/config/vpn
zenity --question --text="Do you have a zip file from Mullvad?" --ok-label="Yes" --cancel-label="No"
if [ $? = 0 ] ; then
  client_file=`zenity --file-selection`
  if  [ $(mimetype -b $client_file) == "application/zip" ]; then
    unzip -j -d /rw/config/vpn "$client_file"
  else
    zenity --error --text="That doesn't look like a zip file"
    exit
    fi
fi
zenity --question --text="Have you copied the wireguard config file to /rw/config/vpn/ ?" --ok-label="Yes" --cancel-label="No"
if [ $? = 0 ] ; then
  zenity --question --text="Please select the wireguard configuration file you want to use" --ok-label="OK" --cancel-label="No"
  if [ $? = 0 ] ; then
    client_file=`zenity --file-selection`
    if grep -q '^PrivateKey' "$client_file" ; then
      if [ "$client_file" != "$target_file" ]; then
        cp $client_file $target_file
      fi
      zenity --info --text="Restart this qube. The VPN service will start automatically."
    else
     zenity --error --text="That doesn't look like a client config file"
     exit
    fi
  else
    zenity --error --text="You need a config file\nCheck with Mullvad VPN"
    exit
  fi
else
  exit
fi
