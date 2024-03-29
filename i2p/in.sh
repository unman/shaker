#!/usr/bin/bash

get_help(){
cat <<HERE
Allow remote access to a named qube.

Syntax: in.sh [-h | [ a|p ]] {add|delete} target {tcp|udp} {port number|service} [external port]
options:
h   Print this help
a   Auto mode
p   Permanent rules

Specify target qube, action, tcp or udp, and target port, separated by spaces.
The target port can be given by port number or by name (e.g ssh).
The action should be "add" or "delete".
For example:
	in add target_qube tcp 80 
	in add target_qube tcp ssh 
	in delete target_qube tcp https 

By default, the script will open a port on the final netvm which is the same as the target port.
It is possible to specify an alternative port:
	in add target_qube tcp ssh 80

In auto mode a port will be opened on the FIRST external interface.
In permanent mode changes to the firewall will be written in each qube to take effect on qube start up.

DO NOT use this script for qubes behind a Tor or VPN proxy.
At a minimum you risk breaking the security of those proxies.

HERE
exit
}


# Check input port
check_port(){
if ! [ "$2" -eq "$2" >& /dev/null ];then
  status=1
else
	if [ $2 -lt 65536 ]; then
		status=0
		portnum=$2
	else
		status=1
	fi
fi
if [ $status -ne 0 ]; then
  if !  grep -q -w ^$2\  /etc/services  ; then
    echo "Specify usable port number or service name"
    exit
  else
    portnum=$( getent services $2 |awk '{split($2,a,"/");print a[1]}')
    if [ $? -ne 0 ]; then
      echo "Specify usable port number or service name"
      exit
		fi
	fi
fi
echo $portnum
}


get_handle(){
local my_handle=$( qvm-run -q -u root -p $1 " nft -a list table $2|awk 'BEGIN{c=0} /$3/{c++; if (c==$4) print \$NF}' " )
echo $my_handle
}


