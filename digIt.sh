#!/bin/bash

print_line() {
  width=$(tput cols)
  printf '%*s\n' "$width" '' | tr ' ' '='
}


if [ -z "$1" ]; then
  echo "usage $0 <domain_name>"
  exit 1 
fi

ip_address=$(dig +short "$1")

if [ -z "$ip_address" ]; then 
  echo "unable to resolve $1 ip"
else 
  clear
  echo "IP address for $1 follows"
  print_line
  echo "$ip_address"
fi


