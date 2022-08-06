#!/usr/bin/bash
qvm-start sys-pihole && sleep 5
if [ $(qubes-prefs default_netvm sys-firewall |grep sys-firewall ) ]; then
  qubes-prefs default_netvm sys-pihole
fi

for i in $(qvm-ls -ONAME,NETVM |awk '/ sys-firewall/{print  $1} ')
do
  qvm-prefs $i netvm sys-pihole
done
