# x11docker: Run GUI applications and desktop environments in docker on a distinct X server.
 - Useful to avoid security issues concerning X forwarding. Secure sandboxing of GUI applications.
 - Can either open a new X display, or can use xpra and Xephyr to show dockered GUI applications on your host X display.
 - Doesn't need VNC or SSH. docker applications can directly access the new X server.
 - Doesn't have dependencies inside the image - can run any GUI applications in docker. 
 - Authentication via MIT-MAGIC-COOKIES. Separate Xauthority file, it is _not_  ~/.Xauthority from host.
 - Sound with pulseaudio is possible
 - Hardware accelerated OpenGL rendering is possible

#GUI for x11docker
There is a comfortable GUI for x11docker. To run x11docker-gui, you need to install 'kaptain'. 
(debian link to kaptain: https://packages.debian.org/search?keywords=kaptain).

![x11docker-gui screenshot](/../screenshots/x11docker-gui.png?raw=true "Optional Title")


#Hardware accelerated OpenGL rendering
Software accelerated OpenGL is available in all provided X servers. The image needs an OpenGL implementation to profit from it.  The easiest way to achieve this is to install package \"mesa-utils\" in your image.
 
 Usage of immediate GPU hardware acceleration for OpenGL/GLX with option --gpu is experimental/beta. You may encounter some
 bugs. For example, Xfce desktop will run fine using software rendering, but can have broken window decorations with hardware rendering. As for now, it works with options --X11 and --hostdisplay only.
 
 Mediate GPU hardware acceleration for OpenGL / GLX with option --virtualgl is possible with VirtualGL (http://www.virtualgl.org). Other than option --gpu, it works with xpra and Xephyr, too, but has the drawback to break container isolation from display :0. Use only with full trusted applications and images. Needs VirtualGL to be installed on host.
 
 Using hardware acceleration can degrade or break container isolation. Look at table in section "Security". 
 
#Pulseaudio sound support
 x11docker supports pulseaudio sound over tcp. For this to use, pulseaudio needs to be installed on host and in docker image.

 
#Dependencies
x11docker can run with standard system utilities without additional dependencies. As a core, it only needs X server and, of course, docker to run docker images on X. 

For some additional options, x11docker needs some packages to be installed.
It will check for them on startup and show terminal messages if some are missing.

List of optional needed packages: xpra xephyr xclip kaptain pulseaudio virtualgl 

- xpra:  option --xpra, showing single applications on your host display
- xephyr:  option --xephyr, showing desktops on your host display
- xclip:  option --clipboard, sharing clipboard with Xephyr or cor X11
- pulseaudio:  option --pulseaudio, sound/audio support
- virtualgl:  option --virtualgl, hardware accelerated OpenGL in xpra and Xephyr. http://www.virtualgl.org
- kaptain:  x11docker-gui


#X servers to choose from
x11docker creates a new X server on a new X socket. Instead of using display :0 from host, docker images will run on display :1 or display :2 ... (with exception from option --hostdisplay)
 - xpra: A comfortable way to run single docker GUI applications visible on your host display is to use xpra. Needs package xpra to be installed.
 - Xephyr: A comfortable way to run desktop environments from within docker images is to use Xephyr. Needs package xephyr to be installed. Also, you can choose option --xephyr together with option --wm and run single applications with a host window manager in Xephyr
 - Core X11 server: To switch to between displays, press [STRG][ALT][F7] ... [STRG][ALT][F12]. Essentially it is the
same as switching between virtual consoles (tty1 to tty6) with [STRG][ALT][F1]...[F6]. To be able to use this option, you have to execute "dpkg-reconfigure x11-common" first and choose option "anybody".
 - Sharing host display: This option is least secure and has least overhead. Instead of running a second X server, your host X server on display :0 is shared.

#Security
 - Using a separate X server aka a new display for docker GUI applications avoids issues concerning security leaks inside a running X server. Most solutions in the web to run dockered GUI applications share the problem of breaking container isolation and allowing access to X resources like keylogging with 'xinput test'.
 - With x11docker, GUI applications in docker can be isolated from main display :0
 - Authentication is done with MIT-MAGIC-COOKIE, stored separate from ~/.Xauthority.  The new X server doesn't know cookies from the host X server on display :0. (Exceptions possible with options --hostdisplay and --virtualgl)
 - With option --no-xhost x11docker checks for any access granted to host X server by xhost and disables it. Host applications then use ~.Xauthority only.
![x11docker-gui security screenshot](/../screenshots/x11docker-security.png?raw=true "Optional Title")
 
#Usage in terminal
To run a docker image with new X server:
 -  x11docker [OPTIONS] IMAGE [COMMAND]
 -  x11docker [OPTIONS] -- [DOCKER_RUN_OPTIONS] IMAGE [COMMAND [ARG1 ARG2 ...]]
  
To run a host application on a new X server:
 -  x11docker [OPTIONS] --exe COMMAND [ARG1 ARG2 ...]

To run only a new X server with window manager:
 -  x11docker [OPTIONS]

Have a look at 'x11docker --help' to see all options.

Example: Run wine and playonlinux on xfce desktop in a sandbox in a Xephyr window, sharing a home folder to preserve settings and wine installations:
   - x11docker --xephyr --sudouser --home --desktop x11docker/xfce-wine-playonlinux start
   
Example: Run playonlinux in a sandbox in an xpra window, sharing a home folder to preserve settings and installations:
   - x11docker --xpra --sudouser --home --desktop x11docker/xfce-wine-playonlinux playonlinux
   
 #ToDo
  - improve --virtualgl performance
  - improve --virtualgl security with --xpra and --xephyr
  - use tcp instead of xsocket with option --gpu to avoid some rendering issues (does not work with docker recently)
  - avoid xclip errors with empty clipboard
