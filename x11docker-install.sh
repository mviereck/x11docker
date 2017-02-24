#! /bin/bash

# installation script for x11docker 
# https://github.com/mviereck/x11docker
#
# - copies x11docker and x11docker-gui to /usr/local/bin
# - installs icon in /usr/share/icons
# - creates x11docker.desktop file in /usr/share/applications

echo "Install, update or remove x11docker and x11docker-gui
syntax:

x11docker-install.sh [install]   Install x11docker on your system    
x11docker-install.sh  update     Install latest version downloading from github
x11docker-install.sh  remove     Remove installation
"

[ "0" = "$(id -u)" ] || {
  echo "Must run as root to install, update or remove x11docker. Exit."
  exit 1
}
error() { echo "Error: Something went wrong, sorry. Exit." ; exit 1; }

case $1 in
  update)
    installdir="/tmp/x11docker-install"
    mkdir $installdir
    cd $installdir
    [ $? ] || error

    echo "Downloading latest x11docker version from github"
    wget https://github.com/mviereck/x11docker/archive/master.zip
    [ $? ] || error

    echo "Unpacking archive"
    unzip master.zip
    [ $? ] || error
  
    cd $installdir/x11docker-master
  ;;
  ""|install) # install
    installdir=$(dirname $0)
  ;;
esac

case $1 in
  remove)
    echo "removing x11docker from your system"
    rm -v /usr/local/bin/x11docker
    rm -v /usr/local/bin/x11docker-gui
    rm -v /usr/share/applications/x11docker.desktop
    xdg-icon-resource uninstall --size 72 x11docker
  ;;
  ""|install|update)
    echo ""
    echo "Installing x11docker and x11docker-gui in /usr/local/bin"
    cp x11docker /usr/local/bin/
    chmod +x /usr/local/bin/x11docker
    cp x11docker-gui /usr/local/bin/
    chmod +x /usr/local/bin/x11docker-gui

    echo "Creating icon and application entry for x11docker"
    x11docker-gui --icon
    mv /tmp/x11docker.png ./
    xdg-icon-resource install --context apps --novendor --size 72 x11docker.png x11docker
    echo "[Desktop Entry]
Version=1.0
Type=Application
Name=x11docker
Comment=Run GUI applications in docker images
Exec=x11docker-gui
Icon=x11docker
Categories=System
" > /usr/share/applications/x11docker.desktop

    [ `command -v kaptain` ] || {
      echo "Warning: x11docker-gui needs package kaptain to provide a GUI,
  but kaptain not found on your system. 
  Please install package kaptain if you want to use x11docker-gui.
  x11docker itself does not need it."
    }

    if [ "$1" = "update" ] ; then
      echo "Removing downloaded files"
      cd ~
      rm -R $installdir
    fi
    
    echo "Installation ready"
  ;;
  *) echo "Error: Unknown option $1. Exit." ; exit 1 ;;
esac

