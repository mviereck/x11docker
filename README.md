# x11docker: Run GUI applications in docker ![x11docker logo](/../screenshots/x11docker_klein.jpeg?raw=true "Optional Title") 
## Avoiding X security leaks and hardening container security

 - Avoids X security leaks by running [additional X servers](#x-servers-and-wayland-compositors-to-choose-from).
 - Improves container [security](#security):
   - Restricts container capabilities to bare minimum.
   - Container user is same as host user to avoid root in container.
 - No dependencies inside of docker images.
 - No obliging [dependencies](#dependencies) on host beside X and docker. Recommended: `xpra` and `Xephyr`.
 - [Wayland](#wayland) support.
 - Optional features: 
   - Sound with pulseaudio or ALSA
   - Hardware acceleration for OpenGL
   - Clipboard sharing
   - Shared host folder as /home in container
 - [Network setup](#network-setup) with [SSH](#ssh-x-forwarding), [VNC](#vnc) or [HTML5](#html5-web-applications) possible.
 - Developed on debian 9. Tested on fedora 25, CentOS 7, openSUSE 42.3, Ubuntu 16.04, Manjaro 17, Mageia 6 and Arch Linux.
 - Easy to use. [Examples](#examples): 
    - `x11docker jess/cathode`
    - `x11docker --desktop --size 320x240 x11docker/lxde`
 
![x11docker-gui screenshot](/../screenshots/screenshot-retroterm.png?raw=true "Cathode retro term in docker") ![LXDE in xpra](/../screenshots/screenshot-lxde-small.png?raw=true "LXDE desktop in docker")

# GUI for x11docker
`x11docker-gui` is an optional graphical frontend for `x11docker`.
 - `x11docker-gui` needs package `kaptain`. If your distribution misses it, look at [kaptain repository](https://github.com/mviereck/kaptain). 
 - If `kaptain` is not installed on your system, `x11docker-gui` tries to use image [`x11docker/kaptain`](https://hub.docker.com/r/x11docker/kaptain/). 

![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "Optional Title")

# Terminal usage
Just type `x11docker IMAGENAME [IMAGECOMMAND]`. Get an [overview of options](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview) with `x11docker --help`. For desktop environments in image add option `--desktop`.
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
For troubleshooting, run `x11docker` or `x11docker-gui` in a terminal. x11docker shows warnings if something is insecure, missing or going wrong. Use option `--verbose` to see logfile output, too. Get help in the [issue tracker](https://github.com/mviereck/x11docker/issues).

# Password prompt
root permissions are needed only to run docker. X servers run as unprivileged user.

Running x11docker as unprivileged user:
 - x11docker checks whether docker needs a password to run and whether `su` or `sudo` are needed to get root privileges. A password prompt appears, if needed.
 - If that check fails and does not match your setup, use option `--pw FRONTEND`. `FRONTEND` can be one of `su sudo gksu gksudo lxsu lxsudo kdesu kdesudo beesu pkexec` or `none`.  

Running x11docker as root:
 - Commands other than `docker` are executed as unprivileged user determined with [`logname`](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/logname.html). (You  can specify another host user with `--hostuser USER`).
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
 - If docker daemon runs with `--selinux-enabled`, SELinux restrictions are degraded for x11docker containers with docker run option `--security-opt label=type:container_runtime_t` to allow access to new X unix socket. A more restrictive solution is desirable.
   Compare: [SELinux and docker: allow access to X unix socket in /tmp/.X11-unix](https://unix.stackexchange.com/questions/386767/selinux-and-docker-allow-access-to-x-unix-socket-in-tmp-x11-unix)
 - User namespace remapping is disabled for options `--home` and `--homedir` to avoid file ownership issues. (Though, this is less a problem as x11docker already avoids root in container).

### Options degrading container isolation
Most important:
  - `--hostdisplay` shares host X socket of display :0 instead of running a second X server. 
    - Danger of abuse is reduced providing so-called untrusted cookies, but do not rely on this. 
    - If additionally using `--gpu` or `--clipboard`, option `--ipc` and trusted cookies are enabled and no protection against X security leaks is left. 
    - If you don't care about container isolation, `x11docker --hostdisplay --gpu` is an insecure, but quite fast setup without any overhead.
  - `--gpu` allows access to GPU hardware. This can be abused to get window content from host ([palinopsia bug](https://hsmr.cc/palinopsia/)) and makes [GPU rootkits](https://github.com/x0r1/jellyfish) possible.
  - `--pulseaudio` and `--alsa` allow catching audio output and microphone input from host.
  
Rather special options reducing security, but not needed for regular use:
  - `--sudouser` allows sudo without password for container user. If an application breaks out of container, it can do anything. Includes option `--cap-default`.
  - `--cap-default` disables x11docker's container hardening and falls back to default docker container privileges.
  - `--ipc` sets docker run option `--ipc=host`. (Allows MIT-SHM / shared memory. Disables IPC namespacing.)
  - `--net` sets docker run option `--net=host`. (Allows dbus connection to host, Shares host network stack.)
   
![x11docker-gui security screenshot](/../screenshots/x11docker-security.png?raw=true)

# Dependencies
x11docker can run with standard system utilities without additional dependencies on host or in image. As a core, it only needs an `X` server and, of course, [`docker`](https://www.docker.com/) to run docker images on X.

x11docker checks dependencies for chosen options on startup and shows terminal messages if some are missing. 

Basics:
 - If no additional X server is installed, only less isolated option `--hostdisplay` will work out of the box within X, and option `--xorg` from console. (To use `--xorg` within X, look at [setup for option --xorg](#setup-for-option---xorg)).
 - As a **well working base** for convenience and security, it is recommended to install `xpra` and `Xephyr`. 
   - It is recommended to use latest stable xpra version from [http://xpra.org](http://xpra.org/). 
   - Alternativly, you can install `nxagent` for both seamless and desktop mode.
 - Already installed on most systems with an X server: `xrandr`, `xauth` and `xdpyinfo`.
 
Advanced usage:
 - **Hardware acceleration** with option `--gpu`
   - Beside `xpra`, also install `Xwayland`, `weston` and `xdotool`. (Not needed for `--xorg` and `--hostdisplay`)
   - Works best with open source drivers on host and OpenGL/Mesa in image. With closed source drivers on host, you need the very same driver version in image.
   - Packages for OpenGL/Mesa in image:
     - debian and Ubuntu images: `mesa-utils mesa-utils-extra`.
     - CentOS and fedora images: `glx-utils mesa-dri-drivers`
     - Arch Linux images: `mesa-demos`
 - For **sound** with option `--pulseaudio`, install `pulseaudio` on host and in image. Sound with `--alsa` has no dependencies. You can install ALSA libraries in image to support virtual devices (debian images: `libasound2`).
 - For **clipboard** sharing with `--clipboard` install `xclip`. (Not needed for `--xpra`, `--nxagent` and `--hostdisplay`).
 - Rarer needed dependencies for special options:
   - `--nxagent` provides a fast and lightweight alternative to `xpra` and `Xephyr`. Needs [`nxagent`](https://packages.debian.org/experimental/nxagent) to be installed.
   - `--kwin` and `--kwin-xwayland` need `kwin_wayland`, included in modern `kwin` packages.
   - `--xdummy` needs dummy video driver `xserver-xorg-video-dummy` (debian) or `xorg-x11-drv-dummy` (fedora).
   - `--xvfb` needs `Xvfb`
   - `--xfishtank` needs `xfishtank` to show a fish tank.
   - `--dbus` is needed only for QT5 application in Wayland. It needs `dbus-launch` (package `dbus-x11`) in image.
   - `--starter` needs `xdg-user-dir` to locate your `Desktop` folder for starter icons.
   - `--install`, `--update` and `--remove` need `unzip` and `xdg-icon-resource`.
 - List of all host packages for all possible x11docker options (debian package names): `xpra xserver-xephyr xvfb weston xwayland nxagent kwin xserver-xorg-video-dummy xfishtank xclip xdg-utils xauth xdotool xrandr unzip`, further (deeper surgery in system): `pulseaudio xserver-xorg-legacy`.

![x11docker-gui dependencies screenshot](/../screenshots/x11docker-dependencies.png?raw=true)

# X servers and Wayland compositors to choose from
If no X server option is specified, x11docker automatically chooses one depending on installed dependencies and on given or missing options `--desktop` and `--gpu`. 
 - For single applications, x11docker prefers `--xpra`. Alternativly, it tries `--nxagent`.
 - With option `--desktop`, x11docker assumes a desktop environment in image and prefers `--xephyr`. 
 - With option `--gpu` for hardware acceleration, x11docker prefers `--xpra-xwayland` for single applications, or `--weston-xwayland` for desktop environments. 
 - If none of above can be started due to missing dependencies, x11docker uses `--hostdisplay` or `--xorg`.
 
![x11docker-gui server screenshot](/../screenshots/x11docker-server.png?raw=true)

## Wayland
Beside the X servers to choose from there are options `--weston`, `--kwin` and `--hostwayland` to run pure [Wayland](https://wayland.freedesktop.org/) applications without X. QT5 applications (most of KDE) also need options `--dbus` and `--waylandenv` to use Wayland instead of X. (Option `--waylandenv` sets some environment variables to summon toolkits GTK3, QT5, Clutter, SDL, Elementary and Evas to use Wayland.) 
With combination `--kwin-native --sharewayland --dbus --waylandenv` you can run Wayland and X applications side by side.
 - Example: xfce4-terminal (GTK3) in Weston: 
 
  `x11docker --weston x11docker/xfce xfce4-terminal`
  
 - Example: KDE plasma shell (QT5) in a pure Wayland environment with hardware acceleration:
 
  `x11docker --kwin --waylandenv --dbus --gpu -- kdeneon/plasma:user-lts plasmashell`
  
You can also run Wayland applications from host with option `--exe`. 

 - Examples: gnome-calculator (GTK3) and neverball (SDL) from host in Weston without X:

  `x11docker --weston --exe gnome-calculator`
  
  `x11docker --weston --exe neverball`
  
## Setup for option --xorg
 - Option `--xorg` runs from console without additional setup. 
 - To run a second core Xorg server from within an already running X session, you have to edit or create file `/etc/X11/Xwrapper.config` and replace line:
```
allowed_users=console
```
with lines:
```
allowed_users=anybody
needs_root_rights=yes
```
On debian 9 and Ubuntu 16.04 you need to install package `xserver-xorg-legacy`. 
(Depending on your hardware and system setup, you may not need line `needs_root_rights=yes`).

## Custom access to X server
Running x11docker without an image name (or explicitly with option `--xonly`) creates an empty X server. In that case, or forced with option `--showenv`, x11docker writes some environment variables on stdout. You can use this for custom access to new X server. Example:
```
read Xenv < <(x11docker --xephyr --showenv)
echo $Xenv && export $Xenv
# run xterm from host on new X server
xterm   
# run docker image on new X server
docker run --env DISPLAY --env XAUTHORITY -v $XAUTHORITY:$XAUTHORITY -v $XSOCKET:$XSOCKET x11docker/xfce
```
If you like to, you can run two docker images sharing the same X server. Example:
```
read Xenv < <(x11docker --xephyr --showenv x11docker/lxde)  # LXDE desktop in Xephyr
echo $Xenv && export $Xenv
x11docker --hostdisplay x11docker/xfce thunar  # Thunar from another image appears on LXDE desktop
```

# Developer options
Collection of rarer needed but sometimes useful options.

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/x11docker-developer.png "developer options")

# Network setup
## SSH X forwarding
Example for an SSH setup with xpra:
```
read Xenv < <(x11docker --xdummy --display=30 x11docker/lxde pcmanfm)
echo $Xenv && export $Xenv
# replace "start" with "start-desktop" to forward a desktop environment
xpra start :30 --use-display --start-via-proxy=no
```
On another system in your network, attach with xpra over SSH:
```
xpra attach ssh:HOSTNAME:30     # replace HOSTNAME with IP or host name of ssh server
```
You can detach the SSH connection and reattach later again without terminating the application:
```
xpra detach ssh:HOSTNAME:30
```
You can stop xpra server without terminating x11docker:
```
xpra stop ssh:HOSTNAME:30
```
Warning: don't try this on localhost due to an xpra memory bug. On localhost, use `xpra attach :30` instead.

## HTML5 web applications
To provide dockered applications as HTML5 web applications, you need `xpra` and `websockify`. Example:
```
read Xenv < <(x11docker --xdummy  x11docker/lxde pcmanfm)
echo $Xenv && export $Xenv
# replace "start" with "start-desktop" to forward a desktop environment
xpra start $DISPLAY --use-display --html=on --bind-tcp=localhost:14500 --start-via-proxy=no
```
Now you can access your application at [http://localhost:14500](http://localhost:14500). Further infos at [xpra wiki: HTML5 clients](https://xpra.org/trac/wiki/Clients/HTML5).

### HTML5 web applications with GTK3 broadway
[Broadway](https://developer.gnome.org/gtk3/stable/gtk-broadway.html) is a GTK3 specific feature to allow HTML5 web applications. The image needs `libgtk-3-bin` (debian) or `gtk3` (Arch Linux) to be installed. A possible setup with x11docker:
```
x11docker --nothing --env BROADWAY_DISPLAY=:5 --env GDK_BACKEND=broadway \
          -- --publish=8085:8085 x11docker/xfce "broadwayd :5 & sleep 2 && xfce4-terminal"
```
Now you can access the dockered web application at http://localhost:8085. A sample setup without x11docker is [moondev/gtk3-docker](https://github.com/moondev/gtk3-docker). 

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


# Installation
As root, you can install, update and remove x11docker on your system:
 - `x11docker --install` : install x11docker and x11docker-gui. 
 - `x11docker --update` : download and install latest version from github.
 - `x11docker --remove` : remove all files installed by x11docker.
 
Installs into `/usr/bin`. Creates an icon in `/usr/share/icons`. Creates an `x11docker.desktop` file in `/usr/share/applications`. Copies `README.md` and `LICENSE.txt` to `/usr/share/doc/x11docker`.

Shortest way:
 - Download x11docker script only: 
   - `wget https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker -O /tmp/x11docker`
 - Run as root: `bash /tmp/x11docker --update`
 - Remove temporary file: `rm /tmp/x11docker`
 
## Simple but insecure alternative
There are short and simple but insecure alternatives for x11docker. 
### Alternative for single applications
This is similar to x11docker option `--hostdisplay`:
 - Share access to host X server with environment variable `DISPLAY` and X unix socket in `/tmp/.X11-unix`. 
 - Allow access with `xhost` for current local user and create a similar container user.
 - Allow shared memory with `--ipc=host` to avoid RAM access failures and rendering glitches due to extension `MIT-SHM`.
```
xhost +SI:localuser:$(id -un)
docker run --rm -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
            --user $(id -u):$(id -g) \
            --ipc=host \
            IMAGENAME IMAGECOMMAND
```
This nice short solution has the disadvantage of breaking container isolation. X security leaks like keylogging and remote host control can be abused by container applications.

### Alternative for desktop environments
This is similar to x1docker option `--xephyr`
 - Run Xephyr with disabled shared memory.
 - Share access to its unix socket `/tmp/.X11-unix/X1`.
 - Create unprivileged container user to avoid root in container.
```
Xephyr :1 -extension MIT-SHM &
docker run --rm -e DISPLAY=:1 \
            -v /tmp/.X11-unix/X1:/tmp/.X11-unix/X1:rw \
            --user $(id -u):$(id -g) \
            IMAGENAME IMAGECOMMAND
```
This solution is more secure than the above one as it does not give access to display :0 with host applications and does not need `--ipc=host`.

# Examples
Some example images can be found on docker hub: https://hub.docker.com/u/x11docker/

 - Single GUI application in container: 
   - Terminal: `x11docker x11docker/xfce xfce4-terminal`
   - Fractal generator XaoS: `x11docker patricknw/xaos` (xaos command defined in image with CMD)
   - glxgears with hardware acceleration: `x11docker --gpu x11docker/xfce glxgears`
   - Firefox with your host Firefox profile and shared download folder (with `--rw` to allow read/write access due to special setup in image): `x11docker --rw --env HOME=$HOME --sharedir $HOME/.mozilla --sharedir $HOME/.cache/mozilla --sharedir $HOME/Downloads -- jess/firefox`

 - Desktop in container: 
   - Xfce: `x11docker --desktop x11docker/xfce`
   - LXDE: `x11docker --desktop x11docker/lxde`
   - Mate: `x11docker --desktop x11docker/mate`
   - LXQT: `x11docker --desktop x11docker/lxqt`
   - Trinity: `x11docker --desktop x11docker/trinity`
   - Plasma: `x11docker --desktop kdeneon/plasma:user-lts`
   - LXDE desktop with wine and a persistent home folder to preserve settings and installed Windows applications: `x11docker --desktop --home x11docker/lxde-wine`
  
## Screenshots
Sample screenshots can be found in [screenshot branch](https://github.com/mviereck/x11docker/tree/screenshots)

`x11docker --desktop x11docker/lxde-wine`:
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde-wine.png "LXDE desktop in docker")

`x11docker --desktop x11docker/mate`:
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-mate.png "Mate desktop in docker")

`x11docker --desktop x11docker/lxqt`:
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxqt.png "LXQT desktop in docker")
