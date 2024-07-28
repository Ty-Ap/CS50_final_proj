#!/bin/bash

# Run config.sh
source config/config.sh

# Save relative path
export scriptPath="scripts"

# Initiate database
if [ ! -f $DB_FILE ]; then
	sqlite3 $DB_FILE ''
fi
sqlite3 $DB_FILE < scripts/init.sql

# Start welcome.sh
scripts/welcome.sh
