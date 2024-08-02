#!/bin/bash

# Run config.sh
source config/config.sh

# Initiate database
if [ ! -f $DB_FILE ]; then
	sqlite3 $DB_FILE ''
fi
sqlite3 $DB_FILE < scripts/init.sql

#Modify some assets ;)
./scripts/format/colorize.py assets/default-title.txt assets/title.txt black=█ $titleColor=╗╝═╔║╚░

# Start welcome.sh
scripts/welcome.sh
