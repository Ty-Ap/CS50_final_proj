#!/bin/bash

# initialized by TY , modularized and refactored by D

# Usage statement
if [ -z "$1" ]; then
	echo "Usage $0 <domain_name>"
	exit 1
fi

# Config check
if [ -z $CONFIG ]; then
	echo "Command executed standalone: Running config"
	export scriptPath=$(dirname $0)
	source $scriptPath/../config/config.sh
fi

# Var definitions
domain=$1
ip_address=$(dig +short "$domain")

# Program
if [ -z "$ip_address" ] || [ "$ip_address" == "143.244.220.150" ]; then
	echo "unable to resolve $domain ip"
	exit 1
else
	clear
	echo "IP address for $domain follows"
	print_line
	cat $scriptPath/../assets/shovel.txt
	echo "$ip_address"
	print_line
fi

# Save data to db
$scriptPath/queries.py put ip $ip_address $domain

# Links to external tools & scripts
if yes_or_no "Would you like to map this IP's ports?"; then
	$scriptPath/portScanner.sh "$ip_address"
fi
