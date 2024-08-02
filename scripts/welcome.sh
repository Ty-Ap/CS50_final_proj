#!/bin/bash

# basically entirely D (thanks again for containing my chaos)

# Set input prompt
PS3="Select Option: "
while : ;do
	clear

	# Title
	scripts/format/center_asset.py assets/title.txt
	echo

	# Subtitle
	scripts/format/center_text.py "𝙸𝚗𝚝𝚞𝚒𝚝𝚒𝚟𝚎 𝚊𝚗𝚍 𝚎𝚛𝚐𝚘𝚗𝚘𝚖𝚒𝚌 𝚗𝚎𝚝𝚠𝚘𝚛𝚔 𝚜𝚗𝚘𝚘𝚙𝚒𝚗g"

	# Breakline
	print_line

	echo "Select a tool to start"

	#Get all tools from tools directory with .tool extension
	tools=($(ls tools | grep '\.tool$' | sed 's/\.tool$//g'))

	#Add default tools
	tools+=('Exit' 'SearchTargets')

	# Select tool
	select option in ${tools[@]}; do
		if [ "$option" = "Exit" ]; then 
			echo "Thank you for using DigIt ^_^"
			exit 0
		elif [ "$option" =  "SearchTargets" ]; then
			tool="scripts/searchTargets.pl"

		elif [ -f "tools/$option.tool" ]; then
			tool="tools/$option.tool"
		else
			echo "Invalid option $option"
			break
		fi
	
		# Determine usage of tool
		usage=$($tool)
		args=$(echo "$usage" | awk -F'[<>]' '{for(i=2;i<=NF;i+=2) print $i}' | tr '\n' ' ')
		
		# Prompt user for information based on that usage
		inputs=()
		for arg in $args; do
			read -r -p "$arg: " input
			inputs+=("$input")
		done
	
		#Run tool
		$tool "${inputs[@]}"

		break
	done

	echo -e "${RESTORE}Press$RED ENTER$RESTORE to continue"
	read
done
