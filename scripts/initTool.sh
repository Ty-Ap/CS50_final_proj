#!/bin/bash
# Usage statement
if [ -z "$2" ]; then
	echo "$1"
	exit 1
fi

# Config check
if [ -z $CONFIG ]; then
	echo "Command executed standalone: Running config"
	export scriptPath=$(dirname $0)
	source $scriptPath/../config/config.sh
fi

