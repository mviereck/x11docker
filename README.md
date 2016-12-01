# x11docker: Run X11 GUI applications and desktop environments in docker.

 - Much faster than SSH or VNC solutions.
 - No dependencies inside of docker images.
 - Secure sandboxing of GUI applications.
 - Pulseaudio sound support is possible.
 - GPU hardware acceleration is possible.

#GUI for x11docker ![x11docker logo](/../screenshots/x11docker_klein.jpeg?raw=true "Optional Title")
There is a comfortable GUI for x11docker. To use `x11docker-gui`, you need to install package `kaptain`. `x11docker-gui` looks for an executeable `./x11docker` first, then will look for it in `$PATH`, for example in `/usr/local/bin`. (Some developer options become visible with `x11docker-gui -d`).
![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "Optional Title")

#Security 
 - Main purpose of x11docker is to run dockered GUI applications while preserving container isolation.
 - GUI applications in docker are isolated from host display :0, thus avoiding X security leaks.
 - Preserving container isolation is done using a segregated X server. (Most solutions in the web to run dockered GUI applications share the problem of breaking container isolation and allowing access to X resources like keylogging with `xinput test`).
 - Authentication is done with MIT-MAGIC-COOKIE, stored separate from file `~/.Xauthority`.  The new X server doesn't know cookies from the host X server on display :0. (Except less secure options `--hostdisplay` and `--virtualgl`)
 - With option `--no-xhost` x11docker checks for any access to host X server granted by xhost and disables it. Host applications then use `~/.Xauthority` only.
 - Special use cases of hardware acceleration and option `--hostdisplay` can degrade or break container isolation. Look at security table to see the differences:
 
![x11docker-gui security screenshot](/../screenshots/x11docker-security.png?raw=true "Optional Title")
 
#Dependencies
x11docker can run with standard system utilities without additional dependencies. As a core, it only needs X server (package `xorg`)  and, of course, docker (package `docker.io`) to run docker images on X. 

For some additional options, x11docker needs some packages to be installed on host.
It will check for them on startup and show terminal messages if some are missing.

List of optional needed packages: `xpra` `xephyr` `xclip` `kaptain` `pulseaudio` `virtualgl` 

- `xpra`:  option `--xpra`, showing single applications on your host display
- `xephyr`:  option `--xephyr`, showing desktops on your host display
- `xclip`:  option `--clipboard`, sharing clipboard with Xephyr or core X11
- `pulseaudio`:  option `--pulseaudio`, sound/audio support
- `virtualgl`:  option `--virtualgl`, hardware accelerated OpenGL in xpra and Xephyr. (http://www.virtualgl.org)
- `kaptain`:  x11docker-gui

#X servers to choose from
x11docker creates a new X server on a new X socket. Instead of using display :0 from host, docker images will run on segregated display :1 or display :2 ... (with exception from option `--hostdisplay`)

If neither `xpra` nor `xephyr` are installed, and `x11-common` is not reconfigured (for use of option `--X11`, see below), only option `--hostdisplay` will work out of the box.
 - `--xpra`: A comfortable way to run single docker GUI applications visible on your host display is to use xpra.
 - `--xephyr`: A comfortable way to run desktop environments from within docker images is to use Xephyr. Also, you can choose this option together with option `--wm` and run single applications with a host window manager in Xephyr. The desktop will appear in a window on your host display.
 - `--X11`: Second core X server: To switch between displays, press `[CTRL][ALT][F7] ... [F12]`. Essentially it is the same as switching between virtual consoles (tty1 to tty6) with `[CTRL][ALT][F1] ... [F6]`. To be able to use this option, you have to execute `dpkg-reconfigure x11-common` first and choose option `anybody`.
 - `--hostdisplay`: Sharing host display: This option is least secure and has least overhead. Instead of running a second X server, your host X server on display :0 is shared. Occuring rendering glitches can be fixed with insecure option `--ipc`.
 
As default, connection to X server is done sharing the matching unix socket in `/tmp/.X11-unix`. Alternatively, connection over tcp is possible with developer option `--tcp` (except option `--hostdisplay`).
 
 
#Hardware accelerated OpenGL rendering
Software accelerated OpenGL is available in all provided X servers. The image needs an OpenGL implementation to profit from it.  The easiest way to achieve this is to install package `mesa-utils` in your image. Some applications need package `x11-utils` to be installed in image, too.
 
Immediate GPU hardware acceleration with option `--gpu` is quite fast and secure to use with a core second X server. As for now, it works with options `--X11` and `--hostdisplay` only. It can get additional speed-up with insecure option `--ipc`.
 
 Mediate GPU hardware acceleration for OpenGL / GLX with option `--virtualgl` is possible with VirtualGL. Other than option `--gpu`, it works with xpra and Xephyr, too, but has the drawback to break container isolation from display :0. For use with trusted images only. Needs VirtualGL to be installed on host.
 
Using hardware acceleration can degrade or break container isolation. Look at table in section "Security". 

Known to work with AMD and Intel onboard chips using open source drivers. Test reports with different setups of graphics cards and drivers are appreciated. x11docker shares all files in `/dev/dri` with docker container. Different setups may need additional other files and maybe some graphics drivers to be installed in image, too.
  
#Pulseaudio sound support
x11docker supports pulseaudio sound over tcp with option `--pulseaudio`. For this to use, package `pulseaudio` needs to be installed on host and in docker image.

#Usage in terminal
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

#Examples
Some example images can be found on docker hub: https://hub.docker.com/u/x11docker/

   - Run xfce desktop in Xephyr:
   
`x11docker --xephyr --desktop x11docker/xfce`
   
   - Run wine and playonlinux on xfce desktop in a sandbox in a Xephyr window, sharing a home folder to preserve settings and wine installations, and with a container user similar to your host user:

`x11docker --xephyr --hostuser --home --desktop x11docker/xfce-wine-playonlinux start`
   
   - Run playonlinux in a sandbox in an xpra window, sharing a home folder to preserve settings and installations, sharing clipboard, enabling pulseaudio sound, and with a container user similar to your host user:

`x11docker --xpra --hostuser --home --clipboard --pulseaudio x11docker/xfce-wine-playonlinux playonlinux`
   
# Screenshots
Sample screenshots can be found in [screenshot branch](https://github.com/mviereck/x11docker/tree/screenshots)

x11docker/lxde running in a Xephyr window:

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde.png "lxde desktop running in Xephyr window using x11docker")

# Questions?
You can ask questions in [issues section](https://github.com/mviereck/x11docker/issues). Use it like a forum.
