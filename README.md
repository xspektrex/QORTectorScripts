
<h1 align="center">
~QORTector Scripts~
</h1>

<p>
Simple scripts to make tasks easier for users of the QORTectors and home built pi4's.  These scripts are 
not be utilized on other linux systems unless explicitly indicated in the list below this body of text.
</p>

```
Appicable to other linux distros:
- unintall_ui.sh
- update_install_ui.sh
```
---



To Utilize:

1. Ensure `git` is installed with terminal command `git --version`.  
If no git version is listed simply install via terminal with `sudo apt install git` and proceed.

2. Download scripts to your home folder via wget.

```
 wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/main/uninstall_ui.sh
 wget https://raw.githubusercontent.com/xspektrex/QORTectorScripts/main/update_install_ui.sh
```

2. Make the script/s executeable:

    via terminal, immediately after terminal load, with `chmod +x *.sh`
    
    Via GUI with `(Right-click -> Properties -> Permissions)` and check the "make executeable" box.

3. Now run the script/s:

    via termianl, immediately after terminal load, with `sudo ./<script name with file extenstion> eg: sudo ./uninstall_ui.sh`
