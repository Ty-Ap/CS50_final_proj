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

# Program
for port in $ports; do
  if nc -z -w 1 "$ip_address" "$port" &> /dev/null; then
      echo "port $port is open"
      open_ports+=("$port")
  fi
done

#Save data to db
for port in ${open_ports[@]}; do
	$scriptPath/queries.py put map $ip_address $port
done
# Links to external tools & scripts
if yes_or_no "Would you like to get a service fingerprint of open ports?"; then
  for oport in "${open_ports[@]}"; do
     echo "fingerprinting port $oport"
     $scriptPath/serviceFingerprinter.sh "$ip_address" "$oport"
  done
fi
