#!/bin/bash

#Store shared vars here
export DB_FILE="data/database.db"

export SCAN_PORTS="1 2 4 6 7 13 17 19 26 30 32 33 37 42 43 49 53 70 79 85 88 90 99 106 113 119 143 144 146 161 163 400 443"

print_line() {
	width=$(tput cols)
	printf '%*s\n' "$width" '' | tr ' ' '='
}

export -f print_line



