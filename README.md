# x11docker: Run graphical GUI applications and desktop environments in docker on a segregated X server or Wayland compositor.

 - Avoids common X security leaks.
 - Restricts container privileges to bare minimum.
 - Container user is similar to host user.
 - No dependencies inside of docker images.
 - Pulseaudio sound and GPU hardware acceleration possible.

# GUI for x11docker ![x11docker logo](/../screenshots/x11docker_klein.jpeg?raw=true "Optional Title")
To use `x11docker-gui`, you need to install package `kaptain`. 
 - On systems without a root password like Ubuntu, activate option `--sudo`.
 - For troubleshooting, run x11docker-gui in a terminal or use [Run in xterm]. Also you can activate option `--verbose`.
 - Package `kaptain` is not available in repositories of debian 9 and Ubuntu 16.04. You can install [kaptain for debian jessie](https://packages.debian.org/jessie/kaptain) respective [kaptain for Ubuntu 14.04](http://packages.ubuntu.com/trusty/kaptain) instead.

![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "Optional Title")

# Terminal usage
Just type `x11docker IMAGENAME [IMAGECOMMAND]`. Get an [options overview](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview) with `x11docker --help`. 

Make x11docker executable with `chmod +x x11docker` or run it with `bash x11docker` respective `bash x11docker-gui`. Or install it on your system (see below at chapter "Installation").
 
# Security 
 Main purpose of x11docker is to run dockered GUI applications while preserving container isolation.
 Core concept is:
   - Run a second X server to avoid X security leaks.
   - Create container user similar to host user to avoid root in container.
   - Reduce [container capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) to bare minimum (docker run option `--cap-drop=ALL`).

Avoiding X security leaks is done using an additional X server separate from X on host display :0. Authentication is done with MIT-MAGIC-COOKIE, stored separate from file `~/.Xauthority`.  (This in opposite to widespread solutions that share host X socket of display :0, thus breaking container isolation, allowing keylogging and remote host control. x11docker provides this  possibility with discouraged and insecure option `--hostdisplay`.)

 - Some options can degrade or break container isolation. Look at security info dialog to see the differences.
  
![x11docker-gui security screenshot](/../screenshots/x11docker-security.png?raw=true)

# Dependencies
x11docker can run with standard system utilities without additional dependencies on host or in image. As a core, it only needs X server (package `xorg`)  and, of course, docker (package `docker.io`) to run docker images on X. 

If no additional X server is installed, only less isolated option `--hostdisplay` will work out of the box within X, and option `--xorg` from console. As a well working base for convenience and security, it is recommended to install `xpra` and `xserver-xephyr`.

For some additional options, x11docker needs some packages to be installed on host.
It will check for them on startup and show terminal messages if some are missing. Options `--gpu`, `--pulseaudio` and `--dbus` have dependencies in image, too.
Look at dependencies dialog in x11docker-gui. 

![x11docker-gui dependencies screenshot](/../screenshots/x11docker-dependencies.png?raw=true)

# X servers and Wayland compositors to choose from
If no X server option is specified, x11docker automatically chooses one depending on installed dependencies and on given or missing options `--wm` and `--gpu`. If `--wm=none`, x11docker assumes a window manager or desktop environment in image and prefers `--xephyr`. Otherwise, it assumes a single application and prefers `--xpra`. If option `--gpu` is given, it prefers `--xpra-xwayland` or `--weston-xwayland`.
 
![x11docker-gui server screenshot](/../screenshots/x11docker-server.png?raw=true)

## Wayland
Beside the X servers to choose from there are options `--weston`, `--kwin` and `--hostwayland` to run pure Wayland applications without X. QT5 applications also need options `--dbus` and `--waylandenv` to use Wayland instead of X. (Option `--waylandenv` sets some environment variables to summon toolkits GTK3, QT5, Clutter, SDL, Elementary and Evas to use Wayland.) 
 - Example: KDE plasma shell (QT5) in a pure Wayland environment with hardware acceleration:
 
  `x11docker --kwin --waylandenv --dbus --gpu -- kdeneon/plasma:user-lts plasmashell`
  
These options are useful to test whether an application supports a pure Wayland environment. You can also test applications from host with option `--exe`. 

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

# Developer options
Collection of rarer needed but sometimes useful options.

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/x11docker-developer.png "developer options")

# Installation
You don't need to install x11docker, you can just run it as user with `bash x11docker` respective `bash x11docker-gui`. As root, you can install, update and remove x11docker on your system:
 - `x11docker --install` : install x11docker and x11docker-gui. 
 - `x11docker --update` : download and install latest version from github.
 - `x11docker --remove` : remove all files installed by x11docker.
 
Installs into `/usr/local/bin`. Creates an icon in `/usr/share/icons`. Creates an `x11docker.desktop` file in `/usr/share/applications`. Copies `README.md` and `LICENSE.txt` to `/usr/share/doc/x11docker`.

# Avoiding password prompt
There is no way to start naked docker in a secure way without a password.                                                          As long as you can share host system files as docker volumes, it is possible to manipulate root files from within a docker container. User namespace mapping does not help, as it can be disabled with docker run option `--userns=host`.
There are suggestions to become member of group docker. That is comfortable, but if anyone gets access to your user account, he can change your system without restrictions, and you would not notice.

One possibility working for docker as well as  for x11docker is to create a setgid wrapper for often used commands. Example:
- Create a starter script, I call it `xd_pcmanfm`:
```
#! /bin/bash
x11docker --no-password x11docker/lxde pcmanfm
```
- Save this script as root in `/usr/local/bin/` and make it executeable:
```
chmod +x /usr/local/bin/xd_pcmanfm
```
- Change group of script file to group docker:
```
chgrp docker /usr/local/bin/xd_pcmanfm
```
- Set setgid bit to execute script with docker group privileges:
```
chmod g+s /usr/local/bin/xd_pcmanfm
```
Now you can execute `xd_pcmanfm` without a password prompt. Be aware that this script may be exploited somehow, though x11docker has some basic exploit checks.

# Examples
Some example images can be found on docker hub: https://hub.docker.com/u/x11docker/

 - Run xfce desktop in Xephyr:
   
  `x11docker --xephyr  x11docker/xfce`
   
 - Run wine and playonlinux on xfce desktop in a Xephyr window, sharing a home folder to preserve settings and wine installations:

  `x11docker --xephyr --home  x11docker/xfce-wine-playonlinux`
   
 - Run playonlinux in an xpra-xwayland window, sharing a home folder to preserve settings and installations, sharing clipboard, enabling pulseaudio sound and GPU acceleration:

  `x11docker --xpra-xwayland --home --clipboard --pulseaudio --gpu x11docker/xfce-wine-playonlinux playonlinux`
  
## Screenshots
Sample screenshots can be found in [screenshot branch](https://github.com/mviereck/x11docker/tree/screenshots)

x11docker/lxde running in a Xephyr window:

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde.png "lxde desktop running in Xephyr window using x11docker")
