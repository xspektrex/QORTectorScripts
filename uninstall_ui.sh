#!/bin/bash

# Check for color support
if [ -t 1 ]; then
	ncolors=$( tput colors )
	if [ -n "${ncolors}" -a "${ncolors}" -ge 8 ]; then
		if normal="$( tput sgr0 )"; then
			# Use terminfo names
			red="$( tput setaf 1 )"
			green="$( tput setaf 2)"
			yellow="$( tput setaf 3)"
			blue="$( tput setaf 4)"
			magenta="$( tput setaf 5)"
			cyan="$( tput setaf 6)"
			white="$( tput setaf 7)"
		else
			# Use termcap names for FreeBSD compat
			normal="$( tput me )"
			red="$( tput AF 1 )"
			green="$( tput AF 2)"
			yellow="$( tput AF 3)"
			blue="$( tput AF 4)"
			magenta="$( tput AF 5)"
			cyan="$( tput AF 6)"
			white="$( tput AF 7)"
		fi
	fi
fi

# For security reasons user shuld not run as root
echo ""
echo "Checking to ensure ${red}root${normal} user is not being utilized"
echo "and script was not called with ${red}sudo${normal} priveliges..."
sleep 2
echo ""

if [ "$_user" = "root" ]; then
	echo "${red}Root user login detected...${normal}"
	sleep 1
	echo "${red}Qoral-UI uninstall script for Linux will now exit, goodbye!${normal}"
	sleep 2
	echo ""

	# Exit under general error
	exit 1

elif [ "$SUDO_USER" != "" ]; then
	echo "${red}Script was called via sudo...${normal}"
	sleep 1
	echo "Qoral-UI uninstall script for Linux will now exit, goodbye!"
	sleep 2
	echo ""

	# Exit under general error
	exit 1

elif [ "$_user" != "root" ] && [ "$SUDO_USER" = "" ]; then

    # Small intro and declaration of versioning
    echo "==========================================================================="
    echo "        Qortal-UI uninstall script for Linux by ${cyan}HFactor${normal} (V4.0)        "
    echo "==========================================================================="
    echo ""
    sleep 2
    echo "This script will build the Qortal-UI from soruce and will require ${red}sudo${normal}"
    echo "privileges for one or more calls before script completion..."
    sleep 3
    echo "Please enter the appropriate password when asked to ${red}avoid${normal} permissions errors!"
    sleep 4
    echo ""

    # Disable mouse cursor
    tput civis

    echo "${green}Starting${normal} Qortal-UI removal via npm which may take a while...please be patient!"
    echo ""

    echo "${red}Stopping${normal} node.js if running..."
    killall -9 node
    echo ""

    # Uninstall and remove qortal-ui modules via npm
    echo "${red}Uninstalling${normal} Qortal-UI via npm..."
    cd qortal-ui
    sudo npm uninstall qortal-ui
    sudo npm rm qortal-ui
    cd ..
    echo ""

    echo "${red}Removing${normal} NPM and NodeJS"
    sudo apt purge -y nodejs
    sudo rm -rf /etc/apt/sources.list.d/nodesource.list
    sudo rm -rf /etc/apt/keyrings/nodesource.gpg
    echo ""

    echo "${green}Cleaning${normal} up nodeJS remnants..."
    sleep 1
    echo ""

    echo "${green}Cleaning${normal} up straggling files and directories..."
    rm -rf $PWD/.npm
    rm -rf $PWD/.node-gyp
    rm -rf $PWD/tmp/rollup-plugins-progress
    sleep 1
    echo ""

    echo "${green}Cleaning${normal} up APT..."
    sudo apt -y autoremove
    sudo apt clean
    echo ""

    echo "${red}Removing${normal} Qortal-UI folder stragglers if any..."
    rm -rf qortal-ui
    echo ""

    echo "${green}Qortal-UI has now been uninstalled, Goodbye!${normal}"

    # Re-enable mouse cursor
    tput cnorm

    # Read user typed key into "input" and return after reading 1 character (-n 1) without echoing to the term (-s)
    echo "Press ${cyan}q${normal} to exit!"
    while read -s -n 1 input; do
        case "${input}" in
            (q) break ;;
            (*) echo "${red}Invalid key pressed!${normal}" ;;
        esac
    done
fi
exit 0
