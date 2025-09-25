#!/bin/bash

# Disable mouse cursor for user input
tput civis

# Variable to store core directory
cd ~/qortal
_core="$(pwd)"

# Variable to store processID file Location
_runFileLoc="${_core}/run.pid"

# Vriable to track the existence of the pid runfile
_runFileExists="false"

# Variable to store run.pid read in processID of core instance
_runFileText=""

# Variable to store detected processID of core instance
_runProcText=""

# Variable to store apikey.txt file Location
_apiFileLoc="${_core}/apikey.txt"

# Variable to track the existence of the apikey.txt file
_apiFileExists="false"

# Variable to store the read in apikey value
_apiFileText=""

# Variable to store current API port
_apiPort=12391

# Variable to track api availability
_apiReachable="false"

# Variable to store service name for core
_service="java"

# Variable to store if core is running
_coreRunning="false"

# Variable to store current user
_user=$(id -un)

# Variable to store user defined restart interval
_timeInterval=$2

# Variable to store validation of user input
_timeIntervalValidated="false"

# Variable to store screen app utilization
_useScreen=$1

# Variable to store location of restart script log file
# determined by parameter expansion
_tmpLog=${0%.*}
_restartLog="${_tmpLog##*/}.log"

# ====== Function declarations Begin ======
#
# Function to check/set user colors of console for various purposes
color_check () {

	if [[ -t 1 ]]; then

		_ncolors=$( tput colors ) #256

		if [[ ( -n "${_ncolors}" ) && (( ${_ncolors} -ge 8 )) ]]; then	

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
}

# Function to log passed input to pre-defined file and replace any color formatting code
# as it won't show correctly in a file
logging() {

    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${_restartLog}"
}

# Function to listen for and store user requested input
# E.g. yes (y) or no (n)
it_listens () {
    
    # Enable mouse cursor for user input
    tput cnorm

    while read -n 1 input; do
        case "${input}" in
            (y) echo; _useScreen="yes"; break;;
            (n) echo; _useScreen="no"; break;;
            (*) echo; echo -n "${red}Invalid answer chosen please retry!: ${normal}";input=;;
        esac
    done

    # Disable mouse cursor for user input
    tput civis
}

# Function to listen for and store user requested input
# E.g. 60s or 1m or 1h or 1d etc...
it_listens2 () {   

    #Enable mouse cursor for user input
    tput cnorm

    while read -r -N 1 input; do
        _timeInterval+="${input}"
        case "${input}" in
            ([0-9]);;
            (s) break ;;
            (m) break ;;
            (h) break ;;
            (d) break ;;
            (*) echo; echo -n "${red}Invalid unit of time chosen please retry!: ${normal}"; _timeInterval=;;
        esac
    done

    # Disable mouse cursor for user input
    tput civis
}

# Function to validate user input for time interval via regex
# User should not be able to continue if user only entered s,m,h,d
time_interval_validator () {

    if [[ "${_timeInterval}" =~ [0-9]+[smhd]{1} ]]; then  

        _timeIntervalValidated="true";

    else

        echo -e "Invalid restart interval ${red}${_timeInterval}${normal} was keyed; please try again!"
        logging "Invalid restart interval ${_timeInterval} was keyed; please try again!\n"
        
        # Set time interval to nothing as we failed validation
        _timeInterval="";
        echo

    fi
}

# Function to resize terminal window if xterm resize installed
# Generally not available on container instances by default
resize_check () {

    # Check resize installation path via which
    _resizePath=$(which resize)

    # If destination of _resizePath exists resize is installed
    # so resize the terminal screen
    if [[ -e "$(which resize)" ]]; then

        resize -s 24 88
        
    fi
}

# Function to check if lsof is installed for port checks
# Generally not available on container instances by default
lsof_check () {

    # Check lsof installation path via which
	_lsofPath=$(which lsof)

    # If destination of _lsofPath exists lsof is installed, return 0
    # Else return 1 
    if [[ -e "${_lsofPath}" ]]; then

        return 0

    else    

        return 1

    fi
}

