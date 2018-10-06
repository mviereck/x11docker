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

[x11docker wiki](https://github.com/mviereck/x11docker/wiki) provides some how-to's for basic setups without x11docker.

 - Focus on [security](#security):
   - Avoids X security leaks by running [additional X servers](#choice-of-x-servers-and-wayland-compositors).
   - Restricts container capabilities to bare minimum.
   - Container user is same as host user to avoid root in container.
 - Low [dependencies](#dependencies):
   - No obliging dependencies on host beside X and docker. Recommended: `xpra` and `Xephyr`.
   - No dependencies inside of docker images except for some optional features.
 - [Optional features](#options): 
   - [Persistent data storage](#shared-folders-and-home-in-container) with shared host folders and a persistant `HOME` in container.
   - [Sound](#sound) with Pulseaudio or ALSA.
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
Just type `x11docker IMAGENAME [IMAGECOMMAND]`. 
 - Get an [overview of options](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview) with `x11docker --help`. 
 - For desktop environments in image add option `--desktop` (or short option `-d`).
 
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



# Options
Description of some commonly used [options](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview).

## Choice of X servers and Wayland compositors
If no X server option is specified, x11docker automatically chooses one depending on installed [dependencies](#dependencies) and on given or missing options `--desktop`, `--gpu` and `--wayland`.
 - [Overview of all possible X server and Wayland options.](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options)
 - [Hints to use option `--xorg` within X.](https://github.com/mviereck/x11docker/wiki/Setup-for-option---xorg)

## Desktop or seamless mode
x11docker assumes that you want to run a single application in seamless mode, i.e. a single window on your regular desktop. If you want to run a desktop environment in image, add option `--desktop`. 
 - Seamless mode is supported with options `--xpra` and `--nxagent`. As a fallback insecure option `--hostdisplay` is possible.
   - If neither `xpra` nor `nxagent` are installed, but x11docker finds a desktop capable X server like `Xephyr`, it avoids insecure option `--hostdisplay` and runs Xephyr with a host window manager.
     - You can specify a host window manager with option `--wm WINDOWMANAGER`, for example `--wm openbox`.
 - Desktop mode with `--desktop` is supported with all X server options except `--hostdisplay`. If available, x11docker prefers `Xephyr` and `nxagent` 
 
## Hardware acceleration
Hardware acceleration for OpenGL is possible with option `--gpu`. 
 - This will work out of the box in most cases with open source drivers on host. Otherwise have a look at [Dependencies](#option-dependencies). 
 - Closed source [NVIDIA drivers](https://github.com/mviereck/x11docker/wiki/NVIDIA-driver-support-for-docker-container) need some setup.
 
## Clipboard
Clipboard sharing is possible with option `--clipboard`. 
 - Image clips are possible with `--xpra` and `--hostdisplay`. 
 - Some X server options need package `xclip` on host.
 
## Sound
Sound is possible with options `--pulseaudio` and `--alsa`. 
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
Changes in a running docker container system will be lost, the created docker container will be discarded. For persistent data storage you can share host directories:
 - Option `--home` creates a host directory in `~/x11docker/IMAGENAME` that is shared with the container and mounted as its `HOME` directory. Files in container home and configuration changes will persist. 
 - Option `--sharedir DIR` mounts a host directory at the same location in container.
 - Option `--homedir DIR` is similar to `--home` but allows you to specify a custom host directory for data storage.
 - Special cases for `$HOME`:
   - `--homedir $HOME` will use your host home as container home. Discouraged, use with care.
   - `--sharedir $HOME` will symlink your host home as a subfolder of container home. 
   
## Wayland
To run  [Wayland](https://wayland.freedesktop.org/) instead of an X server x11docker provides options `--wayland`, `--weston`, `--kwin` and `--hostwayland`.
 - Option `--wayland` automatically sets up a Wayland environment with some related environment variables.
 - Options `--kwin` and `--weston` run Wayland compositors `kwin_wayland` or `weston`.
   - For QT5 applications without option `--wayland` add options `--dbus`  and `--env QT_QPA_PLATFORM=wayland`.
 - Option `--hostwayland` can run single applications on host Wayland desktops like Gnome 3, KDE 5 and [Sway](https://github.com/swaywm/sway).
 - Example: `xfce4-terminal` on Wayland: `x11docker --wayland x11docker/xfce xfce4-terminal`
 
 
## Init system
x11docker supports several init systems as PID 1 in container. Init in container solves the [zombie reaping issue](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/).
As default it uses `tini` in`/usr/bin/docker-init`. 
See also: [wiki: Init systems in docker: tini, systemd, SysVinit, runit, OpenRC and elogind.](https://github.com/mviereck/x11docker/wiki/Init-systems-in-docker:-tini,-systemd,-SysVinit,-runit,-OpenRC-and-elogind)

## DBus
Some desktop environments and applications need a running DBus daemon and/or DBus user session. 
 - use `--dbus` to run a DBus user session daemon.
 - use `--dbus-system` to run DBus system daemon. This includes option `--dbus`.
 - use `--hostdbus` to connect to host DBus user session.
 - use `--sharedir /run/dbus/system_bus_socket` to share host DBus system socket.

 
 
# Dependencies
x11docker can run with standard system utilities without additional dependencies on host or in image. 
As a core it only needs an `X` server and, of course, [`docker`](https://www.docker.com/) to run docker containers on X.
x11docker checks dependencies for chosen options on startup and shows terminal messages if some are missing. 

***TL;DR:*** Install `xpra Xephyr weston Xwayland xdotool xauth xclip xrandr xdpyinfo` on host, or leave it as it is.

## X server dependencies
All X server options with a description and their dependencies are listed in [wiki: X server and Wayland options](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options).

| Recommendations | Dependencies | Available options |
| --- | --- | --- |
| Minimal base | `Xorg` (probably already installed) | `--hostdisplay` <br> `--xorg` |
| Recommended base | `xpra` `Xephyr` | `--xpra` <br> `--xephyr` |
| Recommended base for `--gpu` | `xpra` `weston` `Xwayland` `xdotool` | `--xpra-xwayland` <br> `--weston-xwayland` <br> `--weston` <br> `--xwayland` |
| Recommended tools | `xauth` `xrandr` `xdpyinfo` | |

## Option dependencies
| Option | Dependencies on host | Dependencies in image |
| --- | --- | --- |
| `--clipboard` | `xclip` or `xsel` | - |
| `--gpu` | - | MESA OpenGL drivers. <br> Debian: `mesa-utils mesa-utils-extra` <br> CentOS: `glx-utils mesa-dri-drivers` <br> Arch Linux: `mesa-demos` <br> Alpine: `mesa-demos mesa-dri-ati mesa-dri-intel mesa-dri-nouveau mesa-dri-swrast` |
| `--gpu` with NVIDIA | | look at [x11docker wiki: NVIDIA driver](https://github.com/mviereck/x11docker/wiki/NVIDIA-driver-support-for-docker-container) |
| `--alsa` | - | optional: ALSA client libs. <br> Debian: `libasound2`, Arch, Alpine: `alsa-lib` |
| `--pulseaudio` | `pulseaudio` | `pulseaudio` client libs. <br> Debian: `libpulse0`, Arch: `libpulse`, Alpine: `pulseaudio-libs` |
| `--printer` | `cups` | CUPS client library. <br> Debian: `libcups2`, Arch: `libcups`, Alpine: `cups-libs` |
| `--lang` | - | Debian: `locales`, Alpine: not supported |
| `--xfishtank` | `xfishtank` | - |
| `--dbus` `--hostdbus` `--dbus-system` | - | `dbus` |
| `--launcher` | `xdg-utils` | - |
| `--install` `--update` `--update-master` | `wget` or `curl` <br> `unzip` | - |
   
## List of all host packages for all possible x11docker options
Debian package names: `kwin-wayland nxagent unzip weston wget xauth xclip  xdg-utils xdotool xdpyinfo xfishtank xpra xrandr xserver-xephyr xserver-xorg-video-dummy xvfb xwayland`, 
further (deeper surgery in system): `cups pulseaudio xserver-xorg-legacy`.



# Security 
Scope of x11docker is to run dockered GUI applications while preserving and improving container isolation.
Core concept is:
 - Run a second X server to avoid [X security leaks](http://www.windowsecurity.com/whitepapers/unix_security/Securing_X_Windows.html).
   - This in opposite to widespread solutions that share host X socket of display :0, thus breaking container isolation, allowing keylogging and remote host control. (x11docker provides this with option `--hostdisplay`).
   - Authentication is done with MIT-MAGIC-COOKIE, stored separate from file `~/.Xauthority`.
 - Create container user similar to host user to [avoid root in container](http://blog.dscpl.com.au/2015/12/don-run-as-root-inside-of-docker.html).
   - You can also specify another user with `--user=USERNAME` or a non-existing one with `--user=UID:GID`.
   - Disables possible root password and deletes entries in `/etc/sudoers`.
     - If you want root permissions in container, use option `--sudouser` that allows `su` and `sudo` with password `x11docker`. Alternatively you can run with `--user=root`. 
 - Reduce [container capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) to bare minimum.
   - Uses docker run options `--cap-drop=ALL --security-opt=no-new-privileges`. 
   - This restriction can be disabled with x11docker option `--cap-default` or reduced with `--sudouser`.

_Weaknesses:_
 - Possible SELinux restrictions are degraded for x11docker containers with docker run option `--security-opt label=type:container_runtime_t` to allow access to new X unix socket. 
   A more restrictive solution is desirable.
   Compare: [SELinux and docker: allow access to X unix socket in /tmp/.X11-unix](https://unix.stackexchange.com/questions/386767/selinux-and-docker-allow-access-to-x-unix-socket-in-tmp-x11-unix)
 - User namespace remapping is disabled to allow options `--home` and `--homedir` without file ownership issues. (Though, this is less an issue because x11docker already avoids root in container).

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
 - Cygwin/X also provides X server `Xwin` (option `--xwin`). Install `xinit` package in Cygwin.
 - For sound with option `--pulseaudio` install Cygwin in `C:/cygwin64` with package `pulseaudio`. It works for MSYS2 and WSL, too.
 - Error messages like `./x11docker: line 2: $'\r': command not found` indicate a wrong line ending conversion from git. Run `dos2unix x11docker`.
 - Not all x11docker options are implemented on MS Windows. E.g. `--webcam` and `--printer` do not work.
 
 
 
# Installation
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
### Minimal installation
For a first test, you can run with `bash x11docker` respective `bash x11docker-gui`. 
For minimal installation, make `x11docker` executable with `chmod +x x11docker` and move it to `/usr/bin`.



# Troubleshooting
For troubleshooting, run `x11docker` or `x11docker-gui` in a terminal. 
 - x11docker shows warnings if something is insecure, missing or going wrong. 
   - Use options `--stdout --stderr` (short `-Q`) to get application output, too.
   - Use option `--verbose` to see full logfile output.
     - Option `-D, --debug` gives a less verbose output. `-DQ` is short for `--debug --stdout --stderr`.
   - You can find the latest dispatched logfile at `~/.cache/x11docker/x11docker.log`.
 - Make sure your x11docker version is up to date with `x11docker --update` (latest release) or `x11docker --update-master` (latest beta).
 - Some applications need more privileges or capabilities than x11docker provides as default. 
   - Reduce container isolation with e.g.:
     - x11docker options: `--hostipc --hostnet --cap-default --sys-admin`
     - docker run options: `--cap-add ALL --security-opt seccomp=unconfined --privileged`
     - Example: `x11docker --hostipc --hostnet --cap-default --sys-admin -- --cap-add ALL --security-opt seccomp=unconfined --privileged -- imagename`
     - Try with reduced container isolation. If it works, drop options one by one until the needed one(s) are left.
     - If `--cap-add ALL` helps, find the [capability](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) you really need and add only that one.
     - If `--privileged` helps, your application probably needs a device in `/dev`. Find out which one and share it with e.g. `--device /dev/snd`.
   - You can try to run container applications as root with `--user=root`.
 - Get help in the [issue tracker](https://github.com/mviereck/x11docker/issues). 
   - Most times it makes sense to store the `--verbose`output (or `x11docker.log`) at [pastebin.com](https://pastebin.com/).

   

# Examples
[Some desktop image examples can be found on docker hub.](https://hub.docker.com/u/x11docker/)

| Application | x11docker command |
| --- | --- |
| Xfce4 Terminal | `x11docker x11docker/xfce xfce4-terminal` |
| GLXgears with hardware acceleration | `x11docker --gpu x11docker/xfce glxgears` |
| [Kodi media center](https://kodi.tv/) with hardware <br> acceleration, Pulseaudio sound <br> and shared `Videos` folder. <br> For setup look at [ehough/docker-kodi](https://github.com/ehough/docker-kodi). | `x11docker --gpu --pulseaudio --sharedir ~/Videos erichough/kodi`. |
| [XaoS](https://github.com/patrick-nw/xaos) fractal generator | `x11docker patricknw/xaos` |
| [Telegram messenger](https://telegram.org/) with persistant <br> `HOME` for configuration storage | `x11docker --home xorilog/telegram` |
| Firefox with shared `Download` folder. | `x11docker --sharedir $HOME/Downloads jess/firefox` |
| [Tor browser](https://www.torproject.org/projects/torbrowser.html) | `x11docker jess/tor-browser` |
| Chromium browser | `x11docker -- jess/chromium --no-sandbox` |
| VLC media player with shared `Videos` <br> folder and Pulseaudio sound | `x11docker --pulseaudio --sharedir=$HOME/Videos jess/vlc` |


| Desktop environment | x11docker command |
| --- | --- |
| FVWM (based on [Alpine](https://alpinelinux.org/), 22.5 MB) | `x11docker --desktop x11docker/fvwm` |
| fluxbox (based on Debian, 87 MB) | `x11docker --desktop x11docker/fluxbox` |
| [Lumina](https://lumina-desktop.org) (based on [Void Linux](https://www.voidlinux.org/))| `x11docker --desktop x11docker/lumina` |
| LXDE | `x11docker --desktop x11docker/lxde` |
| LXQt | `x11docker --desktop x11docker/lxqt` |
| Xfce | `x11docker --desktop x11docker/xfce` |
| [CDE Common Desktop Environment](https://en.wikipedia.org/wiki/Common_Desktop_Environment) | `x11docker --desktop --systemd --cap-default x11docker/cde` |
| Mate | `x11docker --desktop x11docker/mate` |
| Enlightenment (Based on [Void Linux](https://www.voidlinux.org/)) | `x11docker --desktop --gpu --runit x11docker/enlightenment` |
| [Trinity](https://www.trinitydesktop.org/) (successor of KDE 3) | `x11docker --desktop x11docker/trinity` |
| Cinnamon | `x11docker --desktop --gpu --dbus-system x11docker/cinnamon` |
| [deepin](https://www.deepin.org/en/dde/) | `x11docker --desktop --gpu --systemd x11docker/deepin` |
| [LiriOS](https://liri.io/) (Needs at least docker 18.06 <br> or this [xcb bugfix](https://github.com/mviereck/x11docker/issues/76).) (based on Fedora) | `x11docker --desktop --gpu lirios/unstable` |
| KDE Plasma | `x11docker --desktop --gpu x11docker/plasma` |
| KDE Plasma as nested Wayland compositor | `x11docker --gpu x11docker/plasma startplasmacompositor` |
| LXDE with wine and PlayOnLinux <br> and  a persistent `HOME` folder <br> to preserve installed Windows <br> applications, with Pulseaudio sound <br> and GPU hardware acceleration. | `x11docker --desktop --home --pulseaudio --gpu x11docker/lxde-wine` |
   
## Adjust images for your needs
For persistant changes of image system adjust Dockerfile and rebuild. To add custom applications to x11docker example images you can create a new Dockerfile based on them. Example:
```
# xfce desktop with VLC media player
FROM x11docker/xfce
RUN apt-get update && apt-get install -y vlc
```
  
## Screenshots
Sample screenshots are stored in [screenshot branch](https://github.com/mviereck/x11docker/tree/screenshots)

`x11docker --desktop x11docker/lxde-wine`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde-wine.png "LXDE desktop in docker")

`x11docker --desktop --gpu x11docker/plasma`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-plasma.png "KDE plasma desktop in docker")

`x11docker --desktop x11docker/lxqt`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxqt.png "LXQT desktop in docker"))

`x11docker --desktop --systemd --gpu x11docker/deepin`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-deepin.png "deepin desktop in docker")
