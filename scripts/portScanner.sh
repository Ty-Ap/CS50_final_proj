#!/bin/bash

# initialized by TY , modularized and refactored by D

#Usage statement
if [ -z "$1" ]; then
  echo "usage $0 <ip_address>"
  exit 1 
fi

ports=$SCAN_PORTS
ip_address=$1
open_ports=()
#Map ports
for port in $ports; do
  if nc -z -w 1 "$ip_address" "$port" &> /dev/null; then
      echo "port $port is open"
      open_ports+=("$port")
    fi
done

if yes_or_no "Would you like to get a service fingerprint of open ports?"; then
  for oport in "${open_ports[@]}"; 
    do echo "fingerprinting port $oport"
    scripts/serviceFingerprinter.sh "$ip_address" "$oport"
  done
fi
