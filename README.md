# nvm-global
An addon for nvm that enables you to set a systemwide default version for Node.js

(Run the script as the user which you have set up nvm)

# Usage
```
$ ./nvm-global.sh i   # Set
$ ./nvm-global.sh u   # Unset
```
Needs you being a sudoer, but do not run the script as root unless you have set up nvm for root. 

# How it works
Actually this looks up for the "default" node version and then creates a symbolic link in /usr/bin/. 
