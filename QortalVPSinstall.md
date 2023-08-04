<h1 align="center">
~ VPS setup/config and Qortal node install/setup Directions ~
</h1>
<br>
<p align="center">
Easy to follow quide on setting up a VPS hosted node and installing qortal core (headles install ubuntu/debian based distros)
</p>
<br>


1.) Add non root user for all future work (Never use root!!!)
```
  useradd -m <username> (-m creates the home directory)
  passwd <username>
```

2.) Install sudo as root and apply to new user
```
  apt install sudo
  usermod -aG sudo <username> (allows <username> to issue sudo commands)
```

3.) Change shell to bash for new user
```
  chsh -s /bin/bash <username>
```

4.) Log out of root and log in with new user

5.) Fix .profile for new user
```
  mv .profile .profile_old
  wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/.profile
```

6.) Rename motd license bs so it isn't called on login
```
  sudo mv /etc/motd /etc/motd_old
```

7.) Log out of new user and log back in with new user to see updated terminal output format
```
  terminal output should look different
    - not just black/white
    - prompt string should be colorful and reflect current directory (eg: ~ means home (default start location))
```

8.) Run system updates/upgrades
```
  sudo apt update
  sudo apt upgrade
```

9.) Install curl (command line tool for transferring data via network protocols)
```
  sudo apt install curl
```

10.) Install wget (command line tool for retrieving data via the web)
```
  sudo apt install wget
```

11.) Install duf (terminal based disk usage)
```
  sudo apt install duf
```

12.) Install jq (lightweight/flexible json processor)
```
  sudo apt install jq 
```

13.) Install htop (terminal based, interactive resource monitor)
```
  sudo apt install htop
```

14.) Install rfkill (command line tool for controlling network adapters)
```
  sudo apt install rfkill
```

15.) Install unzip utility (command line tool for unzipping archives)
```
  sudo apt install unzip
```

16.) Install 7-zip (command line tool for zipping/unzipping archives)
```
  sudo apt install p7zip-full
```

17.) Install bc (command line tool for calculations)
```
  sudo apt install bc
```

18.) Install java
```
  sudo apt install openjdk-17-jdk openjdk-17-jdk-headless
```

19.) Install ufw firewall
```
  sudo apt install ufw
    - configure firewall
        sudo ufw allow openssh
        sudo ufw allow 12392/tcp
        sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 12391 proto tcp
        sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 12388 proto tcp
    - additional firewall commands
      -- list/remove (v6) ufw entries if needed
          sudo ufw status numbered verbose
          sudo ufw remove {listed number}
```

20.) Install qortal core
```
  wget https://github.com/Qortal/qortal/releases/latest/download/qortal.zip
  unzip qortal.zip            
  cd qortal         
  chmod +x *.sh
  rm -rf qortal.zip
```

21.) Fix settings.json for core on VPS
```
  rm -rf settings.json
  echo -en "{\n\"bindAddress\": \"0.0.0.0\",\n\"apiDocumentationEnabled\": true,\n\"apiEnabled\": true,\n\"apiRestricted\": false,\n\"apiWhitelistEnabled\": false\n}" > settings.json
```

22.) Install tools to make it easier to get quick stats for core (tools called from home directory prefixed with ./)
```
  cd
  wget https://raw.githubusercontent.com/Qortal/qortal/master/tools/qort && chmod +x qort
  wget https://raw.githubusercontent.com/Qortal/qortal/master/tools/peer-heights && chmod +x peer-heights
  sudo cp qort /usr/local/bin
    - useful commands
        ./qort -p peers
        ./qort -p admin/status
        ./qort -p admin/info
        ./qort -p admin/mintingaccounts
```
23.) Start the core
```
  cd qortal && ./start.sh
```
---
<br></br>

<h1 align="center">
~ Load UI from MAC/Linux and connect with VPS/core installation ~
</h1>
<p align="center">
This portion of the guide assumes you have already downloaded/installed the UI locally!
If not it can be downloaded from https://github.com/Qortal/qortal-ui/releases/tag/latest
</p>
<br>

1.) Load the terminal and type (this must be done every time!!!)
```
  ssh -L 12391:localhost:12391 <username@IP of VPS>
```
2.) Load UI and enjoy

3.) When done with UI
```
  Exit the UI via the exit button
  Exit the ssh session by typing in "exit" and hitting enter
  Exit the terminal session by typing in "exit" and hitting enter
```
---
<br></br>

<h1 align="center">
~ Load UI from Windows and connect with VPS/core installation ~
</h1>
<p align="center">
This portion of the guide assumes you have already downloaded/installed the UI locally
If not it can be downloaded from https://github.com/Qortal/qortal-ui/releases/tag/latest
</p>
<br>
  
1.) Download putty from https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.78-installer.msi and install/load
```
  When application loads "Session" will be highlighted in the Category tree on the left
  Populate the "Host Name (or IP address)" field on the right of the window with the IP from the VPS only
  In the left "Category" tree click "SSH" to expand it's tree
  In the left "Category" tree click "Tunnels"
    On the right of the window populate the "Source port" text field with "12391" only
    On the right of the window populate the "Destination" text field with <IP of VPS>:12391 only
    On the right of the window click the "Add" button only
  In the left "Category" tree click "Connection"
    On the right of the window populate the "Seconds between keepalives" text field with "60"
  In the left "Category" tree scroll up and click "Session" to get back to where we were in the beginning
    On the right of the screen the previously entered "Host Name" field should still be populated (this is good!)
    On the right of the screen populate "Saved Sessions" with a name you see fit
    On the right of the screen click "Save" and all the entries we just made will be stored under the session name you chose (this is good!)
```
2.) Before loading the UI locally, moving forward, the following must be done every time!!!
```
  Load putty
  On the right of the window select/click the previously entered/saved session name
  On the right of the window click "load"
  On the right of the screen click "open"
  An ssh window will open allowing you to login to the VPS instance via bash/shell
  Login with non-root username created earlier in this document
  Minimize window
```
3.) Load UI
```
  When prompted for apikey put the following in terminal to get it
  cat qortal/apikey.txt
  copy the key in black/white and paste into the UI apikey text box
```

4.) When done with UI
```
  Exit the UI via the exit button
  Exit the ssh/putty session by typing in "exit" and hitting enter which will close the terminal session and putty
```
