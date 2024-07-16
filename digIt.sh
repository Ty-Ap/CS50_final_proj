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
ports=(1 2 4 6 7 13 17 19 26 30 32 33 37 42 43 49 53 70 79 85 88 90 99 106 113 119 143 144 146 161 163 400 443)

if [ -z "$ip_address" ]; then 
  echo "unable to resolve $1 ip"
else 
  clear
  echo "IP address for $1 follows"
  print_line
  echo ".= = = = =. "
  echo "|         | "
  echo "|         | "
  echo " - - - - -  "
  echo "   | . |    "
  echo "   | . |    " 
  echo "   | . |    "
  echo "   | . |    " 
  echo "   | . |    "
  echo "   | . |    "
  echo ".- - - - -. "
  echo "|    |    | "
  echo " \   |   /  "
  echo "  \  |  /   "
  echo "   \ _ /    "
  echo "    \_/     "

  echo "$ip_address"
  print_line
  for port in "${ports[@]}"; 
    do nc -zv -w 2 $ip_address $port
      if [ $? -eq 0 ]; then
        echo "port $port is open"
      else 
        echo "port $port is closed or filtered"
      fi
  done
  echo "Thank you for using Dig It ^_^"
fi
