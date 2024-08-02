#!/bin/bash

# initialized by TY , modularized and refactored by D

#Init code
source $(dirname $0)/../scripts/initTool.sh "Usage $0 <domain_name>" $@ 

# Var definitions
domain=$1
ip_address=$(dig +short "$domain" | head -n 1) #Temp fix for domains with multiple IP addresses

# Program
if [ -z "$ip_address" ] || [ "$ip_address" == "143.244.220.150" ]; then
	echo "unable to resolve $domain ip"
	exit 1
else
	clear
	echo "IP address for $domain follows"
	print_line
	cat $BASE_PATH/assets/shovel.txt
	echo "$ip_address"
	print_line
fi

# Save data to db
$BASE_PATH/scripts/queries.py put ip $ip_address $domain

# Links to external tools & scripts
link_tool portScanner "Would you like to map this IP's ports?" "$ip_address"
