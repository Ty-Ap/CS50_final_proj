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
shift
ports=$@
user_agent="Mozilla/5.0 (compatible; Fingerprinter/1.0)"
request="HEAD / HTTP/1.1\r\nHost: $ip_address\r\nUser-Agent: $user_agent\r\nConnection: close\r\n\r\n"
echo "Scanning..."
for port in ${ports[@]}; do
	banner=$(echo "$request" | nc -v -n -w 1 "$ip_address" "$port" 2>&1) 

	server=$(echo "$banner" | grep -E "Server:" | tr " " "_")
	contentType=$(echo "$banner" | grep -E "Content-Type:" | tr " " "_")
	connection=$(echo "$banner" | grep -E "Connection:" | tr " " "_")
	http=$(echo "$banner" | grep -E "HTTP/" | tr " " "_")
	port_list+=("_${YELLOW}Port: ${GREEN}${port}_")
	data_list+=($(echo "$server\n$contentType\n$connection" | tr -d "\r"))
done

printf -v port_string "%s," "${port_list[@]}"
printf -v data_string "%s," "${data_list[@]}"
echo "Done"
clear
./print_ports.py "$(echo ${port_string%,} | tr '_' ' ')" "$(echo ${data_string%,} | tr '_' ' ')" "\033[33m"

#Save data to db
$scriptPath/queries.py put service $ip_address $port 'We need to better organize this data from banner'


# Links to external tools & scripts

# msf console?
# exploitdb?
# whatweb?
