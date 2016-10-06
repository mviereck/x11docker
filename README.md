# x11docker
 - Run X applications and desktop environments in docker on a distinct X server.
 - Useful to avoid security issues concerning X forwarding.
 - Can either open a new X display, or can use Xpra and Xephyr to show dockered GUI applications on your main X display.
 - Doesn't need VNC or SSH. docker applications can directly access the new X server via tcp.
 - Doesn't have dependencies inside the image - can run any GUI applications in docker. (Doesn't even need an X server to be installed in the image.)
 - Authentication via MIT-MAGIC-COOKIES. Separate Xauthority file, it is _not_  ~/.Xauthority
 - Sound with pulseaudio is possible
 - Hardware accelerated OpenGL rendering is possible

#GUI for x11docker
There is a comfortable GUI for x11docker. To run x11docker-gui, you need to install 'kaptain'. 
(debian link to kaptain: https://packages.debian.org/search?keywords=kaptain).

![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "Optional Title")

 
#pulseaudio sound support
 x11docker supports pulseaudio sound over tcp. For this to use, pulseaudio needs to be installed on host and in docker image.

#Hardware accelerated OpenGL rendering
Software accelerated OpenGL is available in all provided X servers. 
 The image should contain an OpenGL implementation to profit from it.  The easiest way to achieve this is to install package \"mesa-utils\" in your image.

Note: hardware acceleration still is experimental / beta. Other than stated below, connection to the new X server is done sharing its unix socket.

 To use the benefits of hardware accelerated 3D graphics, you need to have 
 a graphics card driver matching the one on your host to be installed in your docker image.
 As for general, a package from xserver-xorg-video-* and maybe linux-firmware-nonfree
 may be useful, depending on your host hardware.
 If you have a proprietary driver on your host, most probably you need this in your image, too.
 
 To achieve hardware acceleration, x11docker provides host devices found in /dev/dri/ 
 to the image. This may be considered to be a security leak. 
 
 As for now, only core X server provides hardware accelerated 3D / OpenGL rendering. 
 
 To check if hardware acceleration is enabled, you can run \"glxinfo | grep renderer\". 
 The OpenGL renderer string should contain your graphics card adapter name. 
 If the renderer string contains \"llvmpipe\", only software rendering is enabled. 
 As a performance check, you can run glxgears in a maximized window.
 
#Dependencies
Depending on choosed options, x11docker needs some packages to be installed.
It will check for them on startup and show terminal messages if some are missing.
List of possible needed packages:

xpra xephyr xvfb xclip kaptain wmctrl pulseaudio docker.io xorg

#Usage in terminal
To run a docker image with new X server:
 -  x11docker [OPTIONS] IMAGE [COMMAND]
 -  x11docker [OPTIONS] -- [DOCKER_RUN_OPTIONS] IMAGE [COMMAND [ARG1 ARG2 ...]]
  
To run a host application on a new X server:
 -  x11docker [OPTIONS] --exe COMMAND
 -  x11docker [OPTIONS] --exe -- COMMAND [ARG1 ARG2 ...]

To run only a new X server with window manager:
 -  x11docker [OPTIONS]

Have a look at 'x11docker --help' to see all options.

#Explanations
x11docker creates a new X server on a new X socket on a new display. Instead of using
display :0 (standard), docker images will run on display :1 or display :2 ...

To switch to between displays, press [STRG][ALT][F7] ... [STRG][ALT][F12]. Essentially it is the
same as switching between virtual consoles (tty1 to tty6) with [STRG][ALT][F1]...[F6].

A more comfortable way is to use Xpra and Xephyr. With Xpra and Xephyr dockered GUI applications will show up on your main display, and you don't need to switch between different tty's.

Example: This will run an xfce desktop environment in docker, showing it in a Xephyr window 
on your main display:
 - x11docker --xephyr --desktop x11docker/xfce

#Security
 - Using a separate X server aka a new display for docker GUI applications avoids issues 
 concerning security leaks inside a running X server. There are some solutions in the web to run dockered GUI applications with X forwarding on display :0, but all of them share the problem of breaking isolation of docker containers and allowing them access to X resources like keylogging with 'xinput test'.
 - With x11docker, GUI applications in docker are isolated from main display :0
 - docker GUI clients connect to new X server over tcp. Authenthication is done with MIT-MAGIC-COOKIE, stored separate from ~/.Xauthority.  The new X server doesn't know cookies from the host X server on display :0.
 - With option --no-xhost x11docker checks for any access granted to host X server by xhost and disables it. Host applications then use ~.Xauthority only.
 
