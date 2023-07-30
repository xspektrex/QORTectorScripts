<h1 align="center">
~ Qortal/VPS install/setup Directions ~
</h1>

<p>
Easy to follow quide on setting up a VPS and installing qortal core (headles install ubuntu/debian based distros)
</p>

---

1.) add non root user
```
  useradd -m <username> (-m creates the home directory)
  passwd <username>
```

2.) install sudo as root and apply to <username>
```
  apt install sudo
  usermod -aG sudo admin (allows <username> to issue sudo commands)
```

3.) change user account to bash (terminal)
```
  sudo chsh -s /bin/bash ${username}
```

4.) log out of root and login to <username> created previously

5.) fix .profile
```
  mv .profile .profile_old
  wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/.profile
```

6.) rename motd license bs so it isn't called on login
```
  mv /etc/motd /etc/motd_old
```

7.) log out of <username> and log back into <username>
```
  terminal output should look different
    - not just black/white
    - prompt string should be colorful and reflect current directory (eg: ~ means home (default start location))
```

8.) install curl (command line tool for transferring data via network protocols)
```
  sudo apt install curl
```

9.) install wget (command line tool for retrieving data via the web)
```
  sudo apt install wget
```

10.) install duf (terminal based disk usage)
```
  sudo apt install duf
```

11.) install jq (lightweight/flexible json processor)
```
  sudo apt install jq 
```

12.) install htop (terminal based, interactive resource monitor)
```
  sudo apt install htop
```

13.) install rfkill (command line tool for controlling network adapters)
```
  sudo apt rfkill
```

14.) install unzip utility (command line tool for unzipping archives)
```
  sudo apt install unzip
```

15.) install 7-zip (command line tool for zipping/unzipping archives)
```
  sudo apt install p7zip-full
```

16.) install bc (command line tool for calculations)
```
  sudo apt install bc
```

17.) install java
```
  sudo apt install openjdk-17-jdk openjdk-17-jdk-headless
```

18.) install ufw firewall
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

19.) install qortal core
```
  wget https://github.com/Qortal/qortal/releases/latest/download/qortal.zip
  unzip qortal.zip            
  cd qortal         
  chmod +x *.sh   
```

20.) fix settings.json for core
```
  rm -rf settings.json
  echo -en "{\n\"bindAddress\": \"0.0.0.0\",\n\"apiDocumentationEnabled\": true,\n\"apiEnabled\": true,\n\"apiRestricted\": false,\n\"apiWhitelistEnabled\": false\n}" > settings.json
```

21.) install tools
```
  https://raw.githubusercontent.com/Qortal/qortal/master/tools/qort && chmod +x qort
  https://raw.githubusercontent.com/Qortal/qortal/master/tools/peer-heights && chmod +x peer-heights
  cd && sudo cp qort /usr/local/bin
    - useful commands
      -- ./qort -p peers
      -- ./qort -p admin/status
      -- ./qort -p admin/info
      -- ./qort -p admin/mintingaccounts
```
22.) start the core
```
./start.sh
```
