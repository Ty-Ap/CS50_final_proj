#!/bin/bash

# initialized by TY , modularized and refactored by D

#Init code
source $(dirname $0)/../scripts/initTool.sh "Usage $0 <ip_address> <port>>" $@ 

# Var defintions
ip_address=$1
shift
ports=$@
user_agent="Mozilla/5.0 (compatible; Fingerprinter/1.0)"
request="HEAD / HTTP/1.1\r\nHost: $ip_address\r\nUser-Agent: $user_agent\r\nConnection: close\r\n\r\n"
echo "Scanning..."
for port in ${ports[@]}; do
	save_ports+=("$port")
	banner=$(echo "$request" | nc -v -n -w 1 "$ip_address" "$port" 2>&1) 

	server=$(echo "$banner" | grep -E "Server:" | tr " " "_")
	contentType=$(echo "$banner" | grep -E "Content-Type:" | tr " " "_")
	connection=$(echo "$banner" | grep -E "Connection:" | tr " " "_")
	http=$(echo "$banner" | grep -E "HTTP/" | tr " " "_")
	port_list+=(" Port $port | $GREEN$($BASE_PATH/scripts/getPortType.sh $port) ")
	data_list+=("$(echo "$server,$contentType,$connection" | tr -d "\r")")
done

echo "Done"
$BASE_PATH/scripts/print_ports.py 2 $YELLOW "${port_list[@]}" "${data_list[@]}"
#Save data to db
for i in "${!save_ports[@]}"; do
	$BASE_PATH/scripts/queries.py put service $ip_address ${save_ports[$i]} "$( echo ${data_list[$i]} | tr '_' ' ')"
done

# Links to external tools & scripts

# msf console?
# exploitdb?
# whatweb?
