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
    mkdir /tmp/x11docker-install
    cd /tmp/x11docker-install
    [ $? ] || error

    echo "Downloading latest x11docker version from github"
    wget https://github.com/mviereck/x11docker/archive/master.zip
    [ $? ] || error

    echo "Unpacking archive"
    unzip master.zip
    [ $? ] || error
  
    cd /tmp/x11docker-install/x11docker-master
  ;;
esac

case $1 in
  ""|install|update)
    echo ""
    echo "Installing x11docker and x11docker-gui in /usr/local/bin"
    [ -e "./x11docker" ] || {
      echo "File x11docker not found in current folder.
  try '$0 update' instead. Exit."
      exit 1
    }
    cp x11docker /usr/local/bin/
    chmod +x /usr/local/bin/x11docker
    cp x11docker-gui /usr/local/bin/
    chmod +x /usr/local/bin/x11docker-gui

    echo "Creating icon and application entry for x11docker"
    x11docker-gui --icon
    xdg-icon-resource install --context apps --novendor --size 72 /tmp/x11docker.png x11docker
    rm /tmp/x11docker.png
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
      rm -R /tmp/x11docker-install
    fi
    
    echo "Installation ready"
  ;;
  remove)
    echo "removing x11docker from your system"
    rm -v /usr/local/bin/x11docker
    rm -v /usr/local/bin/x11docker-gui
    rm -v /usr/share/applications/x11docker.desktop
    xdg-icon-resource uninstall --size 72 x11docker
  ;;
  *) echo "Error: Unknown option $1. Exit." ; exit 1 ;;
esac

