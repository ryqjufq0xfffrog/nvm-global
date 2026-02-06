# nvm-global
An addon for nvm that enables you to set a systemwide default version for Node.js

# Usage
```
$ git clone https://github.com/ryqjufq0xfffrog/nvm-global.git
$ cd nvm-global
$ ./nvm-global.sh i <version>  # Install <version>
$ ./nvm-global.sh u            # Uninstall
```
<version> is optional. When omitted, nvm-global will use currently activated version of Node.

Run this script in a shell that is configured for nvm.

# Requirements
- nvm
- tr
- cut
- sudo
- ln
- rm

# How it works
This script looks up for the node binary in $NVM_DIR/versions/node/<version>
and then creates a symbolic link in /usr/local/bin/.
