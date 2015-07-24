#!/bin/bash
source "/vagrant/scripts/common.sh"

id=$1

function configureFirewall {
	echo "setting up firewall"

	echo $id 

	if [ "$id" = "2" ] ; then
		echo "keeping everything open on node2"

	else 
		# see also http://unix.stackexchange.com/questions/11851/iptables-allow-certain-ips-and-block-all-other-connection
		iptables -P FORWARD DROP # we aren't a router
		iptables -A INPUT -m state --state INVALID -j DROP
		iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
		iptables -A INPUT -i lo -j ACCEPT
		iptables -A INPUT -m iprange --src-range 10.211.55.101-10.211.55.105 -j ACCEPT
		iptables -A INPUT -p tcp --dport ssh -j ACCEPT
		iptables -P INPUT DROP
		service iptables save
		echo "configured local firewall"
	fi
}

echo "setup firewall"

configureFirewall