#!/bin/bash

ip_address=$1
port=$2
user_agent="Mozilla/5.0 (compatible; Fingerprinter/1.0)"
request="HEAD / HTTP/1.1\r\nHost: $ip_address\r\nUser-Agent: $user_agent\r\nConnection: close\r\n\r\n"
banner=$(echo "$request" | nc -v -n -w 1 "$ip_address" "$port" 2>&1 )

echo "Port: $port"
echo "$banner" | grep -E "HTTP/|Server:|Content-Type:|Date:|Connection:|Content-Length:"