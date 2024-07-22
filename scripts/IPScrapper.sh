#!/bin/bash

#Config check
if [ "$config" != "true" ]; then
	echo "Command executed standalone: Running config"
	export scriptPath="../"
	source ../config/config.sh
fi

#Usage statement for users
if [ -z "$1" ]; then
	echo "Usage $0 <domain_name>"
	exit 1
fi

#IP retrieval
ip_address=$(dig +short "$1")

#My computer's DNS returns 143.244.220.150 if the domain cannot be found for some reason so I have to check for that as well - Dawson Hamera

if [ -z "$ip_address" ] || [ "$ip_address" == "143.244.220.150" ]; then
	echo "unable to resolve $1 ip"
else
	clear
	echo "IP adress for $1 follows"
	print_line
	cat assets/shovel.txt
	echo "$ip_address"
	print_line
fi

if yes_or_no "Would you like to map this IP's ports?"; then
	scripts/portScanner.sh "$ip_address"
fi
