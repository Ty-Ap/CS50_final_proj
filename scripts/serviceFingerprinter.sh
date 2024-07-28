#!/bin/bash

# initialized by TY , modularized and refactored by D

# Usage statement
if [ -z "$1" ]; then
	echo "usage $0 <ip_address> <port>"
	exit 1
fi

# Config check
if [ $CONFIG != 1 ]; then
	echo "Command executed standalone: Running config"
	export scriptPath=$(dirname $0)
	source $scriptPath/../config/config.sh
fi

# Var defintions
ip_address=$1
port=$2
user_agent="Mozilla/5.0 (compatible; Fingerprinter/1.0)"
request="HEAD / HTTP/1.1\r\nHost: $ip_address\r\nUser-Agent: $user_agent\r\nConnection: close\r\n\r\n"
banner=$(echo "$request" | nc -v -n -w 1 "$ip_address" "$port" 2>&1 )

# Program
echo "Port: $port"
echo "$banner" | grep -E "HTTP/|Server:|Content-Type:|Date:|Connection:|Content-Length:"

#Save data to db
$scriptPath/queries.py put service $ip_address $port 'We need to better organize this data from banner'


# Links to external tools & scripts

# msf console?
# exploitdb?
# whatweb?
