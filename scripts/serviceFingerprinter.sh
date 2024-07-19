#!/bin/bash

#Usage statement for users
if [ -z "$1" ]; then
	echo "Usage $0 <ip_address>"
	exit 1
fi
ip_address=$1
banner=$(curl -s -i "$ip_address")
echo "$banner" | grep -i -E "Server|Last-Modified|ETag|Content-Type|X-|Date"
