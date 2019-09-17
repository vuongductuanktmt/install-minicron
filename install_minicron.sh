#!/bin/bash
echo $(pwd)
set -e
cd $(pwd)
echo $(pwd)

#echo "Installing postgresql for db..."

#./scripts/install_postgresql.sh

echo "Parsing config..."

sudo cp -f minicron.toml /etc/
#sudo chown $USER:$USER /etc/minicron.toml

echo "setup ~/.ssh/ directory"

if [[ -d "/home/${USER}/.ssh/" ]];
then
        echo "Found ~/.ssh/ directory."
else
        echo "Not found ~/.ssh/ directory, so create it..."
        # mkdir /home/${USER}/.ssh/
fi;



VERSION="0.9.7"

OS="linux-x86_64"

echo "Installing mincron v$VERSION"

echo "OS detected as $OS"

DOWNLOAD_FILE="https://github.com/jamesrwhite/minicron/releases/download/v$VERSION/minicron-$VERSION-$OS.tar.gz"
# DOWNLOAD_FILE="http://localhost:8000/minicron-$VERSION-$OS.tar.gz"
TMP_TAR_LOCATION="/tmp/minicron-$VERSION-$OS.tar.gz"
TMP_DIR_LOCATION="/tmp/minicron-$VERSION-$OS"
LIB_LOCATION="/opt/minicron"
BIN_LOCATION="/usr/local/bin/minicron"
USE_LOCAL_TAR="1"

if [ "$USE_LOCAL_TAR" == "1" ]; then
  echo "Using local archive at crontab/installer/minicron-$VERSION-$OS.tar.gz and moving to $TMP_TAR_LOCATION"
  cp -f minicron-$VERSION-$OS.tar.gz $TMP_TAR_LOCATION
else
  echo "Downloding minicron from $DOWNLOAD_FILE to $TMP_TAR_LOCATION"
  (cd /tmp; curl -sL $DOWNLOAD_FILE -o $TMP_TAR_LOCATION)
fi

echo "Removing $TMP_DIR_LOCATION and extracting minicron from $TMP_TAR_LOCATION to $TMP_DIR_LOCATION"
(cd /tmp; rm -rf $TMP_DIR_LOCATION; tar xf $TMP_TAR_LOCATION)

echo "Removing archive $TMP_TAR_LOCATION"
rm $TMP_TAR_LOCATION

echo "Removing $LIB_LOCATION and creating $LIB_LOCATION (may require password)"
$SUDO rm -rf $LIB_LOCATION && $SUDO mkdir -p $LIB_LOCATION

echo "Moving $TMP_DIR_LOCATION to $LIB_LOCATION (may require password)"
$SUDO mv $TMP_DIR_LOCATION/* $LIB_LOCATION

echo "Removing $TMP_DIR_LOCATION"
rm -rf $TMP_DIR_LOCATION

echo "Removing $BIN_LOCATION and linking $BIN_LOCATION to $LIB_LOCATION/minicron (may require password)"
$SUDO rm -f $BIN_LOCATION && $SUDO ln -s $LIB_LOCATION/minicron $BIN_LOCATION
#echo "sudo -H -u ${USER} minicron server start --host 0.0.0.0" | sudo tee --append /etc/rc.local
echo "done!"
