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
	echo "${red}Qoral-UI update/install script for Linux will now exit, goodbye!${normal}"
	sleep 2
	echo ""

	# Exit under general error
	exit 1

elif [ "$SUDO_USER" != "" ]; then
	echo "${red}Script was called via sudo...${normal}"
	sleep 1
	echo "Qoral-UI update/install script for Linux will now exit, goodbye!"
	sleep 2
	echo ""

	# Exit under general error
	exit 1

elif [ "$_user" != "root" ] && [ "$SUDO_USER" = "" ]; then

    # Small intro and declaration of versioning
    echo "==========================================================================="
    echo "        Qortal-UI update/install script for Linux by ${cyan}HFactor${normal} (V4.0)        "
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

    echo "${green}Installing${normal} curl if not already installed..."
    sudo apt install curl -y
    echo ""
    sleep 2

    echo "${green}Installing${normal} git if not already installed..."
    sudo apt install git -y
    echo ""
    sleep 2

    echo "${red}Stopping${normal} node.js if running...ID10T preventive..."
    sudo killall -9 node*
    echo ""
    sleep 2

    echo "${green}Installing${normal} nodeJS from NodeSource repository which will update with ""apt update""..."
    sleep 2
    echo "Downloading and importing the Nodesource GPG key..."
    sleep 2
    sudo apt-get install -y ca-certificates curl gnupg
    echo N | sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo ""
    sleep 2

    echo "Creating deb repository..."
    sleep 1
    NODE_MAJOR=20
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    echo ""
    sleep 2

    echo "Updating APT repository since nodesource has been added..."
    sudo apt update
	echo ""
	sleep 2

    echo "Updating APT repository since nodesource has been added..."
    sudo apt install -y nodejs
    echo ""
    sleep 2

    echo "${red}Disabling${normal} npm ""funding"" message/s..."
    npm config set fund false
    echo ""
    sleep 2

    echo "${red}Removing${normal} old Qortal-UI files if any..."
    rm -rf qortal-ui
    echo ""
    sleep 2

    echo "${green}Cloning${normal} git repositories for Qortal-UI"
    sleep 1
    git clone https://github.com/qortal/qortal-ui.git
    echo ""
    sleep 2

    cd qortal-ui

    # Install dependencies and call "install" from package.json "scripts" field as currently logged in user (non sudo)
    echo "${green}Starting${normal} build process for Qortal-UI via npm which may take a while..."
    sleep 1
    npm install
    echo ""
    sleep 2

    # Run "build" field from the package.json "scripts" field as currently logged in user (non sudo)
    echo "${green}Starting${normal} build process for Qortal-UI server which may take a while..."
    sleep 1
    npm run build
    echo ""
    sleep 2

    echo "${green}BUILD COMPLETE! You can now make use of the new UI!${normal}"
    echo ""
    sleep 2

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
