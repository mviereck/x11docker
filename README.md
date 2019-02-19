# x11docker: ![x11docker logo](x11docker.png) Run GUI applications in Docker
## Avoid X security leaks and enhance container security
### Introduction
x11docker allows to run graphical applications in Docker Linux containers.
 - [Docker](https://en.wikipedia.org/wiki/Docker_(software)) allows to run applications in an isolated [container](https://en.wikipedia.org/wiki/Operating-system-level_virtualization) environment. 
   The result is similar to a [virtual machine](https://en.wikipedia.org/wiki/Virtual_machine), but needs less resources.
 - Docker does not provide a [display server](https://en.wikipedia.org/wiki/Display_server) that would allow to run applications with a [graphical user interface](https://en.wikipedia.org/wiki/Graphical_user_interface).
 - x11docker fills the gap. It runs an [X display server](https://en.wikipedia.org/wiki/X_Window_System) on the host system and provides it to Docker containers.
 - Additionally x11docker does some [security setup](https://github.com/mviereck/x11docker#security) to enhance container isolation and to avoid X security leaks. 
   This allows a [sandbox](#sandbox) environment that fairly well protects the host system from possibly malicious or buggy software.

Software can be installed in a deployable Docker image with a rudimentary Linux system inside. 
This can help to run or deploy software that is difficult to install on several systems due to dependency issues. It is possible to run outdated versions or latest development versions side by side. 
Files to work on can be shared between host and container.

x11docker runs on Linux and (with some setup and limitations) on [MS Windows](#msys2-cygwin-and-wsl-on-ms-windows). x11docker is not adapted to run on macOS except in a Linux VM.

[x11docker wiki](https://github.com/mviereck/x11docker/wiki) provides some how-to's for basic setups without x11docker.

### Features
 - Focus on [security](#security):
   - Avoids X security leaks by running [additional X servers](#choice-of-x-servers-and-wayland-compositors).
   - Restricts container capabilities to bare minimum.
   - Container user is same as host user to avoid root in container.
 - Low [dependencies](#dependencies):
   - No obliging dependencies on host beside X and Docker. Recommended: `xpra` and `Xephyr`.
   - No dependencies inside of Docker images except for some optional features.
 - [Optional features](#options): 
   - [Persistent data storage](#shared-folders-and-home-in-container) with shared host folders and a persistent `HOME` in container.
   - [Sound](#sound) with Pulseaudio or ALSA.
   - [Hardware acceleration](#hardware-acceleration) for OpenGL.
   - [Clipboard](#clipboard) sharing.
   - [Printing](#printer) through CUPS.
   - [Webcam](#webcam) support.
   - [Language locale](#language-locales) creation.
   - [Wayland](#wayland) support.
   - Supports [DBus](#dbus) and [init systems](#init-system) `tini`, `runit`, `OpenRC`, `SysVinit` and `systemd` in container. Supports also `elogind`.
 - Remote access with [SSH](https://github.com/mviereck/x11docker/wiki/Remote-access-with-SSH), [VNC](https://github.com/mviereck/x11docker/wiki/VNC) 
   or [HTML5](https://github.com/mviereck/x11docker/wiki/Container-applications-running-in-Browser-with-HTML5) possible.
 - Easy to use. [Examples](#examples): 
   - `x11docker jess/cathode`
   - `x11docker --desktop --size 320x240 x11docker/lxde` (needs nested X server `Xephyr`)
 
![x11docker-gui screenshot](/../screenshots/screenshot-retroterm.png?raw=true "Cathode retro term in docker") ![LXDE in xpra](/../screenshots/screenshot-lxde-small.png?raw=true "LXDE desktop in docker")



## GUI for x11docker
`x11docker-gui` is an optional graphical frontend for `x11docker`. It runs from console, too.
 - `x11docker-gui` needs package `kaptain`. If your distribution misses it, look at [kaptain repository](https://github.com/mviereck/kaptain). 
 - If `kaptain` is not installed on your system, `x11docker-gui` uses image [`x11docker/kaptain`](https://hub.docker.com/r/x11docker/kaptain/). 

![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "GUI for x11docker")



## Terminal usage
Just type `x11docker IMAGENAME [COMMAND]`. 
 - Get an [overview of options](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview) with `x11docker --help`. 
   - For desktop environments in image add option `-d, --desktop`.
   - To run without X at all use option `-t, --tty`.
   - Get an interactive TTY with option `-i, --interactive`.
 - If startup fails, look at chapter [Troubleshooting](#troubleshooting).
 
General syntax:
```
To run a Docker image with new X server:
  x11docker [OPTIONS] IMAGE [COMMAND]
  x11docker [OPTIONS] -- IMAGE [COMMAND [ARG1 ARG2 ...]]
  x11docker [OPTIONS] -- DOCKER_RUN_OPTIONS -- IMAGE [COMMAND [ARG1 ARG2 ...]]
To run a host application on a new X server:
  x11docker [OPTIONS] --exe COMMAND
  x11docker [OPTIONS] --exe -- COMMAND [ARG1 ARG2 ...]
To run only a new empty X server:
  x11docker [OPTIONS] --xonly
```
`DOCKER_RUN_OPTIONS` are just added to `docker run` command without a check by x11docker.


## Options
Description of some commonly used [options](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview).

### Choice of X servers and Wayland compositors
If no X server option is specified, x11docker automatically chooses one depending on installed [dependencies](#dependencies) and on given or missing options `--desktop`, `--gpu` and `--wayland`.
 - [Overview of all possible X server and Wayland options.](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options)
   - [Hints to use option `--xorg` within X.](https://github.com/mviereck/x11docker/wiki/Setup-for-option---xorg)
   - Use option `-t, --tty` to run without X at all.

### Desktop or seamless mode
x11docker assumes that you want to run a single application in seamless mode, i.e. a single window on your regular desktop. If you want to run a desktop environment in image, add option `--desktop`. 
 - Seamless mode is supported with options `--xpra` and `--nxagent`. As a fallback insecure option `--hostdisplay` is possible.
   - If neither `xpra` nor `nxagent` are installed, but x11docker finds a desktop capable X server like `Xephyr`, it avoids insecure option `--hostdisplay` and runs Xephyr with a host window manager.
     - You can specify a host window manager with option `--wm WINDOWMANAGER`, for example `--wm openbox`.
 - Desktop mode with `--desktop` is supported with all X server options except `--hostdisplay`. If available, x11docker prefers `--xephyr` and `--nxagent`.
 
### Shared folders and HOME in container
Changes in a running Docker container system will be lost, the created Docker container will be discarded. For persistent data storage you can share host directories:
 - Option `-m, --home` creates a host directory in `~/.local/share/x11docker/IMAGENAME` that is shared with the container and mounted as its `HOME` directory. Files in container home and configuration changes will persist. 
   x11docker creates a softlink from `~/.local/share/x11docker` to `~/x11docker`.
 - Option `--sharedir DIR` mounts a host directory at the same location in container. `--sharedir DIR:ro` restricts to read-only access.
 - Option `--homedir DIR` is similar to `--home` but allows you to specify a custom host directory for data storage.
 - Special cases for `$HOME`:
   - `--homedir $HOME` will use your host home as container home. Discouraged, use with care.
   - `--sharedir $HOME` will symlink your host home as a subfolder of container home. 
   
Note that x11docker copies files from `/etc/skel` in container to `HOME` if `HOME` is empty. That allows to provide customized user settings.
 
### Hardware acceleration
Hardware acceleration for OpenGL is possible with option `-g, --gpu`. 
 - This will work out of the box in most cases with open source drivers on host. Otherwise have a look at [Dependencies](#option-dependencies). 
 - Closed source [NVIDIA drivers](https://github.com/mviereck/x11docker/wiki/NVIDIA-driver-support-for-docker-container) need some setup and support less [x11docker X server options](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options#attributes-of-x-server-and-wayland-options).
 
### Clipboard
Clipboard sharing is possible with option `-c, --clipboard`. 
 - Image clips are possible with `--xpra` and `--hostdisplay`. 
 - Some X server options need package `xclip` on host.
 
### Sound
Sound is possible with options `-p, --pulseaudio` and `--alsa`. 
 - For pulseaudio sound with `--pulseaudio` you need `pulseaudio` on host and in image.
 - For ALSA sound with `--alsa` you might need to specify a sound card with e.g. `--alsa=Generic`. Get a list of available sound cards with `aplay -l`.
   To support virtual ALSA devices like `dmix`, too, the image needs ALSA libraries, e.g. `libasound2` in debian images.
 
### Webcam
Webcams on host can be shared with option `--webcam`.
 - If webcam application in image fails, install `mesa-utils` (debian) or `mesa-demos` (arch) in image. 
 - `guvcview` needs `--pulseaudio` or `--alsa`.
 - `cheese` and [`gnome-ring`](https://ring.cx/) need `--systemd` or `--dbus-system`.
 
### Printer
Printers on host can be provided to container with option `--printer`. 
 - It needs CUPS on host, the default printer server for most linux distributions. 
 - The container needs package `libcups2` (debian) or `libcups` (arch).
 
### Language locales
x11docker provides option `--lang $LANG` for flexible language locale settings. 
 - x11docker will check on container startup if the desired locale is already present in image and enable it. 
 - If x11docker does not find the locale, it creates it on container startup. (Needs package `locales` in image.) 
 - Examples: `--lang de` for German, `--lang zh_CN` for Chinese, `--lang ru` for Russian, `--lang $LANG` for your host locale.
 - For support of chinese, japanese and korean characters install a font like `fonts-arphic-uming` in image.
   
### Wayland
To run  [Wayland](https://wayland.freedesktop.org/) instead of an X server x11docker provides options `--wayland`, `--weston`, `--kwin` and `--hostwayland`. 
For further description loot at [Overview of all possible X server and Wayland options](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options).
 - Option `--wayland` automatically sets up a Wayland environment with some related environment variables.
 - Options `--kwin` and `--weston` run Wayland compositors `kwin_wayland` or `weston`.
   - For QT5 applications without option `--wayland` add options `--dbus`  and `--env QT_QPA_PLATFORM=wayland`.
 - Option `--hostwayland` can run single applications on host Wayland desktops like Gnome 3, KDE 5 and [Sway](https://github.com/swaywm/sway).
 - Example: `xfce4-terminal` on Wayland: `x11docker --wayland x11docker/xfce xfce4-terminal`
 
 
### Init system
x11docker supports several init systems as PID 1 in container. Init in container solves the [zombie reaping issue](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/).
As default it uses `tini` in`/usr/bin/docker-init`. 
Look at [x11docker wiki: Init systems in Docker: tini, systemd, SysVinit, runit, OpenRC and elogind.](https://github.com/mviereck/x11docker/wiki/Init-systems-in-docker:-tini,-systemd,-SysVinit,-runit,-OpenRC-and-elogind)

### DBus
Some desktop environments and applications need a running DBus daemon and/or DBus user session. 
 - use `--dbus` to run a DBus user session daemon.
 - use `--dbus-system` to run DBus system daemon. This includes option `--dbus`.
   - If startup fails or takes about 90s, install an init system and use that one to run DBus. E.g. install `systemd` in image and run with `--systemd`.
 - use `--hostdbus` to connect to host DBus user session.
 - use `--sharedir /run/dbus/system_bus_socket` to share host DBus system socket.
 - DBus will be started automatically with [init](#Init-system) options `--systemd`, `--openrc`, `--runit` and `--sysvinit`.

 
 
## Dependencies
x11docker can run with standard system utilities without additional dependencies on host or in image. 
As a core it only needs an `X` server and, of course, [`docker`](https://www.docker.com/) to run Docker containers on X.
x11docker checks dependencies for chosen options on startup and shows terminal messages if some are missing. 

***TL;DR:*** Install `xpra Xephyr weston Xwayland xdotool xauth xclip xrandr xdpyinfo` on host, or leave it as it is.

### X server dependencies
All X server options with a description and their dependencies are listed in [wiki: X server and Wayland options](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options).

| Recommendations | Dependencies | Available options |
| --- | --- | --- |
| Minimal base | `Xorg` (probably already installed) | `--hostdisplay` <br> `--xorg` |
| Recommended base | `xpra` `Xephyr` | `--xpra` <br> `--xephyr` |
| Recommended base for `--gpu` | `xpra` `weston` `Xwayland` `xdotool` | `--xpra-xwayland` <br> `--weston-xwayland` <br> `--weston` <br> `--xwayland` <br> `--wayland` |
| Recommended tools | `xauth` `xrandr` `xdpyinfo` | |

Note that [`--gpu` support with proprietary NVIDIA drivers](https://github.com/mviereck/x11docker/wiki/NVIDIA-driver-support-for-docker-container) is possible only for options `--hostdisplay` and `--xorg`.

### Option dependencies
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
   
### List of all host packages for all possible x11docker options
Debian package names: `kwin-wayland nxagent unzip weston wget xauth xclip  xdg-utils xdotool xdpyinfo xfishtank xpra xrandr xserver-xephyr xserver-xorg-video-dummy xvfb xwayland`, 
further (deeper surgery in system): `cups pulseaudio xserver-xorg-legacy`.



## Security 
Scope of x11docker is to run containerized GUI applications while preserving and improving container isolation.
Core concept is:
 - Runs a second X server to avoid [X security leaks](http://tutorials.section6.net/home/basics-of-securing-x11).
   - This in opposite to widespread solutions that share host X socket of display :0, thus breaking container isolation, allowing keylogging and remote host control. 
     (However, x11docker provides this with fallback option `--hostdisplay`).
   - Authentication is done with MIT-MAGIC-COOKIE, stored separate from file `~/.Xauthority`.
 - Creates container user similar to host user to [avoid root in container](http://blog.dscpl.com.au/2015/12/don-run-as-root-inside-of-docker.html).
   - You can also specify another user with `--user=USERNAME` or a non-existing one with `--user=UID:GID`.
   - Disables possible root password and deletes entries in `/etc/sudoers`.
     - If you want root permissions in container, use option `--sudouser` that allows `su` and `sudo` with password `x11docker`. Alternatively you can run with `--user=root`. 
   - If you want to use `USER` specified in image instead, set option `--user=RETAIN`. x11docker won't change `etc/passwd` or `/etc/sudoers` in that case. Option `--home` won't be available.
 - Reduces [container capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) to bare minimum.
   - Sets docker run options `--cap-drop=ALL --security-opt=no-new-privileges`. 
   - This restriction can be disabled with x11docker option `--cap-default` or reduced with `--sudouser`.

_Weaknesses:_
 - Possible SELinux restrictions are degraded for x11docker containers with docker run option `--security-opt label=type:container_runtime_t` to allow access to new X unix socket. 
   A more restrictive solution is desirable.
   Compare: [SELinux and Docker: allow access to X unix socket in /tmp/.X11-unix](https://unix.stackexchange.com/questions/386767/selinux-and-docker-allow-access-to-x-unix-socket-in-tmp-x11-unix)
 - User namespace remapping is disabled to allow options `--home` and `--homedir` without file ownership issues. (Though, this is less an issue because x11docker already avoids root in container). 
   Exception: User namespace remapping is not disabled for `--user=RETAIN`.
 - x11docker provides several different X server options. Each X server involved might have its individual vulnerabilities. x11docker only covers well-known X security leaks that result from X11 protocol.

### Options degrading container isolation
x11docker shows warning messages in terminal if chosen options degrade container isolation. Note that x11docker does not check custom `DOCKER_RUN_OPTIONS`.

_Most important:_
  - `--hostdisplay` shares host X socket of display :0 instead of running a second X server. 
    - Danger of abuse is reduced providing so-called untrusted cookies, but do not rely on this. 
    - If additionally using `--gpu` or `--clipboard`, option `--hostipc` and trusted cookies are enabled and no protection against X security leaks is left. 
    - If you don't care about container isolation, `x11docker --hostdisplay --gpu` is an insecure but quite fast setup without any overhead.
  - `--gpu` allows access to GPU hardware. This can be abused to get window content from host ([palinopsia bug](https://hsmr.cc/palinopsia/)) and makes [GPU rootkits](https://github.com/x0r1/jellyfish) possible.
  - `--pulseaudio` and `--alsa` allow catching audio output and microphone input from host.
  
_Rather special options reducing security, but not needed for regular use:_
  - `--sudouser` allows `su` and `sudo` with password `x11docker`for container user. 
    If an application somehow breaks out of container, it can harm your host system. Allows many container capabilties that x11docker would drop otherwise.
  - `--cap-default` disables x11docker's container security hardening and falls back to default Docker container capabilities.
  - `--dbus-system`, `--systemd`, `--sysvinit`, `--openrc` and `--runit` allow some container capabilities that x11docker would drop otherwise. 
    `--systemd` also shares access to `/sys/fs/cgroup`. Some processes will run as root in container.
  - `--hostipc` sets docker run option `--ipc=host`. (Allows MIT-SHM / shared memory. Disables IPC namespacing.)
  - `--hostnet` sets docker run option `--net=host`. (Shares host network stack. Disables network namespacing. Container can spy on network traffic.)

### Sandbox
Container isolation enhanced with x11docker allows to use containers as a [sandbox](https://en.wikipedia.org/wiki/Sandbox_(computer_security)) that fairly well protects the host system from possibly malicious or buggy software.
Though, no sandbox solution in the wild can provide a perfect secure protection, and Docker even with enhanced security settings from x11docker is no exception.

Using Docker with x11docker as a sandbox is not intended to run obviously evil software. Rather use it as:
 - Compatibility environment to run software that is hard or impossible to install on host due to dependency issues.
 - Development environment to collect libraries, compiler and so on to keep the host clean.
 - Development environment to mitigate damage caused by unexpected/buggy behaviour.
 - Security layer for software that may be malicious in worst case. Examples: Internet browser with Javascript enabled, or wine with Windows applications.

x11docker already restricts process capabilities. You can additionally restrict access to CPU and RAM with option `--limit`. 
As default `--limit` restricts to 50% of available CPUs and 50% of currently free RAM. Another amount can be specified with `--limit=FACTOR` with a `FACTOR` greater than zero and less than or equal 1.

For more custom fine tuning have a look at [Docker documentation: Limit a container's resources](https://docs.docker.com/config/containers/resource_constraints).

**NOTE**: Internet access is allowed per default. You can disable internet access with `--no-internet`.

**WARNING**: There is no restriction that can prevent the container from flooding the hard disk in Docker's container partition or in shared folders.
  
  
## MSYS2, Cygwin and WSL on MS Windows
x11docker runs on MS Windows in [MSYS2](https://www.msys2.org/), [Cygwin](https://www.cygwin.com/) 
and [WSL (Windows subsystem for Linux)](https://docs.microsoft.com/en-us/windows/wsl/about).
Although it basically works, it misses some features available on Linux and cannot be guaranteed to be as reliable as on Linux.
However, running in a Linux VM instead of running natively on Windows is fully supported.
Setup:
 - Install X server [`VcXsrv`](https://sourceforge.net/projects/vcxsrv/) on Windows into `C:/Program Files/VcXsrv` (option `--vcxsrv`).
  - Alternative: Cygwin provides X server `Xwin` (option `--xwin`). Install `xinit` package in Cygwin. Can be used in Cygwin only.
 - For sound with option `--pulseaudio` install Cygwin in `C:/cygwin64` with package `pulseaudio`. It works for MSYS2 and WSL, too.
 - Error messages like `./x11docker: line 2: $'\r': command not found` indicate a wrong line ending conversion from git. Run `dos2unix x11docker`.
 - Not all x11docker options are implemented on MS Windows. E.g. `--webcam` and `--printer` do not work.
 - Firewall settings in Windows can cause issues for container applications accessing the X server. 
   If everything starts up without an obvious error, but no application window appears, look at issue [#108](https://github.com/mviereck/x11docker/issues/108).
 
 
 
## Installation
Note that x11docker is just a **bash script** without library dependencies.
### Installation options
As root you can install, update and remove x11docker on your system:
 - `x11docker --install` : install x11docker and x11docker-gui from current directory. 
 - `x11docker --update` : download and install latest [release](https://github.com/mviereck/x11docker/releases) from github.
 - `x11docker --update-master` : download and install latest master version from github.
 - `x11docker --remove` : remove all files installed by x11docker.
 
Copies `x11docker` and `x11docker-gui` to `/usr/bin`. Creates an icon in `/usr/share/icons`. 
Creates `x11docker.desktop` in `/usr/share/applications`. Copies `README.md`, `CHANGELOG.md` and `LICENSE.txt` to `/usr/share/doc/x11docker`.
### Shortest way for first installation:
Remove `sudo` and run as root if your system does not use sudo.
```
curl -fsSL https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker | sudo bash -s -- --update
```
### Minimal installation
For a first test you can run with `bash x11docker` respective `bash x11docker-gui`. 
For minimal installation make `x11docker` executable with `chmod +x x11docker` and move it to `/usr/bin` (or another location in `PATH`).
Other files than `x11docker` script itself are not essential.



## Troubleshooting
For troubleshooting, run `x11docker` or `x11docker-gui` in a terminal. 
 - x11docker shows warnings if something is insecure, missing or going wrong. 
   - Use option `-v, --verbose` to see full logfile output.
     - Option `-D, --debug` gives a less verbose output.
     - You can find the latest dispatched logfile at `~/.cache/x11docker/x11docker.log`.
 - Some applications fail with fallback option `--hostdisplay`. Add `--clipboard` to disable some security restrictions.
   If that does not help, install [additional X servers](#dependencies).
 - Make sure your x11docker version is up to date with `x11docker --update` (latest release) or `x11docker --update-master` (latest beta).
 - The image may have a `USER` specification and be designed for this user. 
   x11docker sets up a container user that can mismatch this user setup. 
   - Check for a `USER` specification in image with `docker inspect --format '{{.Config.User}}' IMAGENAME`.
   - If yes, try with `--user=RETAIN` to run with `USER` specified in image.
 - Some applications need more privileges or capabilities than x11docker provides as default. 
   - Reduce container isolation with e.g.:
     - x11docker options: `--cap-default --hostipc --hostnet --sys-admin`. (Try `--cap-default` first).
     - docker run options: `--cap-add ALL --security-opt seccomp=unconfined --privileged`
     - Example: `x11docker --cap-default --hostipc --hostnet --sys-admin -- --cap-add ALL --security-opt seccomp=unconfined --privileged -- IMAGENAME`
     - Try with reduced container isolation. If it works, drop options one by one until the needed one(s) are left.
     - If `--cap-add ALL` helps, find the [capability](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) you really need and add only that one.
     - If `--privileged` helps, your application probably needs a device in `/dev`. Find out which one and share it with e.g. `--device /dev/snd`. Try also `--sharedir /dev/udev/data:ro`.
       - Please, don't use `--privileged` as a solution. It allows too much access to host and fatally breaks container isolation. Investigate the permissions your container needs indeed.
   - You can run container applications as root with `--user=root`.
 - A few applications need [DBus](#dbus). Install `dbus` in image and try option `--dbus`. If that does not help, try option `--dbus-system`.
 - A few applications need systemd. Install `systemd` in image and try option `--systemd`.
 - Get help in the [issue tracker](https://github.com/mviereck/x11docker/issues). 
   - Most times it makes sense to store the `--verbose` output (or `x11docker.log`) at [pastebin.com](https://pastebin.com/).
   - Don't hesitate to ask.

   

## Examples
[Desktop image examples can be found on docker hub.](https://hub.docker.com/u/x11docker/)

| Application | x11docker command |
| --- | --- |
| Xfce4 Terminal | `x11docker x11docker/xfce xfce4-terminal` |
| GLXgears with hardware acceleration | `x11docker --gpu x11docker/xfce glxgears` |
| [Kodi media center](https://kodi.tv/) with hardware <br> acceleration, Pulseaudio sound <br> and shared `Videos` folder. <br> For setup look at [ehough/docker-kodi](https://github.com/ehough/docker-kodi). | `x11docker --gpu --pulseaudio --sharedir ~/Videos erichough/kodi`. |
| [XaoS](https://github.com/patrick-nw/xaos) fractal generator | `x11docker patricknw/xaos` |
| [Telegram messenger](https://telegram.org/) with persistent <br> `HOME` for configuration storage | `x11docker --home xorilog/telegram` |
| Firefox with shared `Download` folder. | `x11docker --sharedir $HOME/Downloads jess/firefox` |
| [Tor browser](https://www.torproject.org/projects/torbrowser.html) | `x11docker jess/tor-browser` |
| Chromium browser | `x11docker -- jess/chromium --no-sandbox` |
| VLC media player with shared `Videos` <br> folder and Pulseaudio sound | `x11docker --pulseaudio --sharedir=$HOME/Videos jess/vlc` |


| Desktop environment <br> (most based on Debian)| x11docker command |
| --- | --- |
| FVWM (based on [Alpine](https://alpinelinux.org/), 22.5 MB) | `x11docker --desktop x11docker/fvwm` |
| Fluxbox (based on Debian, 87 MB) | `x11docker --desktop x11docker/fluxbox` |
| [Lumina](https://lumina-desktop.org) (based on [Void Linux](https://www.voidlinux.org/))| `x11docker --desktop x11docker/lumina` |
| LXDE | `x11docker --desktop x11docker/lxde` |
| LXQt | `x11docker --desktop x11docker/lxqt` |
| Xfce | `x11docker --desktop x11docker/xfce` |
| [CDE Common Desktop Environment](https://en.wikipedia.org/wiki/Common_Desktop_Environment) | `x11docker --desktop --systemd --cap-default x11docker/cde` |
| Mate | `x11docker --desktop x11docker/mate` |
| Enlightenment (based on [Void Linux](https://www.voidlinux.org/)) | `x11docker --desktop --gpu --runit x11docker/enlightenment` |
| [Trinity](https://www.trinitydesktop.org/) (successor of KDE 3) | `x11docker --desktop x11docker/trinity` |
| Cinnamon | `x11docker --desktop --gpu --dbus-system x11docker/cinnamon` |
| [deepin](https://www.deepin.org/en/dde/) (3D desktop from China) | `x11docker --desktop --gpu --systemd x11docker/deepin` |
| [LiriOS](https://liri.io/) (needs at least docker 18.06 <br> or this [xcb bugfix](https://github.com/mviereck/x11docker/issues/76).) (based on Fedora) | `x11docker --desktop --gpu lirios/unstable` |
| KDE Plasma | `x11docker --desktop --gpu x11docker/plasma` |
| KDE Plasma as nested Wayland compositor | `x11docker --gpu x11docker/plasma startplasmacompositor` |
| LXDE with wine and PlayOnLinux and <br> a persistent `HOME` folder to preserve <br> installed Windows applications, <br> and with Pulseaudio sound. | `x11docker --desktop --home --pulseaudio x11docker/lxde-wine` |
   
### Adjust images for your needs
For persistent changes of image system adjust Dockerfile and rebuild. To add custom applications to x11docker example images you can create a new Dockerfile based on them. Example:
```
# xfce desktop with VLC media player
FROM x11docker/xfce
RUN apt-get update && apt-get install -y vlc
```
  
### Screenshots
Sample screenshots are stored in [screenshot branch](https://github.com/mviereck/x11docker/tree/screenshots)

`x11docker --desktop x11docker/lxde-wine`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde-wine.png "LXDE desktop in docker")

`x11docker --desktop --gpu x11docker/plasma`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-plasma.png "KDE plasma desktop in docker")

`x11docker --desktop x11docker/lxqt`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxqt.png "LXQT desktop in docker")

`x11docker --desktop --systemd --gpu x11docker/deepin`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-deepin.png "deepin desktop in docker")
