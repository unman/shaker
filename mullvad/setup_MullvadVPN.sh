#!/usr/bin/bash
qvm-run MullvadVPN /home/user/install.sh
if ! (qvm-firewall MullvadVPN|tail -n1 |grep -q '.*drop.*-.*-'.*-);then
qvm-firewall MullvadVPN add --before 0 drop && qvm-firewall MullvadVPN del --rule-no 1
fi
endpoint=$(qvm-run -p MullvadVPN 'awk "/Endpoint/{print \$3}" /rw/config/wireguard.conf')
IFS=":" read -r server_ip server_port  PORT <<< $endpoint
if ! (qvm-firewall MullvadVPN |grep -q 'accept.*-.*tcp.*53'); then
qvm-firewall MullvadVPN add --before 0 proto=tcp dstports=53 accept
fi
if ! (qvm-firewall MullvadVPN |grep -q 'accept.*-.*udp.*53'); then
qvm-firewall MullvadVPN add --before 0 proto=udp dstports=53 accept
fi
if ! (qvm-firewall MullvadVPN |grep -q "$server_ip");then
qvm-firewall MullvadVPN add --before 0 dsthost=$server_ip proto=udp dstports=$server_port accept
fi

