#!/bin/sh
find /proc/sys/net/ipv4/conf -name "vif*" -exec bash -c 'echo 1 | sudo tee {}/route_localnet' \;
