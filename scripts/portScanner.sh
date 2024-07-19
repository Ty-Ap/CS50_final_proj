#!/bin/bash

#Usage statement
if [ -z "$1" ]; then
  echo "usage $0 <ip_address>"
  exit 1 
fi

ports=$SCAN_PORTS

#Map ports
for port in $ports; 
  do nc -zv -w 2 $1 $port
    if [ $? -eq 0 ]; then
      echo "port $port is open"
    else 
      echo "port $port is closed or filtered"
    fi
done
echo "Thank you for using Dig It ^_^"
