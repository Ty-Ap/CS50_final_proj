#!/bin/bash

#Store shared vars here

#Strings
export DB_FILE="data/database.db"

export SCAN_PORTS="1 2 4 6 7 13 17 19 26 30 32 33 37 42 43 49 53 70 79 85 88 90 99 106 113 119 143 144 146 161 163 400 443"

#Colors
export RESTORE='\033[0m'

export RED='\033[00;31m'
export GREEN='\033[00;32m'
export YELLOW='\033[00;33m'
export BLUE='\033[00;34m'
export PURPLE='\033[00;35m'
export CYAN='\033[00;36m'
export LIGHTGRAY='\033[00;37m'

export LRED='\033[01;31m'
export LGREEN='\033[01;32m'
export LYELLOW='\033[01;33m'
export LBLUE='\033[01;34m'
export LPURPLE='\033[01;35m'
export LCYAN='\033[01;36m'
export WHITE='\033[01;37m'


#Functions
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



#Has config run?
export config=true


