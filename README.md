# x11docker: Run GUI applications in docker ![x11docker logo](/../screenshots/x11docker_klein.jpeg?raw=true "Optional Title") 
## Avoiding X security leaks and hardening container security

 - Avoids X security leaks by running additional X servers.
 - Restricts container privileges to bare minimum.
 - Container user is same as host user to avoid root in container.
 - No dependencies inside of docker images.
 - No obliging dependencies on host beside X and docker. Recommended: `xpra` and `Xephyr`.
 - Wayland support.
 - Optional features: 
   - Pulseaudio sound
   - Hardware acceleration for OpenGL
   - Clipboard sharing
   - Shared host folder as /home in container
 - Easy to use. Examples: 
    - `x11docker jess/cathode`
    - `x11docker --desktop --size 300x200 x11docker/lxde`
 
![x11docker-gui screenshot](/../screenshots/screenshot-retroterm.png?raw=true "Cathode retro term in docker") ![LXDE in xpra](/../screenshots/screenshot-lxde-small.png?raw=true "LXDE desktop in docker")

# GUI for x11docker
`x11docker` is independent from `x11docker-gui`.
 - `x11docker-gui` needs package `kaptain`. If your distribution misses it, look at repository [mviereck/kaptain](https://github.com/mviereck/kaptain). 
 - If `kaptain` is not installed on your system, `x11docker-gui` tries to use image [`x11docker/kaptain`](https://hub.docker.com/r/x11docker/kaptain/). 

![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "Optional Title")

# Terminal usage
Just type `x11docker IMAGENAME [IMAGECOMMAND]`. Get an [overview of options](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview) with `x11docker --help`. 
General syntax:
```
To run a docker image with new X server (auto-choosing X server):
  x11docker [OPTIONS] IMAGE [COMMAND]
  x11docker [OPTIONS] -- "[DOCKER_RUN_OPTIONS]" IMAGE [COMMAND [ARG1 ARG2 ...]]
To run a host application on a new X server:
  x11docker [OPTIONS] --exe COMMAND
  x11docker [OPTIONS] --exe -- COMMAND [ARG1 ARG2 ...]
```
Make x11docker executable with `chmod +x x11docker` or just run it with `bash x11docker` respective `bash x11docker-gui`. Or install it on your system (see below at chapter [Installation](#installation)).

# Troubleshooting
For troubleshooting, run `x11docker` or `x11docker-gui` in a terminal. x11docker shows some warnings if something is insecure or is going wrong. Additionally, you can use option `--verbose` to see logfile output. You can get help in the [issue tracker](https://github.com/mviereck/x11docker/issues).

# Password prompt
root permissions are needed only to run docker. X servers run as unprivileged user.

Running x11docker as unprivileged user:
 - x11docker checks whether docker needs a password to run and whether `su` or `sudo` are needed to get root privileges. A password prompt appears, if needed.
 - If that check fails and does not match your setup, use option `--pw FRONTEND`. `FRONTEND` can be one of `su sudo gksu gksudo lxsu lxsudo kdesu kdesudo pkexec` or `none`.  

Running x11docker as root:
 - Commands other than `docker` are executed as unprivileged user determined with [`logname`](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/logname.html).
 - Unfortunately, some systems do not provide `DISPLAY` and `XAUTHORITY` for root, but needed for nested X servers like Xephyr. In that case, tools like `gksu` or `gksudo` can help. 

# Security 
Main purpose of x11docker is to run dockered GUI applications while preserving and improving container isolation.
Core concept is:
   - Run a second X server to avoid [X security leaks](http://www.windowsecurity.com/whitepapers/unix_security/Securing_X_Windows.html).
     - This in opposite to widespread solutions that share host X socket of display :0, thus breaking container isolation, allowing keylogging and remote host control. (x11docker provides this with option `--hostdisplay`).
     - Authentication is done with MIT-MAGIC-COOKIE, stored separate from file `~/.Xauthority`.
   - Create container user similar to host user to [avoid root in container](http://blog.dscpl.com.au/2015/12/don-run-as-root-inside-of-docker.html).
   - Reduce [container capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) to bare minimum.
     - Uses docker run options `--cap-drop=ALL --security-opt=no-new-privileges`. 
     - This restriction can be disabled with x11docker options `--cap-default` or `--sudouser`.
   - Disallow write access to container root filesystem except `/tmp`.
     - Uses docker run options `--read-only --volume=/tmp` to restrict write access in container to `/tmp` only. 
     - To allow read/write access to whole container file system, use option `--rw`. 
     - This restriction is disabled for options `--sudouser` and `--user=root`.

Weaknesses / ToDo: 
 - If docker daemon runs with `--selinux-enabled`, it is disabled for x11docker containers as it inhibits access to X unix socket.
   Compare: [SELinux and docker: allow access to X unix socket in /tmp/.X11-unix](https://unix.stackexchange.com/questions/386767/selinux-and-docker-allow-access-to-x-unix-socket-in-tmp-x11-unix)
 - User namespace remapping has limited support and is disabled for options `--home` and `--homedir`.

### Options degrading container isolation
Most important:
  - `--hostdisplay` shares host X socket of display :0 instead of running a second X server. Danger of abuse is reduced providing so-called untrusted cookies. Along with option `--gpu`, option `--ipc` and trusted cookies are used and no protection against X security leaks is left. (If you don't care about container isolation, `x11docker --hostdisplay --gpu` is an insecure, but quite fast setup without any overhead.)
  - `--gpu` allows access to GPU hardware. This can be abused to get window content from host ([palinopsia bug](https://hsmr.cc/palinopsia/)) and makes [GPU rootkits](https://github.com/x0r1/jellyfish) possible.
  - `--pulseaudio` allows catching audio output and microphone input.
  
Rather special options reducing security, but not needed for regular use:
  - `--sudouser` allows sudo without password for container user. If an application breaks out of container, it can do anything. Includes option `--cap-default`.
  - `--cap-default` disables x11docker's container hardening and falls back to default docker container privileges.
  - `--ipc` sets docker run option `--ipc=host`. (Allows MIT-SHM / shared memory)
  - `--net` sets docker run option `--net=host`. (Allows dbus connection to host)
   
![x11docker-gui security screenshot](/../screenshots/x11docker-security.png?raw=true)

# Dependencies
x11docker can run with standard system utilities without additional dependencies on host or in image. As a core, it only needs an `X` server and, of course, `docker` to run docker images on X.

x11docker will check dependencies for chosen options on startup and shows terminal messages if some are missing. 

Basics:
 - If no additional X server is installed, only less isolated option `--hostdisplay` will work out of the box within X, and option `--xorg` from console. (To use `--xorg` within X, look at [setup for option --xorg](#setup-for-option---xorg)).
 - As a well working base for convenience and security, it is recommended to install `xpra` and `Xephyr`. (On Ubuntu also `Xvfb`). It is recommended to use latest xpra version from [http://xpra.org](http://xpra.org/).
 
Advanced usage:
 - Hardware acceleration with option `--gpu`
   - Beside `xpra`, also install `Xwayland`, `weston` and `xdotool`. 
   - Applications in image should already have installed their OpenGL dependencies. If not, install `libgl1-mesa-glx libglew2.0 libglu1-mesa libgl1-mesa-dri libdrm2 libgles2-mesa libegl1-mesa libxv1` in image (debian package names).
 - For sound with option `--pulseaudio`, install `pulseaudio` on host and in image. 
 - For clipboard sharing with `--clipboard` install `xclip`.
 - Rarer needed dependencies for special options:
   - `--dbus` is needed only for QT5 application in Wayland. It needs `dbus-launch` (package `dbus-x11`) in image.
   - `--nxagent` provides a fast and lightweight alternative to `xpra` and `Xephyr`. Needs [`nxagent`](https://packages.debian.org/experimental/nxagent) to be installed.
   - `--kwin`, `--kwin-native` and `--kwin-xwayland` need `kwin_wayland`, included in modern `kwin` packages.
   - Web application setup with xpra (see below) needs `websockify`. 
   - `--xdummy` needs `xserver-xorg-video-dummy` (debian) or `xorg-x11-drv-dummy` (fedora).
   - `--xvfb` needs `Xvfb`
 - List of all host packages for all possible x11docker options (debian package names): `xpra xserver-xephyr xvfb weston xwayland nxagent kwin xclip xdotool xserver-xorg-video-dummy websockify`, further (deeper surgery in system): `pulseaudio xserver-xorg-legacy`.

![x11docker-gui dependencies screenshot](/../screenshots/x11docker-dependencies.png?raw=true)

# X servers and Wayland compositors to choose from
If no X server option is specified, x11docker automatically chooses one depending on installed dependencies and on given or missing options `--desktop` and `--gpu`. 
 - For single applications, x11docker prefers `--xpra`.
 - With option `--desktop`, x11docker assumes a desktop environment in image and prefers `--xephyr`. 
 - With option `--gpu`, x11docker prefers `--xpra-xwayland` for single applications, or `--weston-xwayland` for desktop environments. 
 - If none of above can be started due to missing dependencies, x11docker uses `--hostdisplay` or `--xorg`.
 
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
```
allowed_users=console
```
with lines:
```
allowed_users=anybody
needs_root_rights=yes
```
On debian 9 and Ubuntu 16.04 you need to install package `xserver-xorg-legacy`. 

## Web applications
To provide dockered applications as HTML5 web applications, you need `xpra` and `websockify`. Example:
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

# Developer options
Collection of rarer needed but sometimes useful options.

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/x11docker-developer.png "developer options")

# Installation
You don't need to install x11docker, you can just run it as user with `bash x11docker` respective `bash x11docker-gui`. As root, you can install, update and remove x11docker on your system:
 - `x11docker --install` : install x11docker and x11docker-gui. 
 - `x11docker --update` : download and install latest version from github.
 - `x11docker --remove` : remove all files installed by x11docker.
 
Installs into `/usr/bin`. Creates an icon in `/usr/share/icons`. Creates an `x11docker.desktop` file in `/usr/share/applications`. Copies `README.md` and `LICENSE.txt` to `/usr/share/doc/x11docker`.

Shortest way:
 - Download x11docker script only: 
   - `wget https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker -O /tmp/x11docker`
 - Run as root: `bash /tmp/x11docker --update`
 - Remove temporary file: `rm /tmp/x11docker`

# Examples
Some example images can be found on docker hub: https://hub.docker.com/u/x11docker/

 - Single GUI application: fractal generator XaoS
   
  `x11docker patricknw/xaos  xaos`

 - Desktop: Xfce
   
  `x11docker --desktop  x11docker/xfce`
   
 - Run wine and playonlinux on xfce desktop in a Xephyr window, sharing a home folder to preserve settings and wine installations:

  `x11docker --xephyr --home  x11docker/xfce-wine-playonlinux`
   
 - Run playonlinux in an xpra-xwayland window, sharing a home folder to preserve settings and installations, sharing clipboard, enabling pulseaudio sound and GPU acceleration:

  `x11docker --xpra-xwayland --home --clipboard --pulseaudio --gpu x11docker/xfce-wine-playonlinux playonlinux`
  
## Screenshots
Sample screenshots can be found in [screenshot branch](https://github.com/mviereck/x11docker/tree/screenshots)

x11docker/lxde running in a Xephyr window:

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde.png "lxde desktop running in Xephyr window using x11docker")
