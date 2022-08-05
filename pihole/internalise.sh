#!/bin/sh
/rw/config/qubes-firewall-user-script
find /proc/sys/net/ipv4/conf -name "vif*" -exec bash -c 'echo 1 | sudo tee {}/route_localnet' \;
