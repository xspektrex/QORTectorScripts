## **<p align="center">🧑‍💻 ~ HFactor's Scripts and How-To's (Updated 11.19.23) ~ 🧑‍💻 </p>**

This repository contains scripts and how-to's making tasks easier for users of the [QORTector](https://test.crowetic.com/index.php/product/qortector-gen-2/) and home built pi4's taking part in the [QORTAL](https://www.qortal.org) blockchain.  The scripts herein make use of the [nodesource](https://nodesource.com/) git for installing and updating [Node.js](https://nodejs.org) utilized by the QORTAL UI. 

**Please be advised the scripts herein should only be utilized with the distros pictured below**
<p align="left">
<img src="https://seeklogo.com/images/D/debian-logo-0BECE23D11-seeklogo.com.png" width="100" hspace="50" alt="Debian Linux" />
<img src="https://seeklogo.com/images/U/ubuntu-logo-7F6533BEF8-seeklogo.com.png" width="100" hspace="50" alt="Ubuntu Linux"/>
<img src="https://upload.wikimedia.org/wikipedia/commons/b/b1/Raspbian_logo.png" width="200" alt="Raspbian OS"/>
</p>

<br>

## **<p align="center">⚠️ Important Updates ⚠️</p>**

**(2023 Mark-II)**
* Since the nodesource nodejs install procedure has changed there are now 2 sets of scripts.  
  - Post 2023 mark-II repo change scripts prefixed with nothing  
  - Pre 2023 mark-II repo change scripts prefixed with "prc_njs_
    
<strike>**(2023 Mark-I)**
* Since the qortal-ui repo has been restructured there are now 2 sets of scripts.
  - Post 2023 repo change scripts prefixed with nothing
  - Pre 2023 repo change scripts prefixed with "prc2023"
    
**(2022)**  
* Since the UI repo has changed from "UI" to "qortal-ui" there are now 2 sets of scripts.
  - Pre repo change prefixed with "prc"
  - Post repo change prefixed with nothing</strike>

<br>

## Table Of Contents 

* **[Build From Source UI Setup Guides](#build-from-source-ui-setup-guides)**
  - [New Users](#new-users-ui-install-procedure)
    - [UI Install Procedure](#new-users-ui-install-procedure)
    - [UI UnInstall Procedure](#new-users-ui-uninstall-procedure)
  - [Returning Users](#returning-users-ui-update-procedure)
    - [UI Update Procedure](#returning-users-ui-update-procedure)
    - [UI UnInstall Procedure](#returning-users-ui-uninstall-procedure)
* **[NodeJS Release Calendar](#nodejs-release-calendar)**
* **[VPS QORTAL Setup Guide](https://github.com/xspektrex/QORTectorScripts/blob/master/QortalVPSinstall.md)**

<br>

## <p align="center">Build From Source UI Setup Guides</p>

### **New Users UI Install Procedure**

1. Check to see if `git` is currently installed
   * Load terminal and issue the command `git --version`
     * If no git version is listed simply install git via the same terminal instance with the command `sudo apt install git`
      
3. Ensure 'nodejs' is not already installed
   * Within terminal issue the command `sudo apt purge nodejs`

4. Download UI install/update/removal scripts to your home folder
   * Within terminal issue the following command:
      ```shell
      wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/update_install_ui.sh && wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/uninstall_ui.sh
      ```

5. Download Qortal Core & Qortal-UI launchers to your home folder
   * Within terminal issue the following command:
      ```shell
      wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/Launch_Core.sh && wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/Launch_UI.sh
      ```

6. Make the downloaded script/s executable:
    * Via terminal
      * Within terminal issue the command `chmod +x *.sh`

    * Via GUI
      * `(Right-click -> Properties -> Permissions)` and check the "make executable" box.

7. Cut/paste Core & UI launchers to desktop
   * Via terminal
     * Within terminal issue the following command:
         ```shell
           mv Launch_Core.sh ~/Desktop/Launch_Core.sh && mv Launch_UI.sh ~/Desktop/Launch_UI.sh
         ``` 
   * Via GUI
     * Select each file and cut/paste onto desktop 

8. Run the QORTAL UI installation script by issuung the command `./install_update_ui.sh`

9. Wait for installation script to complete it's work as noted by "press q to quit"
    
<br>

### **New Users UI UnInstall Procedure**

1. Load terminal and issue the command `./uninstall_ui.sh`

<br>

### **Returning Users UI Update Procedure**

1. If step 2 below has been previously performed since the script/s update noted at the top of this page
    - Load terminal and issue the command `./install_update_ui.sh`
      
2. If updating for the first time since the script/s update noted at the top of this page
    - Load terminal and download/make executeable/run the pre-update uninstaller by issuing the following command:
        ```shell
            wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/prc_njs_2023_uninstall_ui.sh && chmod +x *.sh && ./prc_njs_2023_uninstall_ui.sh
        ```
    - Load terminal and download/make executebale/run the updated QORTAL UI installer via the command:
        ```shell
            wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/update_install_ui.sh && chmod +x *.sh && ./update_install_ui.sh
        ```
    - Remove all UI scripts, downloaded or pre-existing in the home folder, that are not `update_install_ui.sh` or `uninstall_ui.sh`

<br>

### **Returning Users UI Uninstall Procedure**
1. If step 2 below has been previously performed since the script/s updated noted at the top of this page
   - Load terminal and issue the command `./uninstall_ui.sh`
2. If un-installing for the first time since the script/s updated noted at the top of this page
    - Load terminal and download/make executeable/run the uninstaller by issuing the following command:
        ```shell
            wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/prc_njs_2023_uninstall_ui.sh && chmod +x *.sh && ./prc_njs_2023_uninstall_ui.sh
        ```
<br>

## **<p align="center">NodeJS Release Calendar</p>**
[![Node Releases Calendar](https://raw.githubusercontent.com/nodejs/Release/main/schedule.svg?sanitize=true)](https://nodejs.dev/en/about/releases)  
_source: https://nodejs.dev_
