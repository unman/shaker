#!/usr/bin/bash

get_help(){
cat <<HERE
Allow remote access to a named qube.

Syntax: in.sh [-h | [ a|p ]] {add|delete} target {tcp|udp} {port number|service} [external port]
options:
h   Print this help

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

status=0

if [[ $2 =~ ^[0-9]+$ ]] ;then
	if [ "$2" -lt 65536 ]; then
		portnum=$2
	else
		status=1
	fi
else 
  if !  grep -q -w ^"$2"\  /etc/services  ; then
    status=1
  else
    portnum=$( getent services "$2" |awk 'match($0, /[0-9]+/){print substr($0, RSTART, RLENGTH)}') ||  status=1
	fi
fi
if [ $status -eq 1 ]; then
  echo "Specify usable port number or service name" && exit
else
  echo "$portnum"
fi
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
qvm-run -q -u root ${my_netvms[$lasthop]} " nft list table qubes|grep ' $proto dport $portnum dnat to ${my_ips[$numhops-1]}'"
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
	 qvm-run -q -u root ${my_netvms[$i]} -- nft insert rule qubes dnat-dns meta iifname $iface $proto dport $portnum_used dnat to ${my_ips[$i-1]}:$portnum_target
	 qvm-run -q -u root ${my_netvms[$i]} -- nft insert rule qubes custom-forward meta iifname $iface ip daddr ${my_ips[$i-1]} $proto dport $portnum_target ct state new accept
   if  [ $permanent -eq 1 ]; then
     qvm-run -q -u root ${my_netvms[$i]} -- "echo nft insert rule qubes dnat-dns PR-QBS-SERVICES meta iifname $iface $proto dport $portnum_used dnat to ${my_ips[$i-1]}:$portnum_target >> /rw/config/rc.local"
     qvm-run -q -u root ${my_netvms[$i]} -- "echo nft insert rule qubes dnat-dns meta iifname $iface ip daddr ${my_ips[$i-1]} $proto dport $portnum_target ct state new accept >> /rw/config/rc.local"
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
  echo "${my_netvms[$i]}"
  if [ $i -eq 1 ]; then
    portnum_used=$external_portnum
    portnum_target=$portnum
  else
    portnum_used=$external_portnum
    portnum_target=$external_portnum
  fi
		local handle=$( get_handle ${my_netvms[$i]} qubes "dport $external_portnum " 1 )
		qvm-run -q  -u root ${my_netvms[$i]} -- "nft delete rule qubes custom-forward handle $handle"
		local handle=$( get_handle ${my_netvms[$i]} qubes "dport $external_portnum " 1 )
		qvm-run -q -u root ${my_netvms[$i]} -- "nft delete rule qubes dnat-dns handle $handle"
    if [ $permanent -eq 1 ]; then
      qvm-run -q -u root ${my_netvms[$i]} -- "sed -i '/nft insert rule qubes dnat-dns meta iifname $iface $proto dport $portnum_used dnat to ${my_ips[$i-1]}:$portnum_target/d'  /rw/config/rc.local"
      qvm-run -q -u root ${my_netvms[$i]} -- "sed -i '/nft insert rule qubes QBS-FORWARD meta iifname $iface ip daddr ${my_ips[$i-1]} $proto dport $portnum_target ct state new accept/d'  /rw/config/rc.local"
    fi
	((i--))
done
local found=$( qvm-run -p -q -u root ${my_netvms[$i]} -- nft list table qubes 2>/dev/null )
	handle=$( get_handle ${my_netvms[$i]} qubes "dport $portnum " 1 )
	qvm-run -q -u root ${my_netvms[$i]} -- nft delete rule qubes custom-input handle $handle
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
      exit
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
	found=$( qvm-run -p -q -u root $qube_name -- nft list table qubes 2>/dev/null )
		qvm-run -q -u root $qube_name  "nft list table qubes|grep '$proto dport $portnum accept' "
		if [ $? -eq 0 ]; then
			echo "Input rule in $qube_name already exists"
			echo "Please check configuration - exiting now."
			exit
		else
			#handle=$( get_handle $qube_name qubes related,established 1)
			qvm-run -q -u root $qube_name -- nft add rule qubes custom-input iifname eth0 $proto dport $portnum accept
		fi
	tunnel netvms[@] ips[@]
	if [ $? -ne 0 ]; then
		teardown netvms[@] ips[@]
	fi
else
	get_help
fi

