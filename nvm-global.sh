#!/usr/bin/sh

if [ "$1" = "u" ]; then
  # Check if the files are symlinks
  if [ ! -L /usr/bin/node ] || [ ! -L /usr/bin/npm ] || [ ! -L /usr/bin/npx ] || [ ! -L /usr/bin/corepack ]; then
    echo "One or more of the files to delete was not a symbolic link. Aborting. "
    exit 1;
  fi
  # Then remove.
  sudo rm -f /usr/bin/node /usr/bin/npm /usr/bin/npx /usr/bin/corepack
elif [ "$1" = "i" ]; then
  # Prevent overwriting
  if [ -f /usr/bin/node ] || [ -f /usr/bin/npm ] || [ -f /usr/bin/npx ] || [ -f /usr/bin/corepack ]; then
    echo "Node.js seems to have been installed globally. \nTry again after uninstalling Node.js: \nsudo apt remove nodejs\t\t\t# if you installed it with apt; most likely if you are using Ubuntu or Debian."
    exit 1;
  fi
  # Create symlinks.
  sudo ln -s $NVM_DIR/versions/node/$(cat $NVM_DIR/alias/default)/bin/node /bin/node
  sudo ln -s $NVM_DIR/versions/node/$(cat $NVM_DIR/alias/default)/bin/node /bin/npm
  sudo ln -s $NVM_DIR/versions/node/$(cat $NVM_DIR/alias/default)/bin/node /bin/npx
  sudo ln -s $NVM_DIR/versions/node/$(cat $NVM_DIR/alias/default)/bin/node /bin/corepack
else
  echo "Set/unset global default Node.js version.\n(Run as the user which you set up nvm)\nUsage: \nSet: \t ./nvm-global.sh i\nUnset: \t ./nvm-global.sh u"

fi
