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
declare -A parse_terms=(
	[Server]="Server:"
	[ContentType]="Content-Type:"
 	[Connection]="Connection:"
)

printarr() { declare -n __p="$1"; for k in "${!__p[@]}"; do printf "%s=%s\n" "$k" "${__p[$k]}" ; done ;  }

declare -A results=()
echo "Scanning..."

# Iterate through target ports
for port in ${ports[@]}; do
	
	# Reset Var
	whole_result=""
	
	# Get banner from target port
	banner=$(echo "$request" | nc -v -n -w 1 "$ip_address" "$port" 2>&1 | sed 's/\r//g')

	# Parse banner according to parse_term
	for key in ${!parse_terms[@]}; do
		output=$(echo "$banner" | grep -E "${parse_terms[$key]}" | xargs)
		results[$key]=$(echo $output | sed "s/${parse_terms[$key]}//" | xargs)
		whole_result+="$output,"
	done

	#Save stylized port for later
	port_list+=(" Port $port | $GREEN$($BASE_PATH/scripts/getPortType.sh $port) ")

	data_list+=("$whole_result")
	
	#Save data to db
	$BASE_PATH/scripts/queries.py --ip $ip_address --port $port  --server "${results['Server']}" --content_type "${results['ContentType']}" --connection "${results['Connection']}"
done

echo "Done"
echo "${data_list[@]}"
$BASE_PATH/scripts/print_ports.py 2 $YELLOW "${port_list[@]}" "${data_list[@]}"

# Links to external tools & scripts

# msf console?
# exploitdb?
# whatweb?
