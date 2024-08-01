#!/bin/bash

# initialized by TY , modularized and refactored by D

#Init code
source $(dirname $0)/initTool.sh "Usage $0 <ip_address>" $@

# Var definitions
ports=$SCAN_PORTS
ip_address=$1
open_ports=()

# Program

clear

for port in $ports; do
  if nc -z -w 1 "$ip_address" "$port" &> /dev/null; then
	  detailed_ports+=(" Port $port | $GREEN$( $scriptPath/getPortType.sh $port) ")
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
print
$scriptPath/print_ports.py ${#open_ports[@]} $YELLOW "${detailed_ports[@]}" 

#Save data to db
for port in ${open_ports[@]}; do
	$scriptPath/queries.py put map $ip_address $port
done
# Links to external tools & scripts
if yes_or_no "Would you like to get a service fingerprint of open ports?"; then
     $scriptPath/serviceFingerprinter.sh "$ip_address" ${open_ports[@]}
fi
