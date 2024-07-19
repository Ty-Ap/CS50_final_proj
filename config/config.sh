#!/bin/bash

#Store shared vars here
export DB_FILE="data/database.db"

export SCAN_PORTS=" 80 443 "

print_line() {
	width=$(tput cols)
	printf '%*s\n' "$width" '' | tr ' ' '='
}
yes_or_no() {
        read -p "$* [Y/n]: " yn
        case $yn in
            [Yy]* | "") return 0  ;;  
            [Nn]* | *) echo "Aborted" ; return  1 ;;
        esac
}

export -f print_line
export -f yes_or_no



