#!/bin/bash

#Usage statement
if [ -z "$1" ]; then
  echo "usage $0 <ip_address>"
  exit 1 
fi

ports=$SCAN_PORTS
ip_address=$1

#Map ports
for port in $ports; 
  do nc -zv -w 2 $ip_address $port
    if [ $? -eq 0 ]; then
      echo "port $port is open"
    else 
      echo "port $port is closed or filtered"
    fi
done

if yes_or_no "Would you like to get a service fingerprint of open ports?"; then
	scripts/serviceFingerprinter.sh $ip_address
fi
