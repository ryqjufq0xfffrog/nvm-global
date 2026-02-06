#!/usr/bin/sh

BINDIR=/usr/local/bin

#
# Check if $NVM_DIR is defined
#
if [ -z "$NVM_DIR" ]; then
  echo "Error: \$NVM_DIR is not defined."
  echo " (i) Check if nvm is installed correctly.";
  echo "(ii) Check if your shell is configured to use nvm.";
  echo "     (You can check it by running \"nvm -v\".)";
  echo "When you use nvm-global in a shell that is not configured for nvm,";
  echo "you have to set \$NVM_DIR before running nvm-global.";
  echo "(\$NVM_DIR is where you have installed nvm, typically \"\$HOME/.nvm\")";
  exit 1;
fi

#
# Try to load nvm
#
if [ -s "$NVM_DIR/nvm.sh" ]; then
  \. "$NVM_DIR/nvm.sh"
else
  echo "Error: nvm.sh was not found in \$NVM_DIR($NVM_DIR).";
  echo "This can be either because :";
  echo " (i) nvm was installed, but has been uninstalled.";
  echo "(ii) Your shell is misconfigured.";
  exit 1;
fi

#
# is nvm successfully loaded?
#
if ! command -v nvm >/dev/null;then
  echo "Error: Could not load nvm for unknown reason.";
  exit 1;
fi

if [ "$1" = "uninstall" ] || [ "$1" = "u" ]; then
  #
  # Remove globally installed node
  #
  # Check if the files about to be deleted are symlinks
  if { [ -f $BINDIR/node ] && [ ! -L $BINDIR/node ]; } || \
    { [ -f $BINDIR/npm ] && [ ! -L $BINDIR/npm ]; } || \
    { [ -f $BINDIR/npx ] && [ ! -L $BINDIR/npx ]; }; then
    echo "One or more of the files to delete was not a symbolic link."
    echo " Aborting. "
    exit 1;
  fi
  # Then remove.
  sudo rm -f $BINDIR/node $BINDIR/npm $BINDIR/npx
elif [ "$1" = "install" ] || [ "$1" = "i" ]; then
  #
  # Install node globally
  #
  # Prevent overwriting
  if { [ -f $BINDIR/node ] && [ ! -L $BINDIR/node ]; } || \
    { [ -f $BINDIR/npm ] && [ ! -L $BINDIR/npm ]; } || \
    { [ -f $BINDIR/npx ] && [ ! -L $BINDIR/npx ]; }; then
      # if it is not a symlink, preserve it.
      echo "Found one or more files named \"node\" or \"npm\" or \"npx\" in $BINDIR.";
      echo "Node.js or npm may have already been installed using other tools than npm-global.";
      echo "Try again after uninstalling Node.js :";
      echo "sudo apt remove nodejs npm\t\t\t# for Ubuntu or Debian."
      exit 1;
  fi
  # Check if symbolic link
  for binname in "node" "npm" "npx"; do
    if [ -L $BINDIR/$binname ]; then
      # if it is a symlink, users can choose to remove it.
      echo "There is already a symlink at \"$BINDIR/$binname\".";
      echo "This program cannot ensure that the link can be safely removed.";
      echo "($BINDIR/$binname is linked to $(readlink $BINDIR/$binname).)";
      read -p "Do you want to remove the symlink? [y/N] : " wanna_rm;
      if [ "$(echo $wanna_rm| tr [:lower:] [:upper:])" = "Y" ]; then
        sudo rm -f $BINDIR/$binname;
      else
        # Defaults to cancel.
        echo "Canceled.";
        exit 1;
      fi
    fi
  done
  #
  # Determine which version to install globally
  # Note that running nvm version without any following string
  # returns the currently activated one.
  #
  node_version=$(nvm version $2)
  #
  # Check if the Node version specified exists locally
  #
  if [ ! "$(echo $node_version | cut -c 1)" = "v" ]; then
    echo "The specified version \"$2\" is not available.";
    echo "  (i) Try again after running \"nvm install $2\"";
    echo " (ii) or run nvm-global with another version string.";
    echo "(iii) or run nvm-global without specifying version.";
    exit 1;
  fi
  # binary location.
  versions_dir="$NVM_DIR/versions/node"
  node_location="$versions_dir/$node_version/bin/node"
  # Create symlinks.
  sudo ln -s $node_location $BINDIR/node
  sudo ln -s $node_location $BINDIR/npm
  sudo ln -s $node_location $BINDIR/npx
  echo "Successfully installed Node.js $node_version"
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  #
  # Print help string
  #
  echo "nvm-global v0.0.2";
  echo "";
  echo "Creates symlinks of node.js binary in /usr/local/bin";
  echo "so that node.js installed with nvm is available for all users on this computer.";
  echo "(Run as the user which you have set up nvm)";
  echo "Usage :";
  echo "Create symlink : \t ./nvm-global.sh i <version string>";
  echo "Delete symlink : \t ./nvm-global.sh u";
  echo "(<version string> is optional. When omitted, nvm-global will use currently activated version of Node.)";
else
  # Defaults to do nothing but print them
  echo "No command specified;"
  echo "\"nvm-global -h\" for usage and more."
fi
