<h1 align="center">
~ Qortal/VPS install/setup Directions ~
</h1>

<p>
Easy to follow quide on setting up a VPS and installing qortal core (headles install ubuntu/debian based distros)
</p>

---

1.) Add non root user for all future work (Never use root!!!)
```
  useradd -m <username> (-m creates the home directory)
  passwd <username>
```

2.) Install sudo as root and apply to new user
```
  apt install sudo
  usermod -aG sudo admin (allows <username> to issue sudo commands)
```

3.) Change user account to bash for new user
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
  mv /etc/motd /etc/motd_old
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
  sudo apt rfkill
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
      -- sudo ufw allow openssh
      -- sudo ufw allow 12391/tcp
      -- sudo ufw allow 12392/tcp
      -- sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 80 proto tcp
      -- sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8080 proto tcp
      -- sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 12388 proto tcp
    - additional firewall commands
      -- list/remove (v6) ufw entries if needed
        --- sudo ufw status numbered verbose
        --- sudo ufw remove {listed number}
```

20.) Install qortal core
```
  wget https://github.com/Qortal/qortal/releases/latest/download/qortal.zip
  unzip qortal.zip            
  cd qortal         
  chmod +x *.sh   
```

21.) Fix settings.json for core on VPS
```
  rm -rf settings.json
  echo -en "{\n\"bindAddress\": \"0.0.0.0\",\n\"apiDocumentationEnabled\": true,\n\"apiEnabled\": true,\n\"apiRestricted\": false,\n\"apiWhitelistEnabled\": false\n}" > settings.json
```

22.) Install tools to make it easier to get quick stats for core (tools called from home directory prefixed with ./)
```
  cd
  https://raw.githubusercontent.com/Qortal/qortal/master/tools/qort && chmod +x qort
  https://raw.githubusercontent.com/Qortal/qortal/master/tools/peer-heights && chmod +x peer-heights
  sudo cp qort /usr/local/bin
    - useful commands
      -- ./qort -p peers
      -- ./qort -p admin/status
      -- ./qort -p admin/info
      -- ./qort -p admin/mintingaccounts
```
23.) Start the core
```
./start.sh
```