# Function to check if curl is installed for data transfers between servers
# Generally not available on caontainer instances by default
curl_check () {

	# Check curl installation path via which
	_curlPath=$(which curl)

    # If destination of _curlPath exists curl is installed, return 0
    # Else return 1
	if [[ -e "${_curlPath}" ]]; then

		return 0

	else

		return 1

	fi
}

# Function to check if screen is installed for terminal multiplexing (multiple instances)
screen_check () {

	# Check screen installation path via which
	_screenPath=$(which screen)

    # If destination of _screenPath exists screen is installed, return 0
    # Else return 1
	if [[ -e "${_screenPath}" ]]; then

		return 0

	else

		return 1

	fi
}

# Function to read in the pid of the located runfile
core_runfile_check () {

    # If destination of _runFileLoc exists continue
    # Else create missing run.pid file
    if [[ -e "${_runFileLoc}" ]]; then

        # Set _runFileExists flag
        _runFileExists="true"
        
        # Read content of run/pid into variable using input redirection operator
        _runFileText=$(<"${_runFileLoc}")
        
    else

        # Unset _runFileExists flag
        _runFileExists="false"
        
        # Create empty run.pid file
        echo "" > "${_runFileLoc}"

    fi
}

# Function to check for running instance of Core via process stauts search command
# for the current namespace and obtain the processID
# Current user only to protect any containers running the core as applications
# such as docker/podman launch processes in a seperate namespace
core_processid_check () {

	#_runProcText=$(ps aux | grep [qortal.jar | awk '{print $2}')  not considerate of container instances
	_runProcText=$(pgrep -U "${_user}" -n "${_service}")

    # If _runProcText is not zero-length continue
	if [[ -n "${_runProcText}" ]]; then

        # Set _coreRunning flag
	    _coreRunning="true"

	else

	    # Unset _coreRunning flag
	    _coreRunning="false"

	fi
}

# Function to check the process status processID against the run.pid processID
# If not equal then processId takes precidence and is pushed into variable _runFileText
# Protection against the run.pid being deleted or manipulated after start script
processid_validation () { 
        
    # If _runFileExists destination exists and _runProcText is not zero-length continue
    if [[ -f "${_runFileExists}" && -n "${_runProcText}" ]]; then
   
        # If run.pid value not equal to java processID value then update run.pid
        if [[ "${_runFileText}" -ne "${_runProcText}" ]]; then  
                    
            # Clear run.pid file (ID10T preventive)
            echo "" > "${_runFileLoc}"
            
            # Save java processID to run.pid (overwrites)
            echo "${_runProcText}" > "${_runFileLoc}"

        fi
    fi  
}

# Function to check for the existence of the apikey.txt file and read it
# into the variable _apiText
apikey_check () {

    # If _apiFileLoc destination exists continue
    # Else unset _apiFileExists flag
    if [[ -e "${_apiFileLoc}" ]]; then

        # Set _apiFileExists flag
        _apiFileExists="true"
        
        # Read content of apikey.txt into variable using input redirection operator
        _apiFileText=$(<"${_apiFileLoc}")

    else

        # Unset _apiFileExists flag
        _apiFileExists="false"

    fi
}

# Function to wait for the core to start listening on port 12391
lets_start_loop () {

    # While command substitution result is zero-length loop
	while [ -z $( lsof -nP -u "${_user}" -iTCP:"${_apiPort}" -sTCP:LISTEN -a -t) ]; do

		printf "${yellow}.${normal}"
		sleep 1.5

	done
	
    # Set _apiReachable flag
	_apiReachable="true"
}

