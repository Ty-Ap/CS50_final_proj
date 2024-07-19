#!/bin/bash

# Run config.sh
source config/config.sh

# Initiate database
if [ ! -f $DB_FILE ]; then
	sqlite3 $DB_FILE < scripts/init.sql
fi

# Start welcome.sh
scripts/welcome.sh
