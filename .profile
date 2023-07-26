# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

#printf '%b' '\e]12;red\a'
# disable line wrapping so login/system details don't wrap
setterm -linewrap off

# Check for color support and declare colors
if [ -t 1 ]; then
	ncolors=$( tput colors )
	if [ -n "${ncolors}" -a "${ncolors}" -ge 8 ]; then
		if normal="$( tput sgr0 )"; then
			# Use terminfo names
			red="$( tput setaf 1 )"
			redbg="$( tput setab 1 )"
			green="$( tput setaf 2)"
			greenbg="$( tput setab 2)"
			yellow="$( tput setaf 3)"
			yellowbg="$( tput setab 3)"
			blue="$( tput setaf 4)"
			bluebg="$( tput setab 4)"
			magenta="$( tput setaf 5)"
			magentabg="$( tput setab 5)"
			cyan="$( tput setaf 6)"
			cyanbg="$( tput setab 6)"
			white="$( tput setaf 7)"
			whitebg="$( tput setab 7)"
		else
			# Use termcap names for FreeBSD compat
			normal="$( tput me )"
			red="$( tput AF 1 )"
			redbg="$( tput AB 1 )"
			green="$( tput AF 2)"
			greenbg="$( tput AB 2)"
			yellow="$( tput AF 3)"
			yellowbg="$( tput AB 3)"
			blue="$( tput AF 4)"
			bluebg="$( tput AB 4)"
			magenta="$( tput AF 5)"
			magentabg="$( tput AB 5)"
			cyan="$( tput AF 6)"
			cyanbg="$( tput AB 6)"
			white="$( tput AF 7)"
			whitebg="$( tput AB 7)"
		fi
	fi
fi

# Set the colors of PS1 (Prompt String One (first line seen)) via preset term colors - background + foreground: \e[32;47m
export PS1="\[${yellow}\][\[${red}\]\u\[${yellow}\]@\[${green}\]\h\[${white}\]:\[${cyan}\]\w\[${yellow}\]]\[${white}\]\$ "

# get uptime seconds, mins, hours, days
let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let upDays="$((${upSeconds}/86400))"
let upHours="$(((${upSeconds}%86400)/3600))"
let upMins="$(((${upSeconds}%3600)/60))"
let upSecs="$((${upSeconds}%60))"

UPTIME=$(printf "%d days, %02d hours, %02d minutes and %02d seconds" "$upDays" "$upHours" "$upMins" "$upSecs")

# get the load averages from standard input
read one five fifteen rest < /proc/loadavg

echo -e "\n${cyan}=====================================================================================${normal}\n"

# output uptime calculations, memory/load values, etc... to terminal window
echo "${magenta}Uptime.............: ${UPTIME}"
echo "Memory Usage.......: $(free | grep Mem | awk '{print $3/1024}') MB (Used) out of $(cat /proc/meminfo | grep MemTotal | awk '{print $2/1024}') MB (Total)"
echo "Load Averages......: ${one}, ${five}, ${fifteen} (1, 5, 15 min)"
echo "Running Processes..: $(ps ax | wc -l | tr -d " ")"
echo "IP Addresses.......: $(hostname -I | /usr/bin/cut -d " " -f 1) (internal) and $(wget -q -O - https://icanhazip.com/ | tail)(external)${normal}"

# output current date/time to terminal window
#echo "$(tput setaf 3)Today is: $(date +'%A, %e %B %Y, %r')"
echo -e "\n${yellow}Today is: $(date +'%A, %e %B %Y, %r')"

echo -e "\n${cyan}=====================================================================================${normal}\n\n"

# re-enable line wrapping
setterm -linewrap on