# Function to wait for core to stop listening on port 12391
# which will stop checking at 30 seconds as core should 
# stop before 30 seconds
lets_stop_loop () {

    # Implement integer variable that can be incremented
    declare -i _ticker=0
    
    # While command substitution result is nonzero loop (api is still running)
	while [ -n $( lsof -nP -u ${_user} -iTCP:${_apiPort} -sTCP:LISTEN -a -t ) ]; 
	do

        # If increment variable not equal to 30 continue
		if [[ ${_ticker} -ne 30 ]]; then

            # Increment ticker
		    (( _ticker+=1 ))

		    printf "${yellow}.${normal}"
		    sleep 1

	    fi

	    # If the command substitution result is zero-length the api has closed
        # Secondary check to set required flags before next loop iteration
	    if [[ -z $( lsof -nP -u ${_user} -iTCP:${_apiPort} -sTCP:LISTEN -a -t ) ]]; then

            # Unset _apiReachable flag
            _apiReachable="false"

            # Break from if clause and while loop
            break

        else

            # Set _apiReachable flag
            _apiReachable="true"

	    fi
	done
	
    # Set ticker variable back to 0
	_ticker=0
	
    # While command substitution result is nonzero loop (core is still running)
	# Core process shutdown isn't always instant
	while [[ -n $( pgrep -U ${_user} -n ${_service} ) ]]; do

        # If increment variable not equal to 30 continue
		if [[ ${_ticker} -ne 30 ]]; then

            # Increment ticker
	        (( _ticker+=1 ))

	        printf "${yellow}.${normal}"
	        sleep 1

	    fi

	    # If the command substitution result is zero-length the core has shutdown
        # Secondary check to set required flags before next loop iteration
	    if [[ -z $( pgrep -U ${_user} -n ${_service} ) ]] ; then

            # Unset _apiReachable flag
	        _coreRunning="false"

            # Break from if clause and while loop
	        break

	    else
            # Set _apiReachable flag
	        _coreRunning="true"

	    fi
	done
}

# Function to remove instance files generated by scripted core start and db activity
# which would otherwise cause new core instance startup problems
core_file_cleanup () {

	    # If the file at destinations _runFileLoc and _core/.. exists continue
	    if [[ -f "${_runFileLoc}" && -e "${_core}/db/blockchain.lck" ]]; then

    	    echo -e "${yellow}Removing 'run.pid' file, please wait...${normal}"
            logging "Removing 'run.pid' file, please wait..."
    	    
            # Remove file at destination _runFileLoc
	        rm -rf "${_runFileLoc}"

	        sleep .5

            echo -e "${yellow}Removing blockchain.lck file, please wait...${normal}\n"
            logging "Removing blockchain.lck file, please wait...\n"

            # Remove file at destination _core/..
            rm -rf "${_core}/db/blockchain.lck"
            sleep .5

	    fi

        # If the file at destination _runFileLoc exists only continue
	    if [[ -f "${_runFileLoc}" && ! -e "${_core}/db/blockchain.lck" ]]; then

    	    echo -e "${yellow}Removing 'run.pid' file, please wait...${normal}\n"
            logging "Removing 'run.pid' file, please wait...\n"
    	    
            # Remove file at destination _runFileLoc
	        rm -rf "${_runFileLoc}"

	        sleep .5

	    fi

        # If the file at destination _core/.. exists only continue
	    if [[ ! -f "${_runFileLoc}" && -e "${_core}/db/blockchain.lck" ]]; then

            echo -e "${yellow}Removing blockchain.lck file, please wait...${normal}\n"
            logging "Removing blockchain.lck file, please wait...\n"

            # Remove file at destination _core/..
            rm -rf "${_core}/db/blockchain.lck"

            sleep .5

	    fi
        
        # Insert space in log file after core shutdown and for next core run
        echo "" >> "${_core}/${_restartLog}"

        # Insert space in terminal window after core shutdown for next core run
        echo ""
}

