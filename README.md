
<h1 align="center">
~ QORTector Scripts and how to's (Updated 11.19.23) ~
</h1>

<p>
Simple scripts and how to's to make tasks easier for users of the QORTector and home built pi4's and linux.
The scripts herein are not to be utilized on other Linux systems unless explicitly indicated in the OS image list below
</p>
<p align="center">
<img src="https://seeklogo.com/images/D/debian-logo-0BECE23D11-seeklogo.com.png" width="100" hspace="50" />
<img src="https://seeklogo.com/images/U/ubuntu-logo-7F6533BEF8-seeklogo.com.png" width="100" />
</p>

---
<br><br>
```
    The stated scripts are applicable to other Debian/Ubunutu based linux distros that are Qortal nodes only:
      - uninstall_ui.sh
      - update_install_ui.sh
      - Launch_Core.sh
      - Launch_UI.sh
```
<br><br>
## Newcomers Start Here 🆕

1. Ensure `git` is installed via terminal with the command `git --version`
    - If no git version is listed simply install git via terminal with the command `sudo apt install git`
      
<br>

2. Download UI install/update and removal scripts to your home folder via terminal immediately after terminal load:
```
     wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/update_install_ui.sh && wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/uninstall_ui.sh
```
<br>

3. Download Qortal Core & Qortal-UI launchers to your home folder via terminal immediately after terminal load:
```
     wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/Launch_Core.sh && wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/Launch_UI.sh
```
<br>

4. Make the downloaded script/s executable:

    - via terminal immediately after load with  `chmod +x *.sh`

    - Via GUI with  `(Right-click -> Properties -> Permissions)` and check the "make executable" box.
<br>

5. Cut/paste Core & UI launchers to desktop
<br>

6. Now run the update_install or uninstall script/s via termianl immediately after load:
   ```
   ./<script name with file extension> eg: sudo ./install_update_ui.sh
   ```
---
<br><br>
## Important Details (2023) Mark-II ℹ️

1. Since the nodesource nodejs install procedure has changed there are now 2 sets of scripts.

    ```
       - Post 2023 mark-II repo change scripts prefixed with nothing
       - Pre 2023 mark-II repo change scripts prefixed with "prc_njs_"
    ```

3.  Please utilize the appropriate procedural flow indicated below:
    - If doing a fresh install (Preferred)
        - Load terminal and ensure nodeJS is not already installed via APT, as it will not be a recent release, via the command below
           ```
               Sudo apt purge nodeJS
           ```
       - Load terminal and download/make executeable/run the `install_update_ui.sh` via the command below to install the qortal-ui via the updated method
         ```
              wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/install_update_ui.sh && chmod +x *.sh && ./install_update_ui.sh
         ```
      
    - If updating for the first time since the scripts noted at the top of this page were updated (11.19.2023)
        - Load terminal and download/make executeable/run the `prc_njs_2023_unintall_ui.sh` script via the command below to remove the existing qortal-ui install
             ```
              wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/prc_njs_2023_uninstall_ui.sh && chmod +x *.sh && ./prc_njs_2023_uninstall_ui.sh
             ```
        - Load terminal and download/make executebale/run the `update_install_ui.sh` script via the command below to install the qortal-ui via the updated method
             ```
              wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/update_install_ui.sh && chmod +x *.sh && ./update_install_ui.sh
             ```
        - Remove all UI scripts, downloaded or pre-existing in the home folder, thate are not `update_install_ui.sh` or `uninstall_ui.sh`

## <strike>Important Details (2023) Mark-I (Deprecated) ℹ️

1. Since the qortal-ui repo has been restructured there are now 2 sets of scripts.

```
    - Post 2023 repo change scripts prefixed with nothing
    - Pre 2023 repo change scripts prefixed with "prc2023"
```

2.  If a clean install is preferred, and it is suggested, the following procedural flow must be followed based on the indicated situation
    - If doing a fresh install 
        - Ensure nodeJS is not already installed via APT as it will not be a recent release
           ```
               Sudo apt purge nodeJS
           ```
      
    - If updating for the first time since the repo re-orginization
        - Ensure nodeJS is not already installed via APT as it will not be a recent release
              ```
                Sudo apt purge nodeJS
              ```
        - Run the `prc2023unintall_ui.sh` script to remove the qortal-ui install that was previously the normal installer
        - Run the `update_install_ui.sh` script to install the qortal-ui
        
3. Finish up by re-installing curl
   
           sudo apt install curl 


    
## Important Details (2022) (Deprecated) ℹ️

1. Since the UI repo has changed from "UI" to "qortal-ui" there are now 2 sets of scripts.

```
    - Pre repo change prefixed with "prc"
    - Post repo change prefixed with nothing
```
    
2.  If a clean install is preferred, and it is suggested, the pre repo change uninstaller should be utilized before utilizing the post repo change installer.