#Tunnel through netvms
tunnel(){
declare -a my_netvms=("${!1}")
declare -a my_ips=("${!2}")
declare -i numhops
numhops=${#my_ips[@]}
lasthop=$((numhops-1))
local i=1
iface="eth0"
qvm-run -q -u root ${my_netvms[$lasthop]} " nft list table nat|grep ' $proto dport $portnum dnat to ${my_ips[$numhops-1]}'"
if [ $? -eq 0 ]; then
	echo "Are rules already set?"
	exit
fi
while [ $i -ne $numhops ]
do
	if [ $i -eq 1 ]; then
		portnum_used=$external_portnum
		portnum_target=$portnum
	else
		portnum_used=$external_portnum
		portnum_target=$external_portnum
	fi
	echo "${my_netvms[$i]} $portnum_used"
	if [ $i -eq $lasthop ]; then
		iface=$external_iface
	fi
	# Is it nft or iptables?
	local found=$( qvm-run -p -q -u root ${my_netvms[$i]} -- nft list table nat 2>/dev/null )
	if [[ x$found == 'x' ]]; then
		qvm-run -q -u root ${my_netvms[$i]} -- "iptables -I QBS-FORWARD -i $iface -p $proto --dport $portnum_target -d ${my_ips[$i-1]} -j ACCEPT"
		qvm-run -q -u root ${my_netvms[$i]} -- "iptables -t nat -I PR-QBS-SERVICES -i $iface -p $proto --dport $portnum_used -j DNAT --to-destination ${my_ips[$i-1]}:$portnum_target"
    if [ $permanent -eq 1 ]; then
      qvm-run -q -u root ${my_netvms[$i]} -- "echo iptables -I QBS-FORWARD -i $iface -p $proto --dport $portnum_target -d ${my_ips[$i-1]} -j ACCEPT >> /rw/config/rc.local"
      qvm-run -q -u root ${my_netvms[$i]} -- "echo iptables -t nat -I PR-QBS-SERVICES -i $iface -p $proto --dport $portnum_used -j DNAT --to-destination ${my_ips[$i-1]}:$portnum_target >> /rw/config/rc.local"
    fi
	else
		qvm-run -q -u root ${my_netvms[$i]} -- nft insert rule nat PR-QBS-SERVICES meta iifname $iface $proto dport $portnum_used dnat to ${my_ips[$i-1]}:$portnum_target
		qvm-run -q -u root ${my_netvms[$i]} -- nft insert rule filter QBS-FORWARD meta iifname $iface ip daddr ${my_ips[$i-1]} $proto dport $portnum_target ct state new accept
    if  [ $permanent -eq 1 ]; then
      qvm-run -q -u root ${my_netvms[$i]} -- "echo nft insert rule nat PR-QBS-SERVICES meta iifname $iface $proto dport $portnum_used dnat to ${my_ips[$i-1]}:$portnum_target >> /rw/config/rc.local"
      qvm-run -q -u root ${my_netvms[$i]} -- "echo nft insert rule filter QBS-FORWARD meta iifname $iface ip daddr ${my_ips[$i-1]} $proto dport $portnum_target ct state new accept >> /rw/config/rc.local"
    fi
	fi
	((i++))
done
}


#Teardown - from top netvm down
teardown(){
declare -a my_netvms=("${!1}")
declare -a my_ips=("${!2}")
declare -i numhops
numhops=${#my_ips[@]}
numhops=$((numhops-1))
local i=$numhops
iface="eth0"
echo "Removing firewall rules"
while [ $i -gt 0 ]
do
  if [ $i -eq 1 ]; then
    portnum_used=$external_portnum
    portnum_target=$portnum
  else
    portnum_used=$external_portnum
    portnum_target=$external_portnum
  fi
	# Is it nft or iptables?
	echo "${my_netvms[$i]}"
	local found=$( qvm-run -p -q -u root ${my_netvms[$i]} -- "nft list table nat 2>/dev/null" )
 	if [[ x$found == 'x' ]]; then
		qvm-run -q -u root ${my_netvms[$i]} -- "iptables -D QBS-FORWARD -i $iface -p $proto --dport $portnum_target -d ${my_ips[$i-1]} -j ACCEPT"
		qvm-run -q -u root ${my_netvms[$i]} -- "iptables -t nat -D PR-QBS-SERVICES -i $iface -p $proto --dport $external_portnum -j DNAT --to-destination ${my_ips[$i-1]}:$portnum_target"
    if [ $permanent -eq 1 ]; then
      qvm-run -q -u root ${my_netvms[$i]} -- "sed -i '/iptables -D QBS-FORWARD -i $iface -p $proto --dport $portnum_target -d ${my_ips[$i-1]} -j ACCEPT/d' /rw/config/rc.local"
      qvm-run -q -u root ${my_netvms[$i]} -- "sed -i '/iptables -t nat -D PR-QBS-SERVICES -i $iface -p $proto --dport $external_portnum -j DNAT --to-destination ${my_ips[$i-1]}:$portnum_target/d' /rw/config/rc.local"
    fi
	else
		local handle=$( get_handle ${my_netvms[$i]} nat "dport $external_portnum " 1 )
		qvm-run -q  -u root ${my_netvms[$i]} -- "nft delete rule nat PR-QBS-SERVICES handle $handle"
		local handle=$( get_handle ${my_netvms[$i]} filter "dport $external_portnum " 1 )
		qvm-run -q -u root ${my_netvms[$i]} -- "nft delete rule filter QBS-FORWARD handle $handle"
    if [ $permanent -eq 1 ]; then
      qvm-run -q -u root ${my_netvms[$i]} -- "sed -i '/nft insert rule nat PR-QBS-SERVICES meta iifname $iface $proto dport $portnum_used dnat to ${my_ips[$i-1]}:$portnum_target/d'  /rw/config/rc.local"
      qvm-run -q -u root ${my_netvms[$i]} -- "sed -i '/nft insert rule filter QBS-FORWARD meta iifname $iface ip daddr ${my_ips[$i-1]} $proto dport $portnum_target ct state new accept/d'  /rw/config/rc.local"
    fi
	fi
	((i--))
done
local found=$( qvm-run -p -q -u root ${my_netvms[$i]} -- nft list table nat 2>/dev/null )
if [[ x$found == 'x' ]]; then
	qvm-run -q -u root ${my_netvms[$i]} " iptables -D INPUT -p $proto --dport $external_portnum -j ACCEPT"
else
	handle=$( get_handle ${my_netvms[$i]} filter "dport $portnum " 1 )
	qvm-run -q -u root ${my_netvms[$i]} -- nft delete rule filter INPUT handle $handle
fi
exit
}


list(){
return
}


## Defaults
auto=0
permanent=0

## Get options
optstring=":hap"
while getopts ${optstring} option ; do
  case $option in
    h) 
      get_help
      exit ;;
    a)
      auto=1 ;;
    p)
      permanent=1 ;;
    ?)
      get_help ;; 
  esac
