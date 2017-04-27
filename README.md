# x11docker: Run graphical GUI applications and desktop environments in docker on a segregated X server or Wayland compositor.

 - Avoids common X security leaks.
 - Wayland and Xwayland support
 - No dependencies inside of docker images.
 - Pulseaudio sound support is possible.
 - GPU hardware acceleration is possible.

# GUI for x11docker ![x11docker logo](/../screenshots/x11docker_klein.jpeg?raw=true "Optional Title")
To use `x11docker-gui`, you need to install package `kaptain`. 
 - On systems without a root password like Ubuntu, activate option `--sudo`.
 - For troubleshooting, run x11docker-gui in a terminal or use [Run in xterm]. Also you can activate option `--verbose`.
 - Package `kaptain` is not available in repositories of debian 9 and Ubuntu 16.04. You can install [kaptain for debian jessie](https://packages.debian.org/jessie/kaptain) respective [kaptain for Ubuntu 14.04](http://packages.ubuntu.com/trusty/kaptain) instead.
 - x11docker-gui can look ugly on GTK based systems. As kaptain uses QT4, you can use `qtconfig`and select GUI style GTK+. 

![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "Optional Title")


# Installation
You don't need to install x11docker, you can just run it as user with `bash x11docker` respective `bash x11docker-gui`. As root, you can install, update and remove x11docker on your system:
 - `x11docker --install` : install x11docker and x11docker-gui. 
 - `x11docker --update` : download and install latest version from github.
 - `x11docker --remove` : remove all files installed by x11docker.
 
Installs into `/usr/local/bin`. Creates an icon in `/usr/share/icons`. Creates an `x11docker.desktop` file in `/usr/share/applications`. Copies `README.md` and `LICENSE.txt` to `/usr/share/doc/x11docker`.
 
 
# Security 
 - Main purpose of x11docker is to run dockered GUI applications while preserving container isolation.
 - Preserving container isolation is done using an additional X server separate from X on host display :0, thus avoiding X security leaks. (Most solutions in the web to run dockered GUI applications allow access to host X server, thus breaking container isolation and allowing access to host X resources like keylogging with `xinput test`).
 - Authentication is done with MIT-MAGIC-COOKIE, stored separate from file `~/.Xauthority`.  Container and new X server don't know cookies from host X server on display :0. (Except less secure option `--hostdisplay`)
 - Some options can degrade or break container isolation. Look at security info dialog to see the differences.
  
![x11docker-gui security screenshot](/../screenshots/x11docker-security.png?raw=true)

# X servers and Wayland compositors to choose from
x11docker creates a new X server on a new X socket. Instead of using display :0 from host, docker images will run on segregated display :1 or display :2 ... (with exception from option `--hostdisplay`)

If no additional X server like  `xpra` or `xserver-xephyr` is installed, and `x11-common` is not reconfigured (for use of option `--xorg`), only option `--hostdisplay` will work out of the box.
 
![x11docker-gui server screenshot](/../screenshots/x11docker-server.png?raw=true)

## Wayland
Beside the X servers to choose from there are options `--weston`, `--kwin` and `--hostwayland` to run pure Wayland applications without X. QT5 applications also need options `--dbus` and `--waylandenv` to use Wayland instead of X. (Option `--waylandenv` sets some environment variables to summon toolkits GTK3, QT5, Clutter, SDL, Elementary and Evas to use Wayland.) 
 - Example: KDE plasma shell (QT5) in a pure Wayland environment with hardware acceleration:
 
  `x11docker --kwin --waylandenv --dbus --gpu --hostuser -- kdeneon/plasma:user-lts plasmashell`
  
This options are useful to test whether an application supports a pure Wayland environment. You can also test applications from host with option `--exe`. 

 - Examples: gnome-calculator (GTK3) and neverball (SDL) from host in Weston without X:

  `x11docker --weston --exe gnome-calculator`
  
  `x11docker --weston --exe neverball`
## Setup for option --xorg
Option `--xorg` runs ootb from console. To run a second core Xorg server from within an already running X session, you have to edit file `/etc/X11/Xwrapper.conf` and replace line:

`allowed_users=console`

with lines:

`allowed_users=anybody`

`needs_root_rights=yes`

On debian 9 and Ubuntu 16.04 you need to install package `xserver-xorg-legacy`. 

## X server inside of image
Version  2.5 of x11docker also provides some options to run X or xpra inside of docker images. This was removed in 3.0 to keep the code easier. Version 2.5 is still available in [x11docker 2.5 branch](https://github.com/mviereck/x11docker/tree/x11docker_2.5) and can be used beneath actual x11docker versions.
 
# Dependencies
x11docker can run with standard system utilities without additional dependencies on host or in image. As a core, it only needs X server (package `xorg`)  and, of course, docker (package `docker.io`) to run docker images on X. 

For some additional options, x11docker needs some packages to be installed on host.
It will check for them on startup and show terminal messages if some are missing. Options `--gpu`, `--pulseaudio` and `--dbus` have dependencies in image, too.
Look at dependencies dialog in x11docker-gui. 

![x11docker-gui dependencies screenshot](/../screenshots/x11docker-dependencies.png?raw=true)

# Usage in terminal
x11docker askes for root password to run docker. On systems without a root password like Ubuntu or Sparky, use option `--sudo`, then x11docker uses `sudo` instead of `su` to run docker. x11docker itself should not run as root.

To run a docker image with new X server:
 -  `x11docker [OPTIONS] IMAGE [COMMAND]`
 -  `x11docker [OPTIONS] -- [DOCKER_RUN_OPTIONS] IMAGE [COMMAND [ARG1 ARG2 ...]]`
  
To run a host application on a new X server:
 -  `x11docker [OPTIONS] --exe COMMAND`
 -  `x11docker [OPTIONS] --exe -- COMMAND [ARG1 ARG2 ...]`

To run only an empty new X server:
 -  `x11docker [OPTIONS]`

Have a look at `x11docker --help` to see all options.

# Examples
Some example images can be found on docker hub: https://hub.docker.com/u/x11docker/

 - Run xfce desktop in Xephyr:
   
  `x11docker --xephyr  x11docker/xfce`
   
 - Run wine and playonlinux on xfce desktop in a sandbox in a Xephyr window, sharing a home folder to preserve settings and wine installations, and with a container user similar to your host user:

  `x11docker --xephyr --hostuser --home  x11docker/xfce-wine-playonlinux start`
   
 - Run playonlinux in a sandbox in an xpra window, sharing a home folder to preserve settings and installations, sharing clipboard, enabling pulseaudio sound, and with a container user similar to your host user:

  `x11docker --xpra --hostuser --home --clipboard --pulseaudio x11docker/xfce-wine-playonlinux playonlinux`

 - Run teamviewer
  
  `x11docker bbinet/teamviewer`
  
# Screenshots
Sample screenshots can be found in [screenshot branch](https://github.com/mviereck/x11docker/tree/screenshots)

x11docker/lxde running in a Xephyr window:

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde.png "lxde desktop running in Xephyr window using x11docker")
