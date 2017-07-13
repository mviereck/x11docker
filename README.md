# x11docker: Run GUI applications in docker ![x11docker logo](/../screenshots/x11docker_klein.jpeg?raw=true "Optional Title") 
## Avoiding X security leaks and hardening container security

 - Avoids X security leaks by running additional X servers.
 - Restricts container privileges to bare minimum.
 - Container user is same as host user to avoid root in container.
 - No dependencies inside of docker images.
 - Wayland support.
 - Optional features: 
   - Pulseaudio sound
   - Hardware acceleration for OpenGL
   - Clipboard sharing
   - Shared host folder as /home in container
   - Adjust properties of new X server like multiple outputs, rotation, scaling, dpi.
 - Easy to use. Example: `x11docker jess/cathode` 
 
![x11docker-gui screenshot](/../screenshots/screenshot-retroterm.png?raw=true "Cathode retro term in docker")

# GUI for x11docker
To use `x11docker-gui`, you need package `kaptain`. 
  - Package `kaptain` is not available in repositories of debian 9 and Ubuntu 16.04. You can install [kaptain for debian jessie](https://packages.debian.org/jessie/kaptain) respective [kaptain for Ubuntu 14.04](http://packages.ubuntu.com/trusty/kaptain) instead.

![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "Optional Title")

# Terminal usage
Just type `x11docker IMAGENAME [IMAGECOMMAND]`. Get an [overview of options](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview) with `x11docker --help`. 

Make x11docker executable with `chmod +x x11docker` or just run it with `bash x11docker` respective `bash x11docker-gui`. Or install it on your system (see below at chapter [Installation](#installation)).

# Troubleshooting
For troubleshooting, run `x11docker` or `x11docker-gui` in a terminal. x11docker shows some warnings if something is insecure or is going wrong. Additionally, you can use option `--verbose` to see logfile output. You can get help in the [issue tracker](https://github.com/mviereck/x11docker/issues).
 - On systems without a root password like Ubuntu, activate option `--sudo`.

# Security 
Main purpose of x11docker is to run dockered GUI applications while preserving container isolation.
Core concept is:
   - Run a second X server to avoid [X security leaks](http://www.windowsecurity.com/whitepapers/unix_security/Securing_X_Windows.html).
     - This in opposite to widespread solutions that share host X socket of display :0, thus breaking container isolation, allowing keylogging and remote host control. (x11docker provides this with option `--hostdisplay`).
     - Authentication is done with MIT-MAGIC-COOKIE, stored separate from file `~/.Xauthority`.
   - Reduce [container capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) to bare minimum.
     - Uses docker run options `--cap-drop=ALL --security-opt=no-new-privileges --read-only --volume=/tmp`. (This behaviour can be disabled with x11docker options `--cap-default` or `--sudouser`).
   - Create container user similar to host user to [avoid root in container](http://blog.dscpl.com.au/2015/12/don-run-as-root-inside-of-docker.html).

### Options degrading container isolation
Most important:
  - `--hostdisplay` shares host X socket of display :0 instead of running a second X server. Danger of abuse is reduced providing so-called untrusted cookies. Along with option `--gpu`, option `--ipc` and trusted cookies are used and no protection against X security leaks is left. (If you do not care about container isolation, this is a quite fast setup without any overhead.)
  - `--gpu` allows access to GPU hardware. This can be abused to get window content from host ([palinopsia bug](https://hsmr.cc/palinopsia/)) and makes [GPU rootkits](https://github.com/x0r1/jellyfish) possible.
  - `--pulseaudio` allows catching audio output and microphone input.
  
Rather special options reducing security, but not needed for regular use:
  - `--sudouser` allows sudo without password for container user. If an application breaks out of container, it can do anything. Includes option `--cap-default`.
  - `--cap-default` disables x11docker's container hardening and falls back to default docker container privileges.
  - `--ipc` sets docker run option `--ipc=host`. (Allows MIT-SHM / shared memory)
  - `--net` sets docker run option `--net=host`. (Allows dbus connection to host)
   
![x11docker-gui security screenshot](/../screenshots/x11docker-security.png?raw=true)

# Dependencies
x11docker can run with standard system utilities without additional dependencies on host or in image. As a core, it only needs X server (package `xorg`)  and, of course, docker (package `docker.io`) to run docker images on X. 

Basics:
 - If no additional X server is installed, only less isolated option `--hostdisplay` will work out of the box within X, and option `--xorg` from console. 
 - As a well working base for convenience and security, it is recommended to install `xpra`, `xserver-xephyr` and `xvfb`. (It's recommended to use latest xpra version from [http://xpra.org](http://xpra.org/)).
 
Advanced usage:
 - For hardware acceleration with option `--gpu`, also install `xwayland`, `weston` and `xdotool`. Applications in image should already have installed their OpenGL dependencies. If not, install `libgl1-mesa-glx libglew2.0 libglu1-mesa libgl1-mesa-dri libdrm2 libgles2-mesa libegl1-mesa libxv1` in image).
 - For sound with option `--pulseaudio`, install `pulseaudio` on host and in image. 
 - Rarer needed dependencies for special options:
   - Best native `--clipboard` support provides xpra. X servers other than xpra and nxagent need `xclip`.
   - `--dbus` is needed only for QT5 application in Wayland. It needs `dbus-launch` (package `dbus-x11`) in image.
   - `--nxagent` provides a fast and lightweight alternative to `xpra` and `xephyr`. Needs [`nxagent`](https://packages.debian.org/experimental/nxagent) to be installed.
   - `--kwin`, `--kwin-native` and `--kwin-xwayland` need `kwin_wayland`, included in modern `kwin` packages.
   - Web application setup (see below) needs package `websockify`. 
   - `--xdummy` needs `xserver-xorg-video-dummy`
   - `--xvfb` needs `xvfb`
 - List of all host packages for all possible x11docker options: `xpra xserver-xephyr xvfb weston xwayland nxagent kwin xclip xdotool xserver-xorg-video-dummy websockify`, further (deeper surgery in system): `pulseaudio xserver-xorg-legacy`.

x11docker will check dependencies for chosen options on startup and shows terminal messages if some are missing. (The package names above are valid for debian and its derivates like Ubuntu and Mint. They may be slightly different for other distributions).

![x11docker-gui dependencies screenshot](/../screenshots/x11docker-dependencies.png?raw=true)

# X servers and Wayland compositors to choose from
If no X server is specified, x11docker automatically chooses one depending on installed dependencies and on given or missing options `--wm` and `--gpu`. 
For single applications, x11docker prefers `--xpra`.
If `--wm=none`, x11docker assumes a window manager or desktop environment in image and prefers `--xephyr`. 
If option `--gpu` is given, it prefers `--xpra-xwayland` or `--weston-xwayland`. If none of them can be started due to missing dependencies, it uses `--hostdisplay` or `--xorg`.
 
![x11docker-gui server screenshot](/../screenshots/x11docker-server.png?raw=true)

## Wayland
Beside the X servers to choose from there are options `--weston`, `--kwin` and `--hostwayland` to run pure [Wayland](https://wayland.freedesktop.org/) applications without X. QT5 applications (most of KDE) also need options `--dbus` and `--waylandenv` to use Wayland instead of X. (Option `--waylandenv` sets some environment variables to summon toolkits GTK3, QT5, Clutter, SDL, Elementary and Evas to use Wayland.) 
With option `--kwin-native --sharewayland --dbus --waylandenv` you can run Wayland and X applications side by side.
 - Example: KDE plasma shell (QT5) in a pure Wayland environment with hardware acceleration:
 
  `x11docker --kwin --waylandenv --dbus --gpu -- kdeneon/plasma:user-lts plasmashell`
  
These options are useful to test whether an application supports a pure Wayland environment. You can also test applications from host with option `--exe`. 

 - Examples: gnome-calculator (GTK3) and neverball (SDL) from host in Weston without X:

  `x11docker --weston --exe gnome-calculator`
  
  `x11docker --weston --exe neverball`
  
## Setup for option --xorg
Option `--xorg` runs ootb from console. To run a second core Xorg server from within an already running X session, you have to edit file `/etc/X11/Xwrapper.config` and replace line:

`allowed_users=console`

with lines:

`allowed_users=anybody`

`needs_root_rights=yes`

On debian 9 and Ubuntu 16.04 you need to install package `xserver-xorg-legacy`. 

## Web applications
To provide dockered applications as HTML5 web applications, you need xpra and package `websockify`. Example:
```
read Xenv < <(x11docker --xdummy  x11docker/lxde pcmanfm)
echo $Xenv && export $Xenv
xpra start $DISPLAY --use-display --html=on --bind-tcp=localhost:14500
```
Now you can access your application at [http://localhost:14500](http://localhost:14500). Further infos at [xpra wiki: HTML5 clients](https://xpra.org/trac/wiki/Clients/HTML5).

## VNC
Sample setup for VNC access:
```
read Xenv < <(x11docker --xdummy  x11docker/lxde pcmanfm)
echo $Xenv && export $Xenv
x11vnc -localhost -noshm
```
In another terminal, start VNC viewer with `vncviewer localhost:0`.
See `man x11vnc`  for many details and further infos.
Option `-noshm` disables shared memory (MIT-SHM). To allow shared memory, remove `-noshm` and use isolation breaking x11docker option `--ipc`.

# Special options
Collection of rarer needed but sometimes useful options.

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/x11docker-developer.png "developer options")

# Installation
You don't need to install x11docker, you can just run it as user with `bash x11docker` respective `bash x11docker-gui`. As root, you can install, update and remove x11docker on your system:
 - `x11docker --install` : install x11docker and x11docker-gui. 
 - `x11docker --update` : download and install latest version from github.
 - `x11docker --remove` : remove all files installed by x11docker.
 
Installs into `/usr/local/bin`. Creates an icon in `/usr/share/icons`. Creates an `x11docker.desktop` file in `/usr/share/applications`. Copies `README.md` and `LICENSE.txt` to `/usr/share/doc/x11docker`.

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
