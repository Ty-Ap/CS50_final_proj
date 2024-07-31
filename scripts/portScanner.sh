#!/bin/bash

# initialized by TY , modularized and refactored by D

# Usage statement
if [ -z "$1" ]; then
  echo "usage $0 <ip_address>"
  exit 1 
fi

# Config check
if [ -z $CONFIG ]; then
	echo "Command executed standalone: Running config"
	export scriptPath=$(dirname $0)
	echo "path:$scriptPath"
	source $scriptPath/../config/config.sh
fi

# Var definitions
ports=$SCAN_PORTS
ip_address=$1
open_ports=()
declare -A port_map
port_map[21]="ftp"
port_map[22]="ssh"
prot_map[23]="telnet"
port_map[25]="smtp"
port_map[80]="http"
port_map[161]="snmp"
port_map[389]="ldap"
port_map[443]="https"
port_map[445]="smb"
port_map[3389]="rdp"

# Program

clear

for port in $ports; do
  if nc -z -w 1 "$ip_address" "$port" &> /dev/null; then
    detailed_ports+=(" Port $port | $GREEN${port_map[$port]} ")
    open_ports+=("$port")
  fi
done

# No open ports found
if [ ${#open_ports[@]} -eq 0 ]; then
  echo -e "${RED}No ports found:$RESTORE ip may be invalid, target may not be currently up, or no ports are open at the moment"
  exit 1
fi

# Ports found
echo -e "$GREEN${#open_ports[@]} ports$RESTORE found at $ip_address:"

#WARNING: targets with many ports may break this, add wrapping?
print_boxes YELLOW "${detailed_ports[@]}"

#Save data to db
for port in ${open_ports[@]}; do
	$scriptPath/queries.py put map $ip_address $port
done
# Links to external tools & scripts
if yes_or_no "Would you like to get a service fingerprint of open ports?"; then
     $scriptPath/serviceFingerprinter.sh "$ip_address" ${open_ports[@]}
fi
