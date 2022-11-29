#!/bin/bash
#    Block forwarding of connections through upstream network device
#    (in case the vpn tunnel breaks):
iptables -I FORWARD -o eth0 -j DROP
iptables -I FORWARD -i eth0 -j DROP
ip6tables -I FORWARD -o eth0 -j DROP
ip6tables -I FORWARD -i eth0 -j DROP

#    Accept traffic to VPN
iptables -P OUTPUT DROP
iptables -F OUTPUT
iptables -I OUTPUT -o lo -j ACCEPT

#    Add the `qvpn` group to system, if it doesn't already exist
if ! grep -q "^qvpn:" /etc/group ; then
     groupadd -rf qvpn
     sync
fi
sleep 2s

#    Block non-VPN traffic to clearnet
iptables -I OUTPUT -o eth0 -j DROP
#    Allow traffic from the `qvpn` group to the uplink interface (eth0);
#    Our VPN client will run with group `qvpn`.
iptables -I OUTPUT -p all -o eth0 -m owner --gid-owner qvpn -j ACCEPT
iptables -I OUTPUT -o eth0 -p udp --dport 53 -j ACCEPT
