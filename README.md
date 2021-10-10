# x11docker: ![x11docker logo](x11docker.png) Run GUI applications in Docker
## Avoid X security leaks and enhance container security
[![DOI](http://joss.theoj.org/papers/10.21105/joss.01349/status.svg)](https://doi.org/10.21105/joss.01349)
### Introduction
x11docker allows to run graphical desktop applications (and entire desktops) in Linux containers.
 - [Container tools](#backend-docker-podman-or-nerdctl) like [Docker](https://en.wikipedia.org/wiki/Docker_(software)), [podman](http://docs.podman.io/en/latest/) and [nerdctl](https://github.com/containerd/nerdctl) allow to run applications in an isolated [container](https://en.wikipedia.org/wiki/Operating-system-level_virtualization) environment. 
   Containers need much less resources than [virtual machines](https://en.wikipedia.org/wiki/Virtual_machine) for similar tasks.
 - Docker, podman and nerdctl do not provide a [display server](https://en.wikipedia.org/wiki/Display_server) that would allow to run applications with a [graphical user interface](https://en.wikipedia.org/wiki/Graphical_user_interface).
 - x11docker fills the gap. It runs an [X display server](https://en.wikipedia.org/wiki/X_Window_System) on the host system and provides it to containers.
 - Additionally x11docker does some [security setup](https://github.com/mviereck/x11docker#security) to enhance container isolation and to avoid X security leaks. 
   This allows a [sandbox](#sandbox) environment that fairly well protects the host system from possibly malicious or buggy software.

Software can be installed in a deployable image with a rudimentary Linux system inside. 
This can help to run or deploy software that is difficult to install on several systems due to dependency issues. It is possible to run outdated versions or latest development versions side by side. 
Files to work on can be shared between host and container.

[x11docker wiki](https://github.com/mviereck/x11docker/wiki) provides some how-to's for basic setups without x11docker.

### Supported systems
x11docker runs on Linux and (with some setup and limitations) on [MS Windows](#installation-on-ms-windows). x11docker does not run on macOS except in a Linux VM.

### Features
 - Focus on [security](#security):
   - Avoids X security leaks by running [additional X servers](#choice-of-x-servers-and-wayland-compositors).
   - Restricts container capabilities to bare minimum.
   - Container user is same as host user to avoid root in container.
 - Low [dependencies](#dependencies):
   - No obliging dependencies on host beside X and one of `docker`, `podman` or `nerdctl`. Recommended: `nxagent` and `Xephyr`.
   - No dependencies inside of images except for some optional features.
 - Several [optional features](#options) like [GPU](#gpu-hardware-acceleration), [sound](#sound), [webcam](#webcam) and [printer](#printer) support.
 - Remote access with [SSH](https://github.com/mviereck/x11docker/wiki/Remote-access-with-SSH), [VNC](https://github.com/mviereck/x11docker/wiki/VNC) 
   or [HTML5](https://github.com/mviereck/x11docker/wiki/Container-applications-running-in-Browser-with-HTML5) possible.
 - Easy to use. [Examples](#examples): 
   - `x11docker x11docker/fvwm xterm`
   - `x11docker --desktop --size 320x240 x11docker/lxde` (needs nested X server `Xephyr`)
   

![retro terminal cathode](/../screenshots/screenshot-retroterm.png?raw=true "Cathode retro term in docker") ![LXDE in xpra](/../screenshots/screenshot-lxde-small.png?raw=true "LXDE desktop in docker")


### Table of contents
 - [GUI for x11docker](#gui-for-x11docker)
 - [Terminal usage](#terminal-usage)
 - [Options](#options)
   - [Choice of X servers and Wayland compositors](#choice-of-x-servers-and-wayland-compositors)
   - [Desktop or seamless mode](#desktop-or-seamless-mode)
   - [Shared folders and HOME in container](#shared-folders-volumes-and-home-in-container)
   - [GPU hardware acceleration](#gpu-hardware-acceleration)
   - [Clipboard](#clipboard)
   - [Sound](#sound)
   - [Webcam](#webcam)
   - [Printer](#printer)
   - [Language locales](#language-locales)
   - [Wayland](#wayland)
   - [Init system](#init-system)
   - [DBus](#dbus)
   - [Container runtime](#container-runtime)
   - [Backend docker, podman or nerdctl](#backend-docker-podman-or-nerdctl)
 - [Security](#security)
   - [Options degrading container isolation](#options-degrading-container-isolation)
   - [Sandbox](#sandbox)
   - [Security and feature check](#security-and-feature-check)
 - [Installation](#installation)
   - [Installation options](#installation-options)
   - [Shortest way for first installation](#shortest-way-for-first-installation)
   - [Minimal installation](#minimal-installation)
   - [Installation on MS Windows](#installation-on-ms-windows)
   - [Deinstallation](#deinstallation)
 - [Dependencies](#dependencies)
 - [Troubleshooting](#troubleshooting)
   - [Core checks](#core-checks)
   - [Privilege checks](#privilege-checks)
   - [Other checks](#other-checks)
 - [Contact](#contact)
   - [Issues](#issues)
   - [Contributing](#contributing)
   - [Support](#support)
 - [Donation](#donation)
 - [Examples](#examples)
   - [Single applications](#single-applications)
   - [Desktop environments](#desktop-environments)
   - [Option --preset](#option---preset)
   - [Adjust images for your needs](#adjust-images-for-your-needs)
   - [Screenshots](#screenshots)
   

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
   - See generated container backend command (and further infos) with option `--debug`.
 - If startup fails, look at chapter [Troubleshooting](#troubleshooting).
 
General syntax:
```
To run a container on a new X server:
  x11docker IMAGE
  x11docker [OPTIONS] IMAGE [COMMAND]
  x11docker [OPTIONS] -- IMAGE [COMMAND [ARG1 ARG2 ...]]
  x11docker [OPTIONS] -- RUN_OPTIONS -- IMAGE [COMMAND [ARG1 ARG2 ...]]
To run a host application on a new X server:
  x11docker [OPTIONS] --exe COMMAND
  x11docker [OPTIONS] --exe -- COMMAND [ARG1 ARG2 ...]
To run only an empty new X server:
  x11docker [OPTIONS] --xonly
```
`RUN_OPTIONS` are just added to the `docker|podman|nerdctl run` command without a serious check by x11docker.
 
 
 
## Options
Description of some commonly used feature [options](https://github.com/mviereck/x11docker/wiki/x11docker-options-overview).
 - Some of these options have dependencies on host and/or in image.
   Compare [wiki: feature dependencies](https://github.com/mviereck/x11docker/wiki/Dependencies#dependencies-of-feature-options).
 - For often used option combinations you can make shortcuts with [option `--preset`](#option---preset).
   
### Choice of X servers and Wayland compositors
If no X server option is specified, x11docker automatically chooses one depending on installed [dependencies](#dependencies) and on given or missing options `--desktop`, `--gpu` and `--wayland`. Most recommended are `nxagent` and `Xephyr`.
 - [Overview of all possible X server and Wayland options.](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options)
   - [Hints to use option `--xorg` within X.](https://github.com/mviereck/x11docker/wiki/Setup-for-option---xorg)
   - Use option `-t, --tty` to run without X at all.

### Desktop or seamless mode
x11docker assumes that you want to run a single application in seamless mode, i.e. a single window on your regular desktop. If you want to run a desktop environment in image, add option `--desktop`. 
 - Seamless mode is supported with options `--nxagent` and `--xpra`. As a fallback insecure option `--hostdisplay` is possible.
 - Desktop mode with `--desktop` is supported with all X server options except `--hostdisplay`. If available, x11docker prefers `--xephyr` and `--nxagent`.
 - Special case: Single applications with a window manager (option `--wm`).
   - If neither `nxagent` nor `xpra` are installed, but x11docker finds a desktop capable X server like `Xephyr`, it avoids insecure option `--hostdisplay` and runs Xephyr with a window manager.
   
### Shared folders, volumes and HOME in container
Changes in a running container system will be lost, the created container will be discarded. For persistent data storage you can share host directories or volumes:
 - Option `-m, --home` creates a host directory in `~/.local/share/x11docker/IMAGENAME` that is shared with the container and mounted as its `HOME` directory. 
   Files in container home and user configuration changes will persist. 
   x11docker creates a softlink from `~/.local/share/x11docker` to `~/x11docker`.
   - You can specify another host directory for container `HOME` with `--home=DIR`.
   - You can specify a volume for container `HOME` with `--home=VOLUME`.
 - Option `--share PATH` mounts a host file or folder at the same location in container. 
   - You can also specify a volume with `--share VOLUME`.
   - `--share PATH:ro` restricts to read-only access. 
   - Device files in `/dev` are supported, too.
 - Special cases for `$HOME`:
   - `--home=$HOME` will use your host home as container home. Discouraged, use with care.
   - `--share $HOME` will symlink your host home as a subfolder of container home. 
   
Note that x11docker copies files from `/etc/skel` in container to `HOME` if `HOME` is empty. That allows to provide predefined user configurations in the image.
 
### GPU hardware acceleration
Hardware acceleration for OpenGL is possible with option `-g, --gpu`. 
 - This will work out of the box in most cases with open source drivers on host. Otherwise have a look at [wiki: feature dependencies](https://github.com/mviereck/x11docker/wiki/Dependencies#dependencies-of-feature-options). 
 - Closed source [NVIDIA drivers](https://github.com/mviereck/x11docker/wiki/NVIDIA-driver-support-for-docker-container) need some setup and support less [x11docker X server options](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options#attributes-of-x-server-and-wayland-options).
 
### Clipboard
Clipboard sharing is possible with option `-c, --clipboard`. 
 - Image clips are possible with `--xpra` and `--hostdisplay`. 
 - Some X server options need package `xclip` on host.
 
### Sound
Sound is possible with options `-p, --pulseaudio` and `--alsa`. 
 - For pulseaudio sound with `--pulseaudio` you need `pulseaudio` on host and `pulseaudio` (at least the `pulseaudio` client libraries) in image. 
   Compare [wiki: feature dependencies](https://github.com/mviereck/x11docker/wiki/Dependencies#dependencies-of-feature-options).
 - For ALSA sound with `--alsa` you might need to specify a sound card with e.g. `--alsa=Generic`. Get a list of available sound cards with `aplay -l`.
 
### Webcam
Webcams on host can be shared with option `--webcam`.
 - If webcam application in image fails, install `--gpu` dependencies in image. 
   Compare [wiki: feature dependencies](https://github.com/mviereck/x11docker/wiki/Dependencies#dependencies-of-feature-options).
 - `guvcview` needs `--pulseaudio` or `--alsa`.
 - `cheese` and [`gnome-ring`](https://ring.cx/) need `--init=systemd`.
 
### Printer
Printers on host can be provided to container with option `--printer`. 
 - It needs `cups` on host, the default printer server for most linux distributions.
 - The container needs `cups` client libraries in image.
   Compare [wiki: feature dependencies](https://github.com/mviereck/x11docker/wiki/Dependencies#dependencies-of-feature-options).

### Language locales
x11docker provides option `--lang` for flexible language locale settings. 
 - `--lang` without an argument sets `LANG` in container to same as on host. Same as `--lang=$LANG`
 - x11docker will check on container startup if the desired locale is already present in image and enable it. 
 - If x11docker does not find the locale, it creates it on container startup. This needs some `locale` packages in image.
   Compare [wiki: feature dependencies](https://github.com/mviereck/x11docker/wiki/Dependencies#dependencies-of-feature-options).
 - Examples: `--lang=de` for German, `--lang=zh_CN` for Chinese, `--lang=ru` for Russian, `--lang=$LANG` for your host locale.
 - For support of chinese, japanese and korean characters install a font like `fonts-arphic-uming` in image.
 - Keyboard input methods like `fcitx-pinyin` are possible with some container setup. Compare ticket [#269](https://github.com/mviereck/x11docker/issues/269#issuecomment-667124421).
   
### Wayland
To run  [Wayland](https://wayland.freedesktop.org/) instead of an X server x11docker provides options `--wayland`, `--weston`, `--kwin` and `--hostwayland`. 
For further description loot at [wiki: Description of Wayland options](https://github.com/mviereck/x11docker/wiki/X-server-and-Wayland-Options#description-of-wayland-options).
 - Option `--wayland` automatically sets up a Wayland environment. It regards option `--desktop`.
 - Options `--weston` and `--kwin` run Wayland compositors `weston` or `kwin_wayland`.
 - Option `--hostwayland` can run applications seamless on host Wayland desktops like Gnome 3, KDE 5 and [Sway](https://github.com/swaywm/sway).
 - Example: `xfce4-terminal` on Wayland: `x11docker --wayland x11docker/xfce xfce4-terminal`
 
### Init system
x11docker supports several init systems as PID 1 in container with option `--init`. Init in container solves the [zombie reaping issue](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/).
As default x11docker uses `tini` in`/usr/bin/docker-init`. Also available are `systemd`, `SysVinit`, `runit`, `OpenRC` and `s6-overlay`. `elogind` is supported, too.
Look at [wiki: Init systems in Docker](https://github.com/mviereck/x11docker/wiki/Init-systems).

### DBus
Some desktop environments and applications need a running DBus system daemon and/or DBus user session. DBus options need `dbus` in image.
 - use `--dbus` to run a DBus user session daemon.
 - A DBus system daemon will be started automatically with [init systems](#Init-system) `systemd`, `openrc`, `runit` and `sysvinit` (option `--init`).
   - It is also possible to run a DBus system daemon with `--dbus=system` without advanced init systems. However, this causes trouble in some cases and is not recommended in general.
 - use `--hostdbus` to connect to host DBus user session.
 - use `--share /run/dbus/system_bus_socket` to share host DBus system socket.

### Container runtime
It is possible to run containers with different backends following the [OCI runtime specification](https://github.com/opencontainers/runtime-spec). Docker's default runtime is `runc`. You can specify another one with option `--runtime=RUNTIME`.
Container runtimes known and supported by x11docker are:
 - `runc`: Docker default.
 - [`kata-runtime`](https://katacontainers.io/): Sets up a virtual machine with its own Linux kernel to run the container. `kata` aims to combine the security advantages of containers and virtual machines.
   - Some x11docker options are not possible with `--runtime=kata-runtime`. Most important: `--hostdisplay`, `--gpu`, `--printer`, `--webcam` and all Wayland related options.
 - [`nvidia`](https://github.com/mviereck/x11docker/wiki/NVIDIA-driver-support-for-docker-container#nvidianvidia-docker-images): Specialized fork of `runc` to support `nvidia/nvidia-docker` images.
 - [`crun`](https://github.com/giuseppe/crun): Fast and lightweight alternative to `runc` with same functionality.
 - `oci`: Runtime reported in [#205](https://github.com/mviereck/x11docker/issues/205), no documentation found. Handled by x11docker like `runc`.
 
Using different runtimes is well tested for rootful Docker, but not for other [backend setups](#backend-docker-podman-or-nerdctl).
 
Possible runtime configuration in `/etc/docker/daemon.json`:
```json
{
  "default-runtime": "runc",
  "runtimes": {
    "kata-runtime": {
      "path": "/opt/kata/bin/kata-runtime",
      "runtimeArgs": [
        "--kata-config /opt/kata/share/defaults/kata-containers/configuration.toml"
      ]
    },
    "crun": {
      "path": "/usr/local/bin/crun",
      "runtimeArgs": []
    },
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
```
 
### Backend docker, podman or nerdctl
x11docker supports container tools [Docker](https://en.wikipedia.org/wiki/Docker_(software)), [podman](http://docs.podman.io/en/latest/) 
and [nerdctl](https://github.com/containerd/nerdctl) with option `--backend=BACKEND` in rootful and rootless mode.
 - By default x11docker tries to run `docker`. Alternatively set option `--backend=podman` or `--backend=nerdctl`.
 - Test status:
   - x11docker was developed with rootful `docker`, this is well tested.
   - Basically tested is `podman`, rootless and rootful.
   - Barely tested:
     - rootless `docker`
     - `nerdctl` in rootless and rootful mode.
   - Some fixes and adjustments for the less tested setups can be expected.
 - For rootless mode `podman` is recommended. 
   - Only `podman` allows option `--home` in rootless mode yet.
   - Only `podman` provides useful file ownerships with option `--share` in rootless mode yet.
 - For rootful mode `docker` or `podman` are recommended.
 - To switch between rootless or rootful mode of `podman` and `nerdctl` just use (or leave) `sudo` or set (or leave) option `--pw`.
 - For [rootless docker](https://docs.docker.com/engine/security/rootless/) set environment variable `DOCKER_HOST` accordingly.
 
## Security 
Scope of x11docker is to run containerized GUI applications while preserving and improving container isolation.
Core concept is:
 - Runs a second X server to avoid [X security leaks](http://tutorials.section6.net/tutorials/freebsd/security/basics-of-securing-x11.html).
   - This in opposite to widespread solutions that share host X socket of display :0, thus breaking container isolation, allowing keylogging and remote host control. 
     (However, x11docker provides this with fallback option `--hostdisplay`).
   - Authentication is done with MIT-MAGIC-COOKIE, stored separate from file `~/.Xauthority`.
 - Creates container user similar to host user to [avoid root in container](http://blog.dscpl.com.au/2015/12/don-run-as-root-inside-of-docker.html).
   - You can also specify another user with `--user=USERNAME` or a non-existing one with `--user=UID:GID`.
   - Disables possible root password and deletes entries in `/etc/sudoers`.
     - If you want root permissions in container, use option `--sudouser` that allows `su` and `sudo` with password `x11docker`. Alternatively you can run with `--user=root`. 
   - If you want to use `USER` specified in image instead, set option `--user=RETAIN`. x11docker won't change container's `/etc/passwd` or `/etc/sudoers` in that case. Option `--home` won't be available.
 - Reduces [container capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) to bare minimum.
   - Sets run option `--cap-drop=ALL` to drop all capabilities. Most applications don't need them.
   - Sets run option [`--security-opt=no-new-privileges`](https://www.projectatomic.io/blog/2016/03/no-new-privs-docker/).
   - These restrictions can be disabled with x11docker option `--cap-default` or reduced with `--sudouser`, `--user=root`, `--newprivileges`.
   
That being said, the default docker capabilities and the seccomp/SELinux/apparmor profiles are set up well to protect the host system.
Nonetheless, x11docker follows the [principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege). 
Containers should not have capabilities or privileges that they don't need for their job.

Default runtimes like `runc` use Linux namespaces to isolate container applications, but share the kernel from host. 
If you are concerned about container access to host kernel, consider to use [container runtime](#container-runtime) `kata-runtime` instead.

_Weaknesses:_
 - Possible SELinux restrictions are degraded for x11docker containers with run option `--security-opt label=type:container_runtime_t` to allow access to new X unix socket. 
   A more restrictive solution is desirable.
   Compare: [SELinux and Docker: allow access to X unix socket in /tmp/.X11-unix](https://unix.stackexchange.com/questions/386767/selinux-and-docker-allow-access-to-x-unix-socket-in-tmp-x11-unix)
 - A possible user namespace remapping setup is disabled to allow options `--home` and `--share` without file ownership issues. 
   - This is less an issue because x11docker already avoids root in container. 
   - Exception: User namespace remapping is not disabled for `--user=RETAIN`.
 - x11docker provides several different X server options. Each X server involved might have its individual vulnerabilities. x11docker only covers well-known X security leaks that result from X11 protocol design.

 
### Options degrading container isolation
x11docker shows warning messages in terminal if chosen options degrade container isolation. Note that x11docker does not check custom `DOCKER_RUN_OPTIONS`.

_Most important:_
  - `--hostdisplay` shares host X socket of display :0 instead of running a second X server. 
    - Danger of abuse is reduced providing so-called untrusted cookies, but do not rely on this. 
    - If additionally using `--gpu` or `--clipboard`, option `--hostipc` and trusted cookies are enabled and no protection against X security leaks is left. 
    - If you don't care about container isolation, `x11docker --hostdisplay --gpu` is an insecure but quite fast setup without any overhead.
  - `--gpu` allows access to GPU hardware. This can be abused to get window content from host ([palinopsia bug](https://hsmr.cc/palinopsia/)) and makes [GPU rootkits](https://github.com/LucaBongiorni/jellyfish) like [keyloggers](http://www.cs.columbia.edu/~mikepo/papers/gpukeylogger.eurosec13.pdf) possible.
  - `--pulseaudio` and `--alsa` allow catching audio output and microphone input from host.
  
_Rather special options reducing security, but not needed for regular use:_
  - `--sudouser` and `--user=root` allow `su` and `sudo` with password `x11docker`for container user.
    If an application somehow breaks out of container, it can harm your host system. Allows many container capabilities that x11docker would drop otherwise.
  - `--cap-default` disables x11docker's container security hardening and falls back to default container capabilities as provided by the backends docker, podman or nerdctl.
    If an application somehow breaks out of container, it can harm your host system.
  - `--init=systemd|sysvinit|openrc|runit` allow some container capabilities that x11docker would drop otherwise. 
    `--init=systemd` also shares access to `/sys/fs/cgroup`. Some processes will run as root in container.
    If a root process somehow breaks out of container, it can harm your host system. Allows many container capabilities that x11docker would drop otherwise.
  - `--hostipc` sets run option `--ipc=host`. Allows MIT-SHM / shared memory. Disables IPC namespacing.
  - `--hostdbus` allows communication over DBus with host applications.

### Sandbox
Container isolation enhanced with x11docker allows to use containers as a [sandbox](https://en.wikipedia.org/wiki/Sandbox_(computer_security)) that fairly well protects the host system from possibly malicious or buggy software.
Though, no sandbox solution in the wild can provide a perfect secure protection, and Docker even with enhanced security settings from x11docker is no exception.

Using x11docker as a sandbox is not intended to run obviously evil software. Rather use it as:
 - Compatibility environment to run software that is hard or impossible to install on host due to dependency issues.
 - Development environment to collect libraries, compiler and so on to keep the host clean.
 - Development environment to mitigate damage caused by unexpected/buggy behaviour.
 - Security layer for software that may be malicious in worst case. Examples: Internet browser with enabled `javascript`, or `wine` with MS Windows applications.

x11docker already restricts process capabilities. You can additionally restrict access to CPU and RAM with option `--limit`. 
As default `--limit` restricts to 50% of available CPUs and 50% of currently free RAM. Another amount can be specified with `--limit=FACTOR` with a `FACTOR` greater than zero and less than or equal one.

For more custom fine tuning have a look at [Docker documentation: Limit a container's resources](https://docs.docker.com/config/containers/resource_constraints).

**NOTE**: Internet access is allowed by default. You can disable internet access with `--network=none`.

**WARNING**: There is no restriction that can prevent the container from flooding the hard disk storing the container or in shared folders.

  
### Security and feature check
To check container isolation and some feature options use image `x11docker/check` and try out with several options.
 - An insecure setup is `x11docker --hostdisplay --gpu x11docker/check`. It fairly well demonstrates common X security leaks.
 - Add options like `--pulseaudio --alsa --webcam --clipboard --printer` to check their functionality.
  
## Installation
Note that x11docker is just a **bash script** without library dependencies. Basically it is just a wrapper for X servers and container backends docker, podman and nerdctl. To allow advanced usage of x11docker abilities have a look at chapter [Dependencies](#dependencies).
### Installation options
As root you can install, update and remove x11docker in system directories to be available system-wide:
 - `x11docker --install` : install x11docker and x11docker-gui from current directory. (Useful to install from an extracted `zip` file or a cloned `git` repository.)
 - `x11docker --update` : download and install latest [release](https://github.com/mviereck/x11docker/releases) from github.
 - `x11docker --update-master` : download and install latest master version from github.
 - `x11docker --remove` : remove all files installed by x11docker.
   - Note: This does not remove `~/.local/share/x11docker` where it stores persistent files of option `--home`.

What the installation does (just for information):
 - Copies scripts `x11docker` and `x11docker-gui` to `/usr/bin`. 
 - Copies icon `x11docker.png` to `/usr/share/icons`. 
 - Creates menu entry `x11docker.desktop` in `/usr/share/applications`. 
 - Copies documentation `README.md`, `CHANGELOG.md` and `LICENSE.txt` to `/usr/share/doc/x11docker`.
 
### Shortest way for first installation:
 - For systems using `sudo`:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker | sudo bash -s -- --update
   ```
 - Directly as `root`:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker | bash -s -- --update
   ```
   
### Minimal installation
You can run x11docker from an arbitrary location with `bash x11docker`.
For minimal system-wide installation make `x11docker` executable with `chmod +x x11docker` and move it to `/usr/bin` (or another location in `PATH`).
Other files than script `x11docker` itself are not essential.

### Installation on MS Windows
x11docker can run natively on MS Windows electively in one of:
 - [WSL (Windows subsystem for Linux)](https://docs.microsoft.com/en-us/windows/wsl/about)
 - [Cygwin](https://www.cygwin.com/) 
 - [MSYS2](https://www.msys2.org/)

Further information at [wiki: x11docker on MS Windows](https://github.com/mviereck/x11docker/wiki/x11docker-on-MS-Windows).

### Deinstallation
You can remove x11docker with `x11docker --remove`. That will remove the [files listed above](#installation-options).
It will also remove `~/.cache/x11docker` and stop all running x11docker containers.
x11docker will **not** remove:
 - Files and folders for persistent data storage with option `--home`. These are:
   - `~/.local/share/x11docker` where persistent data is stored.
   - Softlink `~/x11docker` that points there.
 - Folders you might have created yourself for x11docker: 
   - `~/.local/share/x11docker` 
   - `~/.config/x11docker`


## Dependencies
x11docker can run with standard system utilities without additional dependencies on host or in image. 
 - As a core it only needs `bash`, an `X` server and one of [`docker`](https://www.docker.com/), [`podman`](http://docs.podman.io/en/latest/) or [`nerdctl`](https://github.com/containerd/nerdctl) to run containers on X.
 - x11docker checks dependencies for chosen options on startup and shows terminal messages if some are missing. 

For advanced usage of x11docker it is recommended to install some additional packages.
The recommended base commands are: `nxagent` `Xephyr` `weston` `Xwayland` `xdotool` `xauth` `xinit` `xclip` `xhost` `xrandr` `xdpyinfo`. Some of them are probably already installed.
 - To provide these base commands see [wiki: Dependencies - Recommended base](https://github.com/mviereck/x11docker/wiki/Dependencies#recommended-base) for a package list matching your distribution.

Some feature options have additional dependencies on host and/or in image. This affects especially options `--gpu`, `--printer` and `--pulseaudio`.
Compare [wiki: feature dependencies](https://github.com/mviereck/x11docker/wiki/Dependencies#dependencies-of-feature-options).



## Troubleshooting
For troubleshooting run `x11docker` or `x11docker-gui` in a terminal. 
x11docker shows warnings if something is insecure, missing or going wrong.
Also it shows notes if options don't work and fallbacks are used.
It might give hints to fix some issues.
### Core checks

**1.** Make sure your x11docker version is up to date with `x11docker --update` (latest release) or `x11docker --update-master` (latest beta).

**2.** Carefully read the regular x11docker messages. Often they already give a hint what to do.
 - Use option `-D, --debug` to see some internal messages.
 - Use option `-v, --verbose` to see full logfile output.
 - You can find the latest dispatched logfile at `~/.cache/x11docker/x11docker.log`.
   
**3.** Try another X server option.
 - Some applications fail with fallback option `--hostdisplay`. Add `--clipboard` to disable some security restrictions of `--hostdisplay`.
 - If that does not help, install [additional X servers](https://github.com/mviereck/x11docker/wiki/Dependencies#recommended-base). The most stable and reliable option is `--xephyr`.
 
### Privilege checks
Some applications need more privileges or [capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) than x11docker provides by default. 
One attempt is to allow several privileges until the setup works. Than reduce privileges to find out which are needed indeed. 
(Note the ` -- ` in the following commands, do not miss them).

**1.** Adding privileges:
 - Try `x11docker --cap-default IMAGENAME`
 - Try `x11docker --cap-default --hostipc --hostnet IMAGENAME`
 - Try `x11docker --cap-default --hostipc --hostnet --share /run/udev/data:ro -- --cap-add ALL --security-opt seccomp=unconfined --privileged -- IMAGENAME`
   
**2.** Reducing privileges:
 - Drop options one by one in this order: `--privileged --security-opt seccomp=unconfined --cap-add ALL --share /run/udev/data:ro --hostnet --hostipc --cap-default`. Only leave options that are needed to keep the setup working.
 - Option `--cap-default` might already be enough. It allows default container capabilities as docker|podman|nerdctl would do on themself. 
   - You can just stop debugging and reducing here if you like to.
   - You can try to reduce `--cap-default`. Partially remove additional options to find out which one(s) are needed:
     - First try `x11docker --newprivileges -- IMAGENAME`
     - Than try and reduce: `x11docker --newprivileges -- --cap-add=SETPCAP --cap-add=MKNOD --cap-add=AUDIT_WRITE --cap-add=CHOWN --cap-add=NET_RAW --cap-add=DAC_OVERRIDE --cap-add=FOWNER --cap-add=FSETID --cap-add=KILL --cap-add=SETGID --cap-add=SETUID --cap-add=NET_BIND_SERVICE --cap-add=SYS_CHROOT --cap-add=SETFCAP -- IMAGENAME`
 - `--cap-add ALL` should not be considered to be a solution. 
   - Drop capabilities from following command to find the one(s) you need:
   `x11docker --cap-default -- --cap-add=SYS_MODULE --cap-add=SYS_RAWIO --cap-add=SYS_PACCT --cap-add=SYS_ADMIN --cap-add=SYS_NICE --cap-add=SYS_RESOURCE --cap-add=SYS_TIME --cap-add=SYS_TTY_CONFIG --cap-add=AUDIT_CONTROL --cap-add=MAC_OVERRIDE --cap-add=MAC_ADMIN --cap-add=NET_ADMIN --cap-add=SYSLOG --cap-add=DAC_READ_SEARCH --cap-add=LINUX_IMMUTABLE --cap-add=NET_BROADCAST --cap-add=IPC_LOCK --cap-add=IPC_OWNER --cap-add=SYS_PTRACE --cap-add=SYS_BOOT --cap-add=LEASE --cap-add=WAKE_ALARM --cap-add=BLOCK_SUSPEND --cap-add=AUDIT_READ -- IMAGENAME`
   - Many of these capabilities are rather dangerous and should not be allowed for a container. Especially to mention is `SYS_ADMIN`.
 - Option `--privileged` should not be considered to be a solution. Basically it allows arbitrary access to the host for container applications.
   - Likely you need to share a device file in `/dev`, e.g. something like `--share /dev/vboxdrv`.
 - `--hostipc` and `--hostnet` severely reduce container isolation. Better solutions are desirable.

**3.** Open a ticket to ask for possibilities how to optimize the privilege setup.

### Other checks

**1.** Container user: By default x11docker sets up an unprivileged container user similar to your host user.
 - The image may have a `USER` specification and be designed for this user. 
   - Check for a `USER` specification in image with `docker inspect --format '{{.Config.User}}' IMAGENAME`
   - You can enable this predefined user with `--user=RETAIN`
 - The container might need a root user. Try with `--user=root`. Note that this disables some x11docker restrictions for containers similar to `--cap-default`.
   
**2.** Init and DBus
 - A few applications need a [DBus](#dbus) user daemon. Install `dbus` in image and try option `--dbus`.
 - A few applications need systemd and/or a running [DBus](#dbus) system daemon. Install `systemd` in image and try option `--init=systemd`.

**3.** Architecture check of host OS and image
 - The image may not be built for the architecture of your host OS. (ie. Image is built for amd64 but your OS runs on arm, e.g. on a RaspBerry PI).
   With a mismatch the container will quit unexpectedly & x11docker may emit the error `dockerrc(): Did not receive PID of PID1 in container.`
   - You can check the image architecture with `docker inspect --format {{.Architecture}} IMAGENAME`.
   - You can check the host architecture with `uname -m`.
   - For further information and multi-arch setups look at [wiki: Multi-arch setups with QEMU](https://github.com/mviereck/x11docker/wiki/Multiarch-setups-with-QEMU).

## Contact
Feel free to open a [ticket](https://github.com/mviereck/x11docker/issues) if you have a question or encounter an issue.
### Issues
If reporting an [issue](https://github.com/mviereck/x11docker/issues):
 - Have a look at chapter [Troubleshooting](#troubleshooting).
 - Most times it makes sense to store the `--verbose` output (or `~/.cache/x11docker/x11docker.log`) at [pastebin.com](https://pastebin.com/).
### Contributing
If you want to contribute to x11docker, please open a [ticket](https://github.com/mviereck/x11docker/issues) before creating a pull request. 
Often it is possible to accomplish desired tasks with already available options.
Note that x11docker is considered to be stable and changes other than bug fixes are less likely to be merged. In general new features are not intended.
### Support
Please open a [ticket](https://github.com/mviereck/x11docker/issues) if you need support. Please note that `x11docker` is a non-commercial project maintained in free time. 
I'll help where I can, but there is no organisation behind `x11docker` that can provide large scale support.

## Donation
If you like to make a donation: Thank you! :)

I don't take the money myself, but please spend some to [Galsan Tschinag](http://galsan-tschinag.de/portrait/) in Mongolia ([Wikipedia](https://en.wikipedia.org/wiki/Galsan_Tschinag)). 
One of his great projects is the afforestation of Mongolia.
A donation account in Germany is provided by [Förderverein Mongolei e.V.](http://foerderverein-mongolei.de/spenden/).
```
Förderverein Mongolei e.V.
IBAN DE7261290120 0394 3660 00
BIC GENODES1NUE
Volksbank Kirchheim-Nürtingen
```
I personally know some of the people behind this. I assure that they are trustworthy and have a great heart and soul and do a good thing.

## Examples
[Some x11docker image examples with desktop environments can be found on docker hub.](https://hub.docker.com/u/x11docker/)
A special one to check features and container isolation is `x11docker/check`.

Docker does not provide automated builds for free anymore, so the images are becoming outdated.
Instead of pulling them, rather build them locally with x11docker option `--build`.

Some x11docker Dockerfiles are provided at https://github.com/mviereck?tab=repositories; look for repositories beginning with `dockerfile-x11docker`.
You can build locally from these Dockerfiles with x11docker option `--build`. Example:
```
x11docker --build x11docker/fvwm
```

### Single applications
| Application | x11docker command |
| --- | --- |
| Xfce4 Terminal | `x11docker x11docker/xfce xfce4-terminal` |
| GLXgears with hardware acceleration | `x11docker --gpu x11docker/xfce glxgears` |
| [Kodi media center](https://kodi.tv/) with hardware <br> acceleration, Pulseaudio sound <br> and shared `Videos` folder. <br> For setup look at [ehough/docker-kodi](https://github.com/ehough/docker-kodi). | `x11docker --gpu --pulseaudio --share ~/Videos erichough/kodi`. |
| [XaoS](https://github.com/patrick-nw/xaos) fractal generator | `x11docker patricknw/xaos` |
| [Telegram messenger](https://telegram.org/) with persistent <br> `HOME` for configuration storage | `x11docker --home xorilog/telegram` |
| Firefox with shared `Download` folder. | `x11docker --share $HOME/Downloads -- --tmpfs /dev/shm -- jess/firefox` |
| [Tor browser](https://www.torproject.org/projects/torbrowser.html) | `x11docker jess/tor-browser` |
| Chromium browser with restricted resource usage | `x11docker --limit -- jess/chromium --no-sandbox` |
| VLC media player with shared `Videos` <br> folder and Pulseaudio sound | `x11docker --pulseaudio --share=$HOME/Videos jess/vlc` |
| [GNU Octave Scientific Programming Language](https://www.gnu.org/software/octave/) built for arm & arm64 | `x11docker aptman/dbhi:bionic-octave octave` | 

### Desktop environments
| Desktop environment <br> (most based on Debian)| x11docker command |
| --- | --- |
| [Cinnamon](https://github.com/mviereck/dockerfile-x11docker-cinnamon) | `x11docker --desktop --gpu --init=systemd x11docker/cinnamon` |
| [deepin](https://github.com/mviereck/dockerfile-x11docker-deepin) ([website](https://www.deepin.org/en/dde/)) (3D desktop from China) | `x11docker --desktop --gpu --init=systemd -- --cap-add=IPC_LOCK --security-opt seccomp=unconfined -- x11docker/deepin` |
| [Enlightenment](https://github.com/mviereck/dockerfile-x11docker-enlightenment) (based on [Void Linux](https://www.voidlinux.org/)) | `x11docker --desktop --gpu --runit x11docker/enlightenment` |
| [Fluxbox](https://github.com/mviereck/dockerfile-x11docker-fluxbox) (based on Debian, 87 MB) | `x11docker --desktop x11docker/fluxbox` |
| [FVWM](https://github.com/mviereck/dockerfile-x11docker-fvwm) (based on [Alpine](https://alpinelinux.org/), 22.5 MB) | `x11docker --desktop x11docker/fvwm` |
| [Gnome 3](https://github.com/mviereck/dockerfile-x11docker-gnome) | `x11docker --desktop --gpu --init=systemd x11docker/gnome` |
| [KDE Plasma](https://github.com/mviereck/dockerfile-x11docker-kde-plasma) | `x11docker --desktop --gpu --init=systemd x11docker/kde-plasma` |
| [KDE Plasma](https://github.com/mviereck/dockerfile-x11docker-kde-plasma) as nested Wayland compositor| `x11docker --gpu --init=systemd -- --cap-add SYS_RESOURCE -- x11docker/kde-plasma startplasmacompositor` |
| [Lumina](https://github.com/mviereck/dockerfile-x11docker-lumina) ([website](https://lumina-desktop.org)) (based on [Void Linux](https://www.voidlinux.org/))| `x11docker --desktop x11docker/lumina` |
| [LiriOS](https://liri.io/) (needs at least docker 18.06 <br> or this [xcb bugfix](https://github.com/mviereck/x11docker/issues/76).) (based on Fedora) | `x11docker --desktop --gpu lirios/unstable` |
| [LXDE](https://github.com/mviereck/dockerfile-x11docker-lxde) | `x11docker --desktop x11docker/lxde` |
| [LXDE with wine and PlayOnLinux](https://github.com/mviereck/dockerfile-x11docker-lxde-wine) and <br> a persistent `HOME` folder to preserve <br> installed Windows applications, <br> and with Pulseaudio sound. | `x11docker --desktop --home --pulseaudio x11docker/lxde-wine` |
| [LXQt](https://github.com/mviereck/dockerfile-x11docker-lxqt) | `x11docker --desktop x11docker/lxqt` |
| [Mate](https://github.com/mviereck/dockerfile-x11docker-mate) | `x11docker --desktop x11docker/mate` |
| [Trinity](https://github.com/mviereck/dockerfile-x11docker-trinity) ([website](https://www.trinitydesktop.org/)) (successor of KDE 3) | `x11docker --desktop x11docker/trinity` |
| [Xfce](https://github.com/mviereck/dockerfile-x11docker-xfce) | `x11docker --desktop x11docker/xfce` |

### Option --preset
For very long option combinations you might want to use option `--preset FILENAME` to have a command shortcut. 
`FILENAME` is a file in `~/.config/x11docker/preset` containing some x11docker options.
 - Example multimedia: Create a file `~/.config/x11docker/preset/multimedia`:
   ```
   --gpu
   --webcam
   --printer
   --pulseaudio
   --clipboard
   --share ~/Videos
   --share ~/Music
   ```
   Use it like: `x11docker --preset=multimedia jess/vlc`
 - Example deepin desktop: Instead of very long command
   ```
   x11docker --desktop --init=systemd -- --cap-add=IPC_LOCK --security-opt seccomp=unconfined -- x11docker/deepin
   ``` 
   you can create a file `~/.config/x11docker/preset/deepin` containing the desired options:
   ```
   --desktop 
   --init=systemd
   -- 
   --cap-add=IPC_LOCK
   --security-opt seccomp=unconfined
   -- 
   x11docker/deepin
   ```
   Run with: `x11docker --preset=deepin`
   
### Adjust images for your needs
For persistent changes of image system adjust Dockerfile and rebuild. To add custom applications to x11docker example images you can create a new Dockerfile based on them. Example:
```Dockerfile
# xfce desktop with VLC media player
FROM x11docker/xfce
RUN apt-get update && apt-get install -y vlc
```
  
### Screenshots
More screenshots are stored in [screenshot branch](https://github.com/mviereck/x11docker/tree/screenshots)

`x11docker --desktop x11docker/lxde-wine`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde-wine.png "LXDE desktop in docker")

`x11docker --desktop x11docker/lxqt`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxqt.png "LXQT desktop in docker")

`x11docker --desktop --gpu --init=systemd -- --cap-add=IPC_LOCK --security-opt seccomp=unconfined -- x11docker/deepin`
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-deepin.png "deepin desktop in docker")
