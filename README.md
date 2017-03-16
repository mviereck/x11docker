# x11docker: Run X11 GUI applications and desktop environments in docker on a segregated X server.

 - Much faster than SSH or VNC solutions.
 - No dependencies inside of docker images.
 - Secure sandboxing of GUI applications.
 - Pulseaudio sound support is possible.
 - GPU hardware acceleration is possible.

# GUI for x11docker ![x11docker logo](/../screenshots/x11docker_klein.jpeg?raw=true "Optional Title")
To use `x11docker-gui`, you need to install package [kaptain](https://packages.debian.org/jessie/kaptain). 
 - On systems without a root password like Ubuntu, activate option `--sudo`.
 - For troubleshooting, run x11docker-gui in a terminal or use [Run in xterm]. Also you can activate option `--verbose`.
 - Some developer options become visible with `x11docker-gui -d`. 

![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "Optional Title")


# Installation
You don't need to install x11docker, you can just run it as user with `bash x11docker` respective `bash x11docker-gui`. As root, you can install, update and remove x11docker on your system:
 - `x11docker --install` : install x11docker and x11docker-gui. 
 - `x11docker --update` : download and install latest version from github.
 - `x11docker --remove` : remove all files installed by x11docker.
 
Installs into `/usr/local/bin`. Creates an icon in `/usr/share/icons`. Creates an `x11docker.desktop` file in `/usr/share/applications`. Copies README.md and LICENSE.txt to `/usr/share/doc/x11docker`.
 
 
# Security 
 - Main purpose of x11docker is to run dockered GUI applications while preserving container isolation.
 - Preserving container isolation is done using an additional X server separate from X on host display :0, thus avoiding X security leaks. (Most solutions in the web to run dockered GUI applications allow access to host X server, thus breaking container isolation and allowing access to host X resources like keylogging with `xinput test`).
 - Authentication is done with MIT-MAGIC-COOKIE, stored separate from file `~/.Xauthority`.  Container and new X server don't know cookies from host X server on display :0. (Except less secure options `--hostdisplay` and `--virtualgl`)
 - With option `--no-xhost` x11docker checks for any access to host X server granted by `xhost` and disables it. Host applications then use `~/.Xauthority` only.
 - To avoid using any X server on host by docker container, you can use options `--xpra-image` or `--xorg-image`. Xpra server respective Xorg/Xdummy will run in container instead on host. Needs xpra respective Xorg/Xdummy to be installed in image, and xpra to be installed on host. Xpra on host shows applications running on xpra/Xorg server in image.
 - Special use cases of hardware acceleration and option `--hostdisplay` can degrade or break container isolation. Look at security table to see the differences:
 
![x11docker-gui security screenshot](/../screenshots/x11docker-security.png?raw=true "Optional Title")
 
# Dependencies
x11docker can run with standard system utilities without additional dependencies on host or in image. As a core, it only needs X server (package `xorg`)  and, of course, docker (package `docker.io`) to run docker images on X. 

For some additional options, x11docker needs some packages to be installed on host.
It will check for them on startup and show terminal messages if some are missing.

List of optional needed packages on host: `xpra` `xserver-xephyr` `xclip` `kaptain` `pulseaudio` `virtualgl` `xserver-xorg-legacy`
(This for debian, other distros may have different package names).

- `xpra`:  option `--xpra`, showing single applications on your host display. It is recommend to use latest version from https://www.xpra.org
- `xserver-xephyr`:  option `--xephyr`, showing desktops on your host display
- `xclip`:  option `--clipboard`, sharing clipboard with Xephyr or core X11
- `pulseaudio`:  option `--pulseaudio`, sound/audio support
- `virtualgl`:  option `--virtualgl`, hardware accelerated OpenGL in xpra and Xephyr. (http://www.virtualgl.org)
- `kaptain`:  x11docker-gui
- `xserver-xorg-legacy`: needed on Ubuntu 16.04 and higher for option `--xorg`

Pulseaudio sound (option `--pulseaudio`) and OpenGL hardware acceleration (options `--gpu` and `--virtualgl`) have dependencies in image, too. See below. Special options `--xpra-image`, `--xorg-image` and `--xdummy-image` need X or xpra to be installed in image. See below. 

# X servers to choose from
x11docker creates a new X server on a new X socket. Instead of using display :0 from host, docker images will run on segregated display :1 or display :2 ... (with exception from option `--hostdisplay`)

If neither `xpra` nor `xserver-xephyr` are installed, and `x11-common` is not reconfigured (for use of option `--xorg`, see below), only option `--hostdisplay` will work out of the box.
 - `--xpra`: A comfortable way to run single docker GUI applications visible on your host display is to use [xpra](http://xpra.org/).
 - `--xephyr`: A comfortable way to run desktop environments from within docker images is to use [Xephyr](https://www.freedesktop.org/wiki/Software/Xephyr/). Also, you can choose this option together with option `--wm` and run single applications with a host window manager in Xephyr. The desktop will appear in a window on your host display.
 - `--xorg`: Second core X server: To switch between displays, press `[CTRL][ALT][F7] ... [F12]`. Essentially it is the same as switching between virtual consoles (tty1 to tty6) with `[CTRL][ALT][F1] ... [F6]`. To be able to use this option, you have to execute `dpkg-reconfigure x11-common` first and choose option `anybody`. 
 [If this command fails (known for debian 9 and Ubuntu 16.04), you need to install package `xserver-xorg-legacy` and to run `dpkg-reconfigure xserver-xorg-legacy` instead; then edit file `/etc/X11/Xwrapper.config` and add line `needs_root_rights=yes`.]
 - `--hostdisplay`: Sharing host display: This option is least secure and has least overhead. Instead of running a second X server, your host X server on display :0 is shared. Occuring rendering glitches can be fixed with insecure option `--ipc`.
 
Special X servers:
 - `--xdummy`: Invisible X server. For custom setups of xpra, VNC and/or network access.
 
X server installed in image:
 - `--xpra-image`: Use xpra server in container instead on host to avoid using any X server on host. Needs xpra to be installed on host and in image with xpra version 0.17.6 at least. 
 - `--xorg-image`: Use X server in image, show with xpra on host. Needs at least `xserver-xorg-core` and `xserver-xorg-video-dummy` in image.
 - `--xdummy-image`: Use X server in image, invisible on host. Needs at least `xserver-xorg-core` and `xserver-org-video-dummy` in image. Does not need any X on host. For custom setups of xpra, VNC and/or network access.
 
As default, connection to X server is done sharing the matching unix socket in `/tmp/.X11-unix`. Alternatively, connection over tcp is possible with developer option `--tcp` (except option `--hostdisplay`).
 
 
# Hardware accelerated OpenGL rendering
Software accelerated OpenGL is available in all provided X servers. The image needs an OpenGL implementation to profit from it.  The easiest way to achieve this is to install package `mesa-utils` in your image. Some applications need package `x11-utils` to be installed in image, too. Media Players like VLC may also need package `libxv1`.
 
Immediate GPU hardware acceleration with option `--gpu` is quite fast and secure to use with option `--xorg`. As for now, it works with options `--xorg` and `--hostdisplay` only. It can get additional speed-up with insecure option `--ipc`.
 
Mediate GPU hardware acceleration for OpenGL / GLX with option `--virtualgl` is possible with [VirtualGL](http://www.virtualgl.org/). Other than option `--gpu`, it works with `--xpra` and `--xephyr`, too, but has the drawback to break container isolation from display :0. For use with trusted images only. Needs VirtualGL to be installed on host.
 
Using hardware acceleration can degrade or break container isolation. Look at table in section "Security". 

Known to work with AMD and Intel onboard chips using open source drivers. Test reports with different setups of graphic cards and drivers are appreciated. x11docker shares all files in `/dev/dri` with docker container. Different setups may need additional other files to be shared and maybe some graphics drivers to be installed in image, too.
  
# Pulseaudio sound support
x11docker supports pulseaudio sound over tcp with option `--pulseaudio`. For this to use, package `pulseaudio` needs to be installed on host and in docker image.

# Usage in terminal
x11docker askes for root password to run docker. On systems without a root password like Ubuntu or Sparky, use option `--sudo`, then x11docker uses `sudo` instead of `su` to run docker. x11docker itself should not run as root because X servers should run in userspace without root privileges.

To run a docker image with new X server:
 -  `x11docker [OPTIONS] IMAGE [COMMAND]`
 -  `x11docker [OPTIONS] -- [DOCKER_RUN_OPTIONS] IMAGE [COMMAND [ARG1 ARG2 ...]]`
  
To run a host application on a new X server:
 -  `x11docker [OPTIONS] --exe COMMAND`
 -  `x11docker [OPTIONS] --exe -- COMMAND [ARG1 ARG2 ...]`

To run only a new X server with window manager:
 -  `x11docker [OPTIONS]`

Have a look at `x11docker --help` to see all options.

# Examples
Some example images can be found on docker hub: https://hub.docker.com/u/x11docker/

 - Run xfce desktop in Xephyr:
   
  `x11docker --xephyr --desktop x11docker/xfce`
   
 - Run wine and playonlinux on xfce desktop in a sandbox in a Xephyr window, sharing a home folder to preserve settings and wine installations, and with a container user similar to your host user:

  `x11docker --xephyr --hostuser --home --desktop x11docker/xfce-wine-playonlinux start`
   
 - Run playonlinux in a sandbox in an xpra window, sharing a home folder to preserve settings and installations, sharing clipboard, enabling pulseaudio sound, and with a container user similar to your host user:

  `x11docker --xpra --hostuser --home --clipboard --pulseaudio x11docker/xfce-wine-playonlinux playonlinux`

 - Share Download folder from host with r/w access. Simulate host user to avoid file permission confusion. Start xterm and pcmanfm together:
   
  `x11docker --hostuser  --  --volume=$HOME/Downloads:$HOME/Downloads:rw x11docker/lxde "pcmanfm & xterm"`
  
 - Run teamviewer
  
  `x11docker bbinet/teamviewer`
  
# Screenshots
Sample screenshots can be found in [screenshot branch](https://github.com/mviereck/x11docker/tree/screenshots)

x11docker/lxde running in a Xephyr window:

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde.png "lxde desktop running in Xephyr window using x11docker")

# Known issues
 - Ubuntu 16.04: x11docker won't start from console without setup of `xserver-xorg-legacy`. This is a [bug](https://bugs.launchpad.net/ubuntu/+source/xinit/+bug/1562219) in Ubuntu and won't be fixed.
 - debian 9 and Ubuntu 16.04: Cannot run a second core X server (option `--xorg`) from within already running X without setup of `xserver-xorg-legacy`. This may be solved in future with a [setup of a systemd service for Xorg](http://unix.stackexchange.com/questions/346383/run-second-x-server-from-within-x-as-a-systemd-service).
 - Package `kaptain` is not available in repositories of debian 9 and Ubuntu 16.04. You can install [kaptain for debian jessie](https://packages.debian.org/jessie/kaptain) respective [kaptain for Ubuntu 14.04](http://packages.ubuntu.com/trusty/kaptain) instead.
 - x11docker-gui can look ugly on GTK based systems. x11docker-gui is managed by `kaptain` which uses QT4. You can use `qtconfig`, select GUI style GTK+ and save this setting with `[CTRL][S]`. 
 
# Questions?
You can ask questions in [issues section](https://github.com/mviereck/x11docker/issues). Use it like a forum.