done
shift $((OPTIND -1))

## Check inputs
if [ $# -lt 4 ]; then
	get_help
fi
qvm-check -q $2 2>/dev/null
if [ "$?" -ne 0 ];then
  echo "$2 is not the name of any qube"
  exit
else
	qube_name=$2
fi
if [ "$3" != "tcp" -a "$3" != "udp" ]; then
  echo "Specify tcp or udp"
  exit
else
	proto=$3
fi
portnum=$(check_port $3 $4)

if [ $# -eq 5 ]; then
	external_portnum=$(check_port $3 $5)
else
	external_portnum=$portnum
fi

# Get all netvms
declare -a netvms
declare -a ips
declare -a external_ips
hop=0
netvms[$hop]=$qube_name
IFS='|' read -r netvms[$hop+1] ips[$hop] <<< $(qvm-ls $qube_name --raw-data -O netvm,IP)
while [ ${netvms[hop+1]} != "-" ]
do
  ((hop++))
  IFS='|' read -r netvms[$hop+1] ips[$hop] <<< $(qvm-ls ${netvms[$hop]} --raw-data -O netvm,IP)
done
if [ $1 == "delete" ]; then
	teardown netvms[@] ips[@]
elif [ $1 == "add" ]; then
	if [ $hop -eq 0 ]; then
		echo "$qube_name is not network connected"
		echo "Cannot set up a tunnel"
		exit
	fi

	# Check last hop has external IP address 
	readarray -t external_ips < <( qvm-run -p ${netvms[$hop]} "ip -4 -o a|grep -wv 'lo\|vif[0-9]*.*'"|awk '{print $2,$4}')
	#readarray -t external_ips < <( qvm-run -p ${netvms[$hop]} "ip -4 -o a|grep -wv 'vif[0-9]'"|awk '{print $2,$4}')
	num_ifs=${#external_ips[@]}
	if [ $num_ifs -eq 1 ]; then
		interface=0
	elif [ $auto -eq 1 ]; then
		interface=0
	elif [ $num_ifs -gt 1 ]; then
		echo "${netvms[$hop]} has more than 1 external interface"
		echo "Which one do you want to use?"
		for i in $(seq $num_ifs)
		do
			echo "$i. ${external_ips[$i-1]}"
		done
		read interface
		if ! [ "$interface" -eq "$interface" ] 2> /dev/null; then
			echo "No such interface"
			exit
		elif [ $interface -gt $num_ifs ] || [ $interface -lt 1 ]; then
			echo "No such interface"
			exit
		fi
		((interface--))
	else
		echo "${netvms[$hop]} does not have an external interface"
    echo "Cannot set up a tunnel"
    exit
	fi
	external_ip=${external_ips[$interface]}
	external_iface="${external_ip%[[:space:]]*}"
	ip="${external_ip#*[0-9]}"
	ip="${ip%%/*}"
	ips[$hop]=$ip

	# Create tunnel
	found=$( qvm-run -p -q -u root $qube_name -- nft list table nat 2>/dev/null )
 	if [[ x$found == 'x' ]]; then
		found=$(qvm-run -p -u root $qube_name "iptables -L -nv |grep -c '.*ACCEPT.*$proto dpt:$portnum' ")
		if [ "$found" -gt 0 ]; then
			echo "Input rule in $qube_name already exists"
			echo "Please check configuration - exiting now."
			exit
		else
			qvm-run -q -u root $qube_name  "iptables -I INPUT -p $proto --dport $portnum -j ACCEPT "
		fi
	else
		qvm-run -q -u root $qube_name  "nft list table filter|grep '$proto dport $portnum accept' "
		if [ $? -eq 0 ]; then
			echo "Input rule in $qube_name already exists"
			echo "Please check configuration - exiting now."
			exit
		else
			handle=$( get_handle $qube_name filter related,established 1)
			qvm-run -q -u root $qube_name -- nft add rule filter INPUT position $handle iifname eth0 $proto dport $portnum accept
		fi
	fi
	tunnel netvms[@] ips[@]
	if [ $? -ne 0 ]; then
		teardown netvms[@] ips[@]
	fi
else
	get_help
fi