# Function to load the core and write processID to file
start_core () {

    # Validate Java is installed and the minimum version is available
    MIN_JAVA_VER='11'

    if command -v java > /dev/null 2>&1; then

        # Example: openjdk version "11.0.6" 2020-01-14
        version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1,2)
        
        if ! echo "${version}" "${MIN_JAVA_VER}" | awk '{ if ($2 > 0 && $1 >= $2) exit 0; else exit 1}'; then

            #echo 'Passed Java version check'
            echo -e "Please upgrade your Java to version ${MIN_JAVA_VER} or greater!\n"
            logging "Please upgrade your Java to version ${MIN_JAVA_VER} or greater!\n"
            
	        # Call function to exist restart script under status 1
	        we_outtie 1

        fi

    else

      echo -e "Java is not available, please install Java ${MIN_JAVA_VER} or greater!\n"
      logging "Java is not available, please install Java ${MIN_JAVA_VER} or greater!\n"
      
        # Call function to exist restart script under status 1
        we_outtie 1

    fi

    # No qortal.jar but we have a Maven built one?
    # Be helpful and copy across to correct location
    if [ ! -e qortal.jar -a -f target/qortal*.jar ]; then

	    echo "Copying Maven-built Qortal JAR to correct pathname"
	    logging "Copying Maven-built Qortal JAR to correct pathname"
	    cp target/qortal*.jar qortal.jar
        
    fi

	# Limits Java JVM stack size and maximum heap usage.
	# Comment out for bigger systems, e.g. non-routers or when API documentation is enabled
	# JVM_MEMORY_ARGS="-Xss256k -Xmx128m"

	# Although java.net.preferIPv4Stack is supposed to be false by default in Java 11, on some platforms 
    # (e.g. FreeBSD 12), it is overridden to be true by default. Hence we explicitly set it to false 
    # to obtain desired behaviour.
	cd "$_core"
	nohup nice -n 20 java \
	-Djava.net.preferIPv4Stack=false \
	${JVM_MEMORY_ARGS} \
	-jar qortal.jar \
	1>run.log 2>&1 &

	# Save backgrounded processID
	#_runProcText=$(ps aux | grep [qortal.jar | awk '{print $2}')  not considerate of container instances
	_runProcText=$(pgrep -U "${_user}" -n "${_service}")
	echo "${_runProcText}" > "${_runFileLoc}"

}

# Function to stop the core gracefully via api then forcefully via kill if needed
api_stop_core () {

    echo -E "Attempting to gracefully shutdown Qortal ${cyan}core${normal} via api..."
    logging "Attempting to gracefully shutdown Qortal core via api..."
    sleep .5

    # Call function to check for the existence of the apikey.txt file and read 
    # it's value into a variable
    apikey_check

    # 
    if [[ ${_apiFileExists} == "true" ]]; then

        if [[ $(curl -s --url "http://localhost:"${_apiPort}"/admin/stop?apiKey=${_apiFileText}") ]]; then

            echo -e "${green}Qortal core responded to shutdown request on procID "${_runFileText}"${normal}\n"
            logging "Qortal core responded to shutdown request on procID ${_runFileText}\n"

            printf "Monitoring for Qortal ${cyan}core${normal} to shutdown, ${yellow}please wait${normal}"
            logging "Monitoring for Qortal core to shutdown, please wait..."

            # Call function to loop until api port and core is shutdown 
            lets_stop_loop
            
            # Call function to check for running processId
            core_processid_check

            # Call function to check if run.pid contains data
            core_runfile_check
            
            # Call function to compare run.pid to java process pid which should be equal
            # If not equal then processId takes precidence and is pushed into variable _runFileText
            processid_validation
                                
            # If core still running api shutdown was a failure
            # Else api call was success
            if [[ "${_coreRunning}" == "true" ]]; then

                echo -e "\n${red}Qortal core failed to be gracefully shutdown by api call!${normal}\n"
                logging "Qortal core failed to be gracefully shutdown by api call!\n"
                sleep .5
                
                # Attempt graceful shutdown by SIGKILL via processID
                echo -E "Attempting to gracefully kill Qortal ${cyan}core${normal} with SIGKILL..."
                logging "Attempting to gracefully kill Qortal core with SIGKILL..."
                
                # Call to function to sequentially perform sigkill then sigterm
                sigterm_stop_core
                
            else

                echo -e "\n${green}Qortal core gracefully shutdown via api call!${normal}\n"
                logging "Qortal core gracefully shutdown via api call!\n"
                sleep .5
                
                # Call function to cleanup core/db blocking files
                core_file_cleanup
            fi

        else

            echo -e "${red}Qortal core failed to be gracefully shutdown by api call!${normal}\n"
            logging "Qortal core failed to be gracefully shutdown by api call!\n"
            sleep .5
            
            # Attempt graceful shutdown by SIGKILL via processID
            echo "Attempting to gracefully kill Qortal ${cyan}core${normal} with SIGKILL..."
            logging "Attempting to gracefully kill Qortal core with SIGKILL..."

            # Call to function to sequentially perform sigkill then sigterm
            sigterm_stop_core
        fi

    else

        echo -e "${red}Unable to request graceful shutdown via API call due to missing apikey.txt file!${normal}\n"
        logging "Unable to request graceful shutdown via API call due to missing apikey.txt file!\n"
        sleep .5
        
        # Attempt graceful shutdown by SIGKILL via processID
        echo -E "Attempting to gracefully kill Qortal ${cyan}core${normal} with SIGKILL..."
        logging "Attempting to gracefully kill Qortal core with SIGKILL..."

        # Call to function to sequentially perform sigkill then sigterm
        sigterm_stop_core
    
    fi
}

