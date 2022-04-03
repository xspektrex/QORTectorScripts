
<h1 align="center">
~QORTector Scripts~
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
 wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/launch_Core.sh (move to desktop)
 wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/master/launch_UI.sh (move to desktop)
```

4. Make the script/s executable:

    via terminal, immediately after terminal load, with `chmod +x *.sh`

    Via GUI with `(Right-click -> Properties -> Permissions)` and check the "make executable" box.

5. Cut/paste Core & UI launchers to desktop

6. Now run the update_install or uninstall script/s via termianl:

    `sudo ./<script name with file extension> eg: sudo ./uninstall_ui.sh`

---
    
    
Important Details:

1. Since the UI repo has changed from "UI" to "qortal-ui" there are now 2 sets of scripts.

```
    - Pre repo change prefixed with "prc"
    - Post repo change prefixed with nothing
```
    
2.  If a clean install is preferred, and it is suggested, the pre repo change uninstaller should be utilized before utilizing the post repo change installer.

