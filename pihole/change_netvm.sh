#!/usr/bin/bash
qvm-start sys-pihole
if [ $(qubes-prefs default_netvm sys-firewall |grep sys-firewall ) ]; then qubes-prefs default_netvm sys-pihole; fi
sleep 3
for i in `qvm-ls -O NAME,NETVM | awk '/ sys-firewall/{ print $1 }'`; do qvm-prefs $i netvm sys-pihole; done


