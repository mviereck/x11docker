# x11docker: ![x11docker logo](x11docker.png) Run GUI applications in docker
## Avoid X security leaks and improve container security

Graphical applications and desktops in docker are similar in usage to a Virtual
Machine. They are isolated from host in several ways. 
It is possible to run applications that would not run on host due to missing 
dependencies. 
For example, you can run latest development versions or outdated 
versions of applications, or even multiple versions at the same time.

Practical differences to a VM: 
Docker containers need much less resources. 
x11docker discardes containers after use. 
Persistant data and configuration storage is done with shared folders. 
Persistant container system changes can be done in Dockerfile. 
System changes in running containers are discarded after use.

[x11docker wiki](https://github.com/mviereck/x11docker/wiki) provides some Howto's for basic setups without x11docker.

 - Focus on [security](#security):
   - Avoids X security leaks by running [additional X servers](#choice-of-x-servers-and-wayland-compositors).
   - Restricts container capabilities to bare minimum.
   - Container user is same as host user to avoid root in container.
 - Low depedencies:
   - No obliging [dependencies](#dependencies) on host beside X and docker. Recommended: `xpra` and `Xephyr`.
   - No obliging [dependencies](#option-dependencies) inside of docker images.
 - [Optional features](#options): 
   - [Persistent data storage](#shared-folders-and-home-in-container) with shared host folders and a persistant `HOME` in container.
   - [Sound](#sound) with pulseaudio or ALSA.
   - [Hardware acceleration](#hardware-acceleration) for OpenGL.
   - [Clipboard](#clipboard) sharing.
   - [Printing](#printer) through CUPS.
   - [Webcam](#webcam) support.
   - [Language locale](#language-locales) creation.
 - [Wayland](#wayland) support.
 - Remote access with [SSH](https://github.com/mviereck/x11docker/wiki/Remote-access-with-SSH), [VNC](https://github.com/mviereck/x11docker/wiki/VNC) or [HTML5 in browser](https://github.com/mviereck/x11docker/wiki/Container-applications-running-in-Browser-with-HTML5) possible.
 - Supports [DBus](#dbus) and [init systems](#init-system) `tini`, `runit`, `openrc`, `SysVinit` and `systemd` in container. Supports also `elogind`.
 - Developed on Debian. Tested on several other Linux distributions. 
 - Runs also on MS Windows in [MSYS2, Cygwin and WSL](#msys2-cygwin-and-wsl-on-ms-windows).
 - Easy to use. [Examples](#examples): 
   - `x11docker jess/cathode`
   - `x11docker --desktop --size 320x240 x11docker/lxde`
 
![x11docker-gui screenshot](/../screenshots/screenshot-retroterm.png?raw=true "Cathode retro term in docker") ![LXDE in xpra](/../screenshots/screenshot-lxde-small.png?raw=true "LXDE desktop in docker")



# GUI for x11docker
`x11docker-gui` is an optional graphical frontend for `x11docker`. It runs from console, too.
 - `x11docker-gui` needs package `kaptain`. If your distribution misses it, look at [kaptain repository](https://github.com/mviereck/kaptain). 
 - If `kaptain` is not installed on your system, `x11docker-gui` uses image [`x11docker/kaptain`](https://hub.docker.com/r/x11docker/kaptain/). 

![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "GUI for x11docker")



# Terminal usage
Just type `x11docker IMAGENAME [IMAGECOMMAND]`. Get an [overview of options](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview) with `x11docker --help`. For desktop environments in image add option `--desktop` (or short option `-d`).
General syntax:
```
To run a docker image with new X server (auto-choosing X server):
  x11docker [OPTIONS] IMAGE [COMMAND]
  x11docker [OPTIONS] -- IMAGE [COMMAND [ARG1 ARG2 ...]]
  x11docker [OPTIONS] -- DOCKER_RUN_OPTIONS -- IMAGE [COMMAND [ARG1 ARG2 ...]]
To run a host application on a new X server:
  x11docker [OPTIONS] --exe COMMAND
  x11docker [OPTIONS] --exe -- COMMAND [ARG1 ARG2 ...]
To run only a new empty X server:
  x11docker [OPTIONS]
```



# Installation
### Minimal installation
For a first test, you can run with `bash x11docker` respective `bash x11docker-gui`. 
For manual installation, make x11docker executable with `chmod +x x11docker` and move it to `/usr/bin`.
### Installation options
As root, you can install, update and remove x11docker on your system:
 - `x11docker --install` : install x11docker and x11docker-gui from current directory. 
 - `x11docker --update` : download and install latest [release](https://github.com/mviereck/x11docker/releases) from github.
 - `x11docker --update-master` : download and install latest master version from github.
 - `x11docker --remove` : remove all files installed by x11docker.
 
Copies `x11docker` and `x11docker-gui` to `/usr/bin`. Creates an icon in `/usr/share/icons`. Creates `x11docker.desktop` in `/usr/share/applications`. Copies `README.md`, `CHANGELOG.md` and `LICENSE.txt` to `/usr/share/doc/x11docker`.
### Shortest way for first installation:
```
wget https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker -O /tmp/x11docker
sudo bash /tmp/x11docker --update
rm /tmp/x11docker
```



# Options
Description of some commonly used options. Get an [overview of all options](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview) with `x11docker --help`.

## Choice of X servers and Wayland compositors
If no X server option is specified, x11docker automatically chooses one depending on installed dependencies and on given or missing options `--desktop`, `--gpu` and `--wayland`.
 - [Overview of all possible X server and Wayland options.](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options)
 
## Desktop or seamless mode
x11docker assumes that you want to run a single application in seamless mode, i.e. a single window on your regular desktop. If you want to run a desktop environment in image, add option `--desktop`. 
 - Seamless mode is supported with options `--xpra` and `--nxagent`. As a fallback insecure option `--hostdisplay` is possible.
   - If neither `xpra` nor `nxagent` are installed, but x11docker finds a desktop capable X server like `Xephyr`, it avoids insecure option `--hostdisplay` and runs Xephyr with a host window manager.
     - You can specify a host window manager with option `--wm WINDOWMANAGER`, for example `--wm openbox`.
 - Desktop mode with `--desktop` is supported with all X server options except `--hostdisplay`. If available, x11docker prefers `Xephyr` and `nxagent` 
 
## Hardware acceleration
Hardware acceleration for OpenGL is possible with option `--gpu`. 
 - This will work out of the box in most cases with open source drivers on host. Otherwise have a look at [Dependencies](#option-dependencies). 
 - x11docker wiki provides some [background information about hardware acceleration for docker containers.](https://github.com/mviereck/x11docker/wiki/Hardware-acceleration)
 
## Clipboard
Clipboard sharing is possible with option `--clipboard`. 
 - Image clips are possible with `--xpra` and `--hostdisplay`. 
 - Some X server options need package `xclip` on host.
 
## Sound
Sound is possible with options `--pulseaudio` and `--alsa`. 
(Some background information is given in [x11docker wiki about sound for docker containers.](https://github.com/mviereck/x11docker/wiki/Pulseaudio-sound-over-TCP-or-with-shared-socket))
 - For pulseaudio sound with `--pulseaudio` you need `pulseaudio` on host and in image.
 - For ALSA sound with `--alsa` you can specify the desired sound card with e.g. `--env ALSA_CARD=Generic`. Get a list of available sound cards with `aplay -l`.
 
## Webcam
Webcams on host can be shared with option `--webcam`.
 - If webcam application in image fails, install `mesa-utils` (debian) or `mesa-demos` (arch) in image. 
 - `cheese` is not recommended. It needs `--systemd` and `--privileged`. Privileged setup is a no-go.
 - `guvcview` needs `--pulseaudio` or `--alsa`.
 
## Printer
Printers on host can be provided to container with option `--printer`. 
 - It needs CUPS on host, the default printer server for most linux distributions. 
 - The container needs package `libcups2` (debian) or `libcups` (arch).
 
## Language locales
x11docker provides option `--lang $LANG` for flexible language locale settings. 
 - x11docker will check on container startup if the desired locale is already present in image and enable it. 
 - If x11docker does not find the locale, it creates it on container startup. (Needs package `locales` in image.) 
 - Examples: `--lang de` for German, `--lang zh_CN` for Chinese, `--lang ru` for Russian, `--lang $LANG` for your host locale.
 - For support of chinese, japanese and korean characters install a font like `fonts-arphic-uming` in image.
 
## Shared folders and HOME in container
Changes in a running docker image are lost, the created docker container will be discarded. For persistent data storage you can share host directories:
 - Option `--home` creates a host directory in `~/x11docker/IMAGENAME` that is shared with the container and mounted as home directory. Files in container home and configuration changes will persist. 
 - Option `--sharedir DIR` mounts a host directory at the same location in container without setting `HOME`.
 - Option `--homedir DIR` is similar to `--home` but allows you to specify a custom host directory for data storage.
 - Special cases for `$HOME`:
   - `--homedir $HOME` will use your host home as container home. Discouraged, use with care.
   - `--sharedir $HOME` will mount your host home as a subfolder of container home. 
   
## Wayland
To run  [Wayland](https://wayland.freedesktop.org/) instead of an X server x11docker provides options `--wayland`, `--weston`, `--kwin` and `--hostwayland`.
 - Option `--wayland` automatically sets up a Wayland environment with some related environment variables.
 - Options `--kwin` and `--weston` run Wayland compositors `kwin_wayland` or `weston`.
   - For QT5 applications without option `--wayland` you need to manually add options `--dbus`  and `--env QT_QPA_PLATFORM=wayland`.
 - Option `--hostwayland` can run single applications on host Wayland desktops like Gnome 3, KDE 5 and [Sway](https://github.com/swaywm/sway).
 - Example: `xfce4-terminal` on Wayland: `x11docker --wayland x11docker/xfce xfce4-terminal`
 
## Init system
x11docker supports several init systems as PID 1 in container. Init in container solves the [zombie reaping issue](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/).
As default it uses `tini` in`/usr/bin/docker-init`. 
See also: [wiki: Init systems in docker: tini, systemd, SysVinit, runit, OpenRC and elogind.](https://github.com/mviereck/x11docker/wiki/Init-systems-in-docker:-tini,-systemd,-SysVinit,-runit,-OpenRC-and-elogind)

## DBus
Some desktop environments and applications need a running DBus daemon and/or DBus user session. 
 - use `--dbus-system` to run DBus system daemon. This includes option `--dbus`.
 - use `--dbus` to run image command with `dbus-launch` (fallback: `dbus-run-session`) for a DBus user session.
 - use `--hostdbus` to connect to host DBus user session.

 
 
# Dependencies
x11docker can run with standard system utilities without additional dependencies on host or in image. 
As a core it only needs an `X` server and, of course, [`docker`](https://www.docker.com/) to run docker images on X.
x11docker checks dependencies for chosen options on startup and shows terminal messages if some are missing. 

## X server dependencies
All X server options with a description and their dependencies are listed in [wiki: X server and Wayland options](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options).
 - If no additional X server is installed, only less isolated option `--hostdisplay` will work out of the box within X, and option `--xorg` from console. 
   (To use `--xorg` within X, look at [setup for option --xorg](https://github.com/mviereck/x11docker/wiki/Setup-for-option---xorg)).
 - As a **well working base** for convenience and security it is recommended to install [`xpra`](http://xpra.org/) (seamless mode) and `Xephyr` (nested desktop mode).
   - For advanced `--gpu` support also install `weston Xwayland xdotool`.
 - Useful tools, already installed on most systems with an X server: `xrandr`, `xauth` and `xdpyinfo`.
 - [Hints to use option `--xorg` within X.](https://github.com/mviereck/x11docker/wiki/Setup-for-option---xorg)
 
***TL;DR:*** Install `xpra Xephyr weston Xwayland xdotool xauth xrandr xdpyinfo`, or leave it as it is.
 
## Option dependencies
| Option | Dependencies on host | Dependencies in image |
| --- | --- | --- |
| `--clipboard` | `xclip` or `xsel` | - |
| `--gpu` | - | MESA OpenGL drivers. Debian: `mesa-utils mesa-utils-extra`, CentOS: `glx-utils mesa-dri-drivers`, Arch Linux: `mesa-demos`, Alpine: `mesa-demos mesa-dri-ati mesa-dri-intel mesa-dri-nouveau mesa-dri-swrast` |
| `--gpu` with NVIDIA | | see [x11docker wiki: NVIDIA driver](https://github.com/mviereck/x11docker/wiki/NVIDIA-driver-support-for-docker-container) |
| `--alsa` | - | optional: ALSA client libs. Debian: `libasound2` |
| `--pulseaudio` | `pulseaudio` | `pulseaudio` client libs. Debian: `libpulse0` |
| `--printer` | `cups` | CUPS client library. Debian: `libcups2`, Arch: `libcups` |
| `--lang` | - | `locales` |
| `--xfishtank` | `xfishtank` | - |
| `--dbus` `--hostdbus` `--dbus-system` | - | `dbus` |
| `--launcher` | `xdg-utils` | - |
| `--install` `--update` `--update-master` | `wget` `unzip` | - |
   
## List of all host packages for all possible x11docker options (debian package names):
`kwin-wayland nxagent unzip weston wget xauth xclip  xdg-utils xdotool xdpyinfo xfishtank xpra xrandr xserver-xephyr xserver-xorg-video-dummy xvfb xwayland`, further (deeper surgery in system): `cups pulseaudio xserver-xorg-legacy`.



# Security 
Scope of x11docker is to run dockered GUI applications while preserving and improving container isolation.
Core concept is:
   - Run a second X server to avoid [X security leaks](http://www.windowsecurity.com/whitepapers/unix_security/Securing_X_Windows.html).
     - This in opposite to widespread solutions that share host X socket of display :0, thus breaking container isolation, allowing keylogging and remote host control. (x11docker provides this with option `--hostdisplay`).
     - Authentication is done with MIT-MAGIC-COOKIE, stored separate from file `~/.Xauthority`.
   - Create container user similar to host user to [avoid root in container](http://blog.dscpl.com.au/2015/12/don-run-as-root-inside-of-docker.html).
     - You can also specify another user with `--user=USERNAME` or a non-existing one with `--user=UID:GID`.
     - If you want root permissions in container, use option `--sudouser` that allows `su` and `sudo` with password `x11docker`. Alternatively, you can run with `--user=root`. 
   - Disables possible root password and deletes entries in `/etc/sudoers`.
   - Reduce [container capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) to bare minimum.
     - Uses docker run options `--cap-drop=ALL --security-opt=no-new-privileges`. 
     - This restriction can be disabled with x11docker option `--cap-default` or reduced with `--sudouser`.

_Weaknesses:_
 - If docker daemon runs with `--selinux-enabled`, SELinux restrictions are degraded for x11docker containers with docker run option `--security-opt label=type:container_runtime_t` to allow access to new X unix socket. 
   A more restrictive solution is desirable.
   Compare: [SELinux and docker: allow access to X unix socket in /tmp/.X11-unix](https://unix.stackexchange.com/questions/386767/selinux-and-docker-allow-access-to-x-unix-socket-in-tmp-x11-unix)
 - User namespace remapping is disabled to allow options `--home` and `--homedir` without file ownership issues. (Though, this is less a problem as x11docker already avoids root in container).

## Options degrading container isolation
x11docker shows warning messages in terminal if chosen options degrade container isolation.

_Most important:_
  - `--hostdisplay` shares host X socket of display :0 instead of running a second X server. 
    - Danger of abuse is reduced providing so-called untrusted cookies, but do not rely on this. 
    - If additionally using `--gpu` or `--clipboard`, option `--hostipc` and trusted cookies are enabled and no protection against X security leaks is left. 
    - If you don't care about container isolation, `x11docker --hostdisplay --gpu` is an insecure, but quite fast setup without any overhead.
  - `--gpu` allows access to GPU hardware. This can be abused to get window content from host ([palinopsia bug](https://hsmr.cc/palinopsia/)) and makes [GPU rootkits](https://github.com/x0r1/jellyfish) possible.
  - `--pulseaudio` and `--alsa` allow catching audio output and microphone input from host.
  
_Rather special options reducing security, but not needed for regular use:_
  - `--sudouser` allows `su` and `sudo` with password `x11docker`for container user. If an application breaks out of container, it can do anything. Allows many container capabilties that x11docker would drop otherwise.
  - `--cap-default` disables x11docker's container security hardening and falls back to default docker container capabilities.
  - `--dbus-system`, `--systemd`, `--sysvinit`, `--openrc` and `--runit` allow some container capabilities that x11docker would drop otherwise. `--systemd` also shares access to `/sys/fs/cgroup`.
  - `--hostipc` sets docker run option `--ipc=host`. (Allows MIT-SHM / shared memory. Disables IPC namespacing.)
  - `--hostnet` sets docker run option `--net=host`. (Shares host network stack. Disables network namespacing. Container can spy on network traffic.)

  
  
# MSYS2, Cygwin and WSL on MS Windows
x11docker runs on MS Windows in [MSYS2](https://www.msys2.org/), [Cygwin](https://www.cygwin.com/) 
and [WSL (Windows subsystem for Linux)](https://docs.microsoft.com/en-us/windows/wsl/about).
 - Install X server [`VcXsrv`](https://sourceforge.net/projects/vcxsrv/) on Windows into `C:/Program Files/VcXsrv` (option `--vcxsrv`).
 - Cygwin/X also provides `Xwin` (option `--xwin`). Install `xinit` package in Cygwin.
 - For sound with option `--pulseaudio` install Cygwin in `C:/cygwin64` with package `pulseaudio`. It runs in MSYS2 and WSL, too.
 - Error messages like `./x11docker: line 2: $'\r': command not found` indicate a wrong line ending conversion from git. Run `dos2unix x11docker`.
 
 
 
# Troubleshooting
For troubleshooting, run `x11docker` or `x11docker-gui` in a terminal. 
 - x11docker shows warnings if something is insecure, missing or going wrong. 
 - Use option `--verbose` to see logfile output, too.
   - Option `--debug` can provide additional informations.
   - Use options `--stdout --stderr --silent` to get application output only.
   - You can find the latest dispatched logfile at `~/.cache/x11docker/x11docker.log`.
 - Make sure your x11docker version is up to date with `x11docker --update` (latest release) or `x11docker --update-master` (latest beta).
 - Some applications need more privileges or capabilities than x11docker provides as default.
   - Reduce container isolation with options `--hostipc --hostnet --cap-default --sys-admin` and try again. If the application runs, reduce this insecure options to encircle the issue.
   - You can run container application as root with `--user=root`.
 - Get help in the [issue tracker](https://github.com/mviereck/x11docker/issues). 
   - Most times it makes sense to store the `--verbose`output (or `x11docker.log`) at [pastebin](https://pastebin.com/).

   

# Examples
Some image examples can be found on docker hub: https://hub.docker.com/u/x11docker/

 - Single GUI application in container: 
   - Terminal: `x11docker x11docker/xfce xfce4-terminal`
   - [Telegram messenger](https://telegram.org/) with persistant `HOME` for configuration storage: 
     - `x11docker --home xorilog/telegram`
   - Fractal generator [XaoS](https://github.com/patrick-nw/xaos): `x11docker patricknw/xaos`
   - GLXgears with hardware acceleration: `x11docker --gpu x11docker/xfce glxgears`
   - Firefox with shared Download folder: `x11docker --hostipc --sharedir $HOME/Downloads jess/firefox` (Option `--hostipc` avoids tab crashes. Better avoid them in `about:config` setting `browser.tabs.remote.autostart` to `false`).
   - Chromium browser: `x11docker -- jess/chromium --no-sandbox`
   - [Tor browser](https://www.torproject.org/projects/torbrowser.html): `x11docker jess/tor-browser`
   - VLC media player with shared Video folder and pulseaudio sound: 
     - `x11docker --pulseaudio --sharedir=$HOME/Videos jess/vlc`
   - [Kodi](https://kodi.tv/): `x11docker --gpu erichough/kodi`. For setup look at [ehough/docker-kodi](https://github.com/ehough/docker-kodi).
   
 - Desktop in container: 
   - Minimal images:
     - FVWM: `x11docker --desktop x11docker/fvwm` (based on [alpine](https://alpinelinux.org/), 22.5 MB)
     - fluxbox: `x11docker --desktop x11docker/fluxbox` (based on debian, 87 MB)

   - Lightweight, small image:
     - [Lumina](https://lumina-desktop.org): `x11docker --desktop x11docker/lumina` (based on [Void Linux](https://www.voidlinux.org/))
     - LXDE: `x11docker --desktop x11docker/lxde`
     - LXQt: `x11docker --desktop x11docker/lxqt`
     - Xfce: `x11docker --desktop x11docker/xfce`
     - [CDE Common Desktop Environment](https://en.wikipedia.org/wiki/Common_Desktop_Environment): `x11docker --desktop --systemd --cap-default x11docker/cde`
     
   - Medium:
     - Mate: `x11docker --desktop x11docker/mate`
     - Enlightenment: `x11docker --desktop --gpu --runit x11docker/enlightenment` (Based on [Void Linux](https://www.voidlinux.org/))
     - [Trinity](https://www.trinitydesktop.org/) (successor of KDE 3): `x11docker --desktop x11docker/trinity`
     
   - Heavy, option `--gpu` recommended:
     - Cinnamon: `x11docker --desktop --gpu --dbus-system x11docker/cinnamon`
     - [deepin](https://www.deepin.org/en/dde/): `x11docker --desktop --gpu --systemd x11docker/deepin`
     - [LiriOS](https://liri.io/): `x11docker --desktop --gpu lirios/unstable` (Needs at least docker 18.06 or this [xcb bugfix](https://github.com/mviereck/x11docker/issues/76).)
     - KDE Plasma: `x11docker --desktop --gpu x11docker/plasma`
     - KDE Plasma as nested Wayland compositor: 
       - `x11docker --hostdisplay --gpu x11docker/plasma startplasmacompositor`
     
   - LXDE desktop with wine and a persistent home folder to preserve installed Windows applications, with pulseaudio sound and hardware acceleration: 
     - `x11docker --desktop --home --pulseaudio --gpu x11docker/lxde-wine`
   
## Adjust images for your needs
For persistant changes of image system, adjust Dockerfile and rebuild. To add custom applications to x11docker example images, you can create a new Dockerfile based on them. Example:
```
# xfce desktop with VLC media player
FROM x11docker/xfce
RUN apt-get update && apt-get install -y vlc
```
  
## Screenshots
Sample screenshots can be found in [screenshot branch](https://github.com/mviereck/x11docker/tree/screenshots)

`x11docker --desktop x11docker/lxde-wine`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde-wine.png "LXDE desktop in docker")

`x11docker --desktop --gpu x11docker/plasma`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-plasma.png "KDE plasma desktop in docker")

`x11docker --desktop x11docker/lxqt`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxqt.png "LXQT desktop in docker"))

`x11docker --desktop --systemd --gpu x11docker/deepin`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-deepin.png "deepin desktop in docker")