# Function to stop the core gracefully via sigkill or forcefully via sigterm
sigterm_stop_core () {

    # If command substitution succeeds then check last command status via $? to continue
    if [[ $(kill -15 "${_runFileText}" >/dev/null) || $? -eq 0 ]]; then    

        echo -e "${green}Qortal core gracefully killed by SIGKILL!${normal}\n"
        logging "Qortal core gracefully killed by SIGKILL!\n"
        sleep .5
        
        # Call function to cleanup core/db blocking files
        core_file_cleanup
           
    else

        echo -e "${red}Qortal core failed to be gracefully shutdown by SIGTKILL!${normal}\n"
        logging "Qortal core failed to be gracefully shutdown by SIGKILL!\n"
        sleep .5
        
        # Attempt forceful shutdown by SIGTERM via processID
        echo "Attempting to forcefully kill Qortal ${cyan}core${normal} via SIGTERM..."
        logging "Attempting to forcefully kill Qortal core via SIGTERM..."

        # If kill command succeeds in sub-window then check last command status via $? to continue
        if [[ $(kill -9 "${_runFileText}" > /dev/null) || $? -eq 0 ]]; then
	        echo -e "${green}Qortal core forcefully killed by SIGTERM!${normal}\n"
	        logging "Qortal core forcefully killed by SIGTERM!\n"
	        sleep .5
	        
            # Call function to cleanup core/db blocking files
            core_file_cleanup

        else

	        echo -e "${red}Qortal core unable to be shutdown by api and graceful/forced SIGTERM...${normal}\n"
	        logging "Qortal core unable to be shutdown by api and graceful/forced SIGTERM...\n"
	        sleep 1
	        echo "Please attempt to shutdown/kill Qortal ${cyan}core${normal} via System Monitor!"
	        logging "Please attempt to shutdown/kill Qortal core via system monitor!"
	        sleep 1
	        echo -e "${yellow}This script will now exit to prevent duplicate calls to core jar!${normal}\n"
	        logging "This script will now exit to prevent duplicate calls to core jar!\n"
	        
	        # Call function to exist restart script under status 1
	        we_outtie 1
        fi
    fi
}

# Function to exit core restart script
we_outtie () {

    # If _useScreen flag not set 
    if [[ "${_useScreen}" != "yes" ]]; then

        echo "Qortal ${cyan}core${normal} auto-restart script will now exit..."
        logging "Qortal core auto-restart script will now exit..."
        sleep .5
        echo -e "${cyan}Goodbye!${normal}\n"
        logging "Goodbye!\n"
        sleep .5

    fi

    # Enable mouse cursor
	tput cnorm
    
    # If first argument passed to we_outtie is 0 exit with no errors
    # Else if the first argument passed to we_outtie is 1 exit with errors
    # Else exist with no errors
	if [[ $1 -eq 0 ]]; then

		# Exit under status 0 (no errors)
		exit 0

	elif [[ $1 -eq 1 ]]; then

		# Exit under status 1 (errors)
		exit 1

	else

		# Exit under status 0 (no errors)
		exit 0

	fi
}
# ====== Function declarations End ======


