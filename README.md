
<h1 align="center">
~QORTector Scripts (Updated!!!)~
</h1>

<p>
Simple scripts to make tasks easier for users of the QORTectors and home built pi4's.  These scripts are
not be utilized on other Linux systems unless explicitly indicated in the list below this body of text.
</p>

```
    Applicable to other linux distros that are Qortal nodes only:
      - unintall_ui.sh
      - update_install_ui.sh
```
---


To Utilize:

1. Ensure `git` is installed with terminal command `git --version`.  
If no git version is listed simply install via terminal with `sudo apt install git` and proceed.

2. Download removal & update scripts to your home folder via wget:

```
     wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/update_install_ui.sh
     wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/uninstall_ui.sh
```

3. Download Core & UI launchers via wget:

```
     wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/Launch_Core.sh (move to desktop)
     wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/Launch_UI.sh (move to desktop)
```

4. Make the script/s executable:

    via terminal, immediately after terminal load, with `chmod +x *.sh`

    Via GUI with `(Right-click -> Properties -> Permissions)` and check the "make executable" box.

5. Cut/paste Core & UI launchers to desktop

6. Now run the update_install or uninstall script/s via termianl:

    `sudo ./<script name with file extension> eg: sudo ./uninstall_ui.sh`

---

Important Details (2023):

1. Since the qortal-ui repo has been restructured there are now 2 sets of scripts.

```
    - Post 2023 repo change scripts prefixed with nothing
    - Pre 2023 repo change scripts prefixed with "prc2023"
```

2.  If a clean install is preferred, and it is suggested, the following procedural flow must be followed based on the indicated situation
    - If doing a fresh install
       ```
           Ensure nodeJS is not already installed via APT as it will not be an LTS release
              - Sudo apt purge nodeJS
           Run the update_install_ui.sh script
       ```
      
    - If updating for the first time since the repo re-orginization
        ```
            Ensure nodeJS is not already installed via APT as it will not be an LTS release
                - Sudo apt purge nodeJS
            Run the prc2023unintall_ui.sh script to remove the qortal-ui install that was previously the normal installer
            Run the update_install_ui.sh script to install the qortal-ui
        ```
3. Finish up
   - Re-install curl
     
       ```
           - sudo apt install curl
       ```
    
<strike>Important Details (2022) (Deprecated):

1. Since the UI repo has changed from "UI" to "qortal-ui" there are now 2 sets of scripts.

```
    - Pre repo change prefixed with "prc"
    - Post repo change prefixed with nothing
```
    
2.  If a clean install is preferred, and it is suggested, the pre repo change uninstaller should be utilized before utilizing the post repo change installer.</strike>

