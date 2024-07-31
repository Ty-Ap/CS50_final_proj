#!/bin/bash

#Some configurable settings
export titleColor='cyan'


#Store shared vars here

#Strings
export DB_FILE="data/database.db"

export SCAN_PORTS=" 80 443 "


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
	echo -ne $WHITE
	printf '%*s\n' "$width" '' | tr ' ' '='
	echo -ne $RESTORE
}
yes_or_no() {
        read -r -p "$* [Y/n]: " yn
        case $yn in
            [Yy]* | "") return 0  ;;  
            [Nn]* | *) echo "Aborted" ; return  1 ;;
        esac
}
display_asset() {
	cat  $scriptPath/../assets/$1
}
print_boxes() {
  local color_var=$1
  shift
  local texts=("$@")
  local color=${!color_var}

  # Print top borders
  for text in "${texts[@]}"; do
    local length=$( echo "$text" | sed -r 's/\\033\[[0-9;]*m//g' | wc -c )
    #echo -n $( echo $text | sed -r 's/\\033\[[0-9;]*m//g')
    echo -ne "${color}╔" && printf '═%.0s' $(seq 2 $length) && echo -n "╗ "
  done
  echo

  # Print text values
  for text in "${texts[@]}"; do
    echo -ne "║${text}$color║ "
  done
  echo

  # Print bottom borders
  for text in "${texts[@]}"; do
    local length=$( echo "$text" | sed -r 's/\\033\[[0-9;]*m//g' | wc -c )
    echo -ne "╚" && printf '═%.0s' $(seq 2 $length) && echo -ne "╝ "
  done
  echo -e $RESTORE
}

export -f print_line
export -f yes_or_no
export -f display_asset
export -f print_boxes


#Has config run?
export CONFIG=1