# ========== Main program Begins ==========
# Call function to set user console colors
color_check

# Call function to set terminal size to support greeting
resize_check

# If not running screen session we need user input
if [[ "${_useScreen}" != "yes" ]]; then

    # Clear console screen for user readabilty
    clear

    # Small intro and declaration of versioning
    echo =======================================================================================        
    echo "                Linux ${cyan}Qortal${normal} core auto-restart script by ${cyan}HFactor${normal} (V1.3)"
    echo
    echo " This script will make use of the 'screen' app to spawn another session to run in."
    echo " The following commands should be used to stop any screen session/s before the core."
    echo
    echo " ${cyan}screen -ls${normal} (list's the current screen PID/s (PID is digits before the '.'))"
    echo " ${cyan}screen -r  <PID from listing>${normal} (transfers to the screen session of <PID from listing>)"
    echo " ${cyan}ctrl+c${normal}     (kills active screen session after screen -r <PID from listing>)"
    echo =======================================================================================
    echo
    sleep 1.5

    # For security reasons user shuld not run as root
    echo "Checking to ensure ${red}root${normal} user is not being utilized..."
    logging "Checking to ensure root user is not being utilized..."
    sleep .5

    # If user is root user exit with error
    # Else continue
    if [ "$_user" = "root" ]; then

	    echo -e "${red}Root${normal} user login detected!\n"
	    logging "Root user login detected!\n"
	    sleep 1
	    
	    # Exit under general error
	    we_outtie 1

    elif [ "$_user" != "root" ]; then

	    echo -e "${green}Root user login not detected!${normal}\n"
	    logging "Root user login not detected!\n"
	    sleep 1

        # Call function to determine if lsof is installed
        echo "Checking if ${cyan}lsof${normal} is installed..."
        logging "Checking if lsof is installed..."
        sleep 1

        # Call function to check if lsof is currently installed
        lsof_check

        # Install lsof if not already installed based on function return value
        if [[ $? -eq 0 ]]; then

            echo -e "${green}Lsof installation detected, moving forward!${normal}\n"
            logging "Lsof installation detected, moving forward!\n"
            sleep .5

        else
            # Enable mouse cursor for user input
            tput cnorm

            echo "${red}Lsof installation not detected, beginning install!${normal}"
            logging "Lsof installation not detected, beginning install!"
            sleep 1
            sudo apt install -y lsof &> lsof_install.txt

            # Disable mouse cursor for user input
            tput civis
            
            # Check for lsof install again
            lsof_check

            # If exit status of lsof_check is 0 continue
            # Else update user on failure
            if [[ $? -eq 0 ]]; then

                echo -e "${green}Lsof installation completed, moving forward!${normal}\n"
                logging "Lsof installation completed, moving forward!\n"
                sleep 1

            else

                echo "${red}Lsof failed to install and is required to move forward!${normal}"
                logging "Lsof failed to install and is required to move forward!"
                sleep .5
                echo -e "${yellow}Please check 'lsof_install.txt' for screen install output!${normal}\n"
                logging "Please check 'lsof_install.txt' for screen install output!\n"
                sleep 1
                
                # Exit under general error so user can determine issue/s and correct
                we_outtie 1

            fi
        fi

        # Call function to determine if curl is installed
        echo "Checking if ${cyan}curl${normal} is installed..."
        logging "Checking if curl is installed..."
        sleep 1

        # Call function to check if curl is currently installed
        curl_check

        # If exit status of curl_check is 0 continue
        # Else update user on failure
        if [[ $? -eq 0 ]]; then

            echo -e "${green}Curl installation detected, moving forward!${normal}\n"
            logging "Curl installation detected, moving forward!\n"
            sleep .5

        else

            # Enable mouse cursor for user input
            tput cnorm

            echo "${red}Curl installation not detected, beginning install!${normal}"
            logging "Curl installation not detected, beginning install!"
            sleep 1
            sudo apt install -y curl &> curl_install.txt
            sleep .5

            # Disable mouse cursor for user input
            tput civis
            
            # Call function to check for curl install again
            curl_check

            # If exit status of curl_check is 0 continue
            # Else update user on failure
            if [[ $? -eq 0 ]]; then
                echo -e "${green}Curl installation completed, moving forward!${normal}\n"
                logging "Curl installation completed, moving forward!\n"
                sleep 1

            else

                echo "${red}curl failed to install and is required to move forward!${normal}"
                logging "curl failed to install and is required to move forward!"
                sleep .5
                echo -e "${yellow}Please check 'curl_install.txt' for screen install output!${normal}\n"
                logging "Please check 'curl_install.txt' for screen install output!\n"
                sleep 1
                
                # Exit under general error so user can determine issue/s and correct
                we_outtie 1

            fi
        fi
            
        # Call function to determine if screen is installed
        echo "Checking if ${cyan}screen${normal} is installed..."
        logging "Checking if screen is installed..."
        sleep 1
        screen_check

            # If exit status of curl_check is 0 continue
            # Else update user on failure
            if [[ $? -eq 0 ]]; then

                echo -e "${green}Screen installation detected, moving forward!${normal}\n"
                logging "Screen installation detected, moving forward!\n"
                sleep .5               

            else

                # Enable mouse cursor for user input
                tput cnorm

                echo "${red}Screen installation not detected, beginning install!${normal}"
                logging "Screen installation not detected, beginning install!"
                sleep 1
                sudo apt install -y screen &> screen_install.txt
                sleep .5

                # Disable mouse cursor for user input
                tput civis
                
                # Check for screen install again
                screen_check

                # If exit status of curl_check is 0 continue
                # Else update user on failure
                if [[ $? -eq 0 ]]; then

                    echo -e "${green}Screen installation completed, moving forward!${normal}\n"
                    logging "Screen installation completed, moving forward!\n"
                    sleep 1

                else

                    echo "${red}Screen failed to install and is required to move forward!${normal}"
                    logging "Screen failed to install and is required to move forward!"
                    sleep .5
                    echo -e "${yellow}Please check 'screen_install.txt' for screen install output!${normal}\n"
                    logging "Please check 'screen_install.txt' for screen install output!\n"
                    sleep 1
                    
                    # Exit under general errorso user can determine issue/s and correct
                    we_outtie 1

                fi
            fi

        # While _timeIntervalValidated flag not set continue to loop
        while [[ "${_timeIntervalValidated}" != "true" ]]; do

            # Request users desired restart interval, store in variable and display
            echo -n "Enter interval between Qortal ${cyan}core${normal} restarts (e.g. 60s/60m/1h/1d): "
            
            # Call function to read and store user input for time interval
            it_listens2

            # Write to log must occur after function to obtain user input interval
            logging "Enter interval between Qortal core restarts (e.g. 60s/60m/1h/1d): ${_timeInterval}"

            # Call function to validate user input for time interval
            time_interval_validator
            sleep .5

        done

        echo -e "\n${green}Core restart interval keyed as every ${_timeInterval}${normal}\n"
        logging "Core restart interval keyed as every ${_timeInterval}\n"
        sleep .5

        # Request user make decision on using screen to generate another terminal window
        # or use the existing terminal window
        echo -n "Utilize ${cyan}screen${normal} to perform monitoring/restart in the background? (y/n): "

        # Call function to record user input for time interval
        it_listens

        # Write to log must occur after function to obtain user input interval
        logging "Utilize screen to perform monitoring/restart in the background? (y/n): ${_useScreen}"
        sleep .5

        # If user chose to utilize screen app
        if [[ "${_useScreen}" = "yes" ]]; then           
            
            # Run screen in detached mode (-d) and ignore $STY env. variable (-m) with a sessionname(-S) of
            # "qortalRestart" and run command (bash -c) "$(realpath $0), which is the absolute path to
            # this script, and pass this script the argument "true" to be picked up by the script via $1
            screen -d -m -S coreAutoRestart bash -c "$(realpath $0) "yes" "$_timeInterval" "
            
                # If exit status of screen command is 0 continue
                # Else update user on failure
                if [[ $? -eq 0 ]]; then

                    echo -e "${green}Script successfully started in screen session 'qortalRestart'...${normal}\n\n"
                    logging "Script successfully started in screen session 'qortalRestart'...\n\n"
                    logging "======== Beginning of screen session activity log ========\n"
                    sleep .5
                    echo "${yellow}Script output will no longer occur in this session window!${normal}"
                    sleep .5
                    echo -e "${yellow}Please refer to 'userdefined-automatic-core-restart.log' for updates moving forward!${normal}\n"
                    sleep 1
                    
                    # Exit under no error as script is now running in another session
                    we_outtie 0

                else

                    echo -e "${red}Script failed to start in screen session 'qortalRestart'!${normal}\n"
                    logging "Script failed to start in screen session!\n"
                    sleep 1
                    
                    # Exit under general error so user can determine issue/s and correct
                    we_outtie 1

                fi
            
        # Else the user did not choose to utilize the screen app
        else

            echo -e "${green}Script successfully started in current session!${normal}\n"
            logging "Script successfully started in current session!\n"

        fi
    fi
