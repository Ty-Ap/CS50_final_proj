#!/bin/bash

# basically entirely D (thanks again for containing my chaos)

PS3="Select Option: "
while : ;do
clear
cat assets/title.txt
echo "𝙸𝚗𝚝𝚞𝚒𝚝𝚒𝚟𝚎 𝚊𝚗𝚍 𝚎𝚛𝚐𝚘𝚗𝚘𝚖𝚒𝚌 𝚗𝚎𝚝𝚠𝚘𝚛𝚔 𝚜𝚗𝚘𝚘𝚙𝚒𝚗g"
print_line
echo "Select a tool to start"
select option in "IP Scrapper" "Port Mapper" "Service Fingerprinter" "Build Snooper" "Exit"; do
	case $option in
		"IP Scrapper")
			tool=scripts/IPScrapper.sh
			;;
		"Port Mapper")
			tool=scripts/portScanner.sh
			;;
		"Service Fingerprinter")
			tool=scripts/serviceFingerprinter.sh
			;;
		"Build Snooper")
			tool=scripts/techSnoop.sh
			;;
		Exit)
			echo "Thank you for using DigIt ^_^"
			exit 0
			;;	
		*)
			echo "Invalid option $option"
			tool=null
			;;
	esac
	

	if [ -f $tool ]; then

		#Determine usage of tool
		usage=$($tool)
		args=$(echo "$usage" | awk -F'[<>]' '{for(i=2;i<=NF;i+=2) print $i}' | tr '\n' ' ')
		
		#Prompt user for information based on that usage
		inputs=()
		for arg in $args; do
			read -r -p "$arg: " input
			inputs+=("$input")
		done

		#Run tool
		$tool "${inputs[@]}"
		elif [ "$tool" != "null" ]; then
			echo "Error: Cannot find tool at $tool."
	fi
		
	read -r -p "Press ENTER to continue"
	break
done
done