fi

# Controlling loop for restart sequence of events
while true; do

    # Change directory to default qortal folder
    echo -e "Navigating to Qortal ${cyan}core${normal} directory...\n"
    logging "Navigating to Qortal core directory...\n"
    cd "${_core}" || { echo "${red}Failed to navigate to Qortal directory!${normal}"; logging "Failed to navigate to Qortal directory!"; we_outtie 1; }
    sleep .5

    echo "Checking if Qortal ${cyan}core${normal} is already running..."
    logging "Checking if Qortal core is already running..."
    
    # Call function to check for running processId
    core_processid_check

    # Call function to check run.pid contains data
    core_runfile_check
    
    # Call function to compare run.pid to java process pid which should be equal
    # If not equal then processId takes precidence and is pushed into variable _runFileText
    processid_validation
        
    sleep .5

    # If Core not already running
    # Else if Core already running prompt user and stop it
    if [[ "${_coreRunning}" == "false" ]]; then

        echo -e "${red}Running instance of Qortal core not detected!${normal}\n"
        logging "Running instance of Qortal core not detected!\n"
        sleep .5

    else 
        echo -e "${green}Running instance of Qortal core detected under procID "${_runProcText}"${normal}\n"
        logging "Running instance of Qortal core detected under procID ${_runProcText}\n"
        sleep .5
        
        # Call function to stop core via api
        # if not successful the function will call kill
        api_stop_core
    fi

    printf "Starting Qortal ${cyan}core${normal}, ${yellow}please wait${normal}"
    logging "Starting Qortal core, please wait..."
    sleep .5

    # Call function to load core
    start_core

    # Call function to loop until the core is detected via api port activity
    lets_start_loop

    echo -e "\n${green}Qortal core is now running under procID "${_runProcText}"${normal}\n"
    logging "Qortal core is now running under procID ${_runProcText}\n"
    sleep .5
    
    echo "Sleeping ${cyan}${_timeInterval}${normal} before restarting the Qortal ${cyan}core${normal}..."
    logging "Sleeping ${_timeInterval} before restarting the Qortal core..."

    # Sleep user defined amount of time
    sleep "${_timeInterval}" || { echo "${red}Sleep command failed!${normal}"; logging "Sleep command failed!"; we_outtie 1; }
    
    # Sleep over continue restart process
    echo -e "Script has slept ${_timeInterval} and will now restart the Qortal ${cyan}core${normal}\n"
    logging "Script has slept ${_timeInterval} and will now restart the Qortal core!\n"
    sleep .5
    
done

#Enable mouse cursor
tput cnorm

# Exit under status 0 (no errors)
exit 0