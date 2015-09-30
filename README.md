# x11docker
 - Run X applications and desktop environments in docker on a separate X11 server.
 - Useful to avoid security issues concerning X forwarding.
 - Doesn't need VNC or SSH. docker applications can directly access the new X server via tcp.
 - Doesn't need configurations inside the image - can run any GUI applications.
 - Authentication via MIT-MAGIC-COOKIES. Separate Xauthority file, it is _not_  ~/.Xauthority

#Usage
 - To run a docker image on a separate X server:<br>
   x11docker [OPTIONS] run [DOCKER_RUN_OPTIONS] IMAGE [COMMAND [ARG1 ARG2 ...]]<br>
 - To start a docker container on a separate X server:<br>
   x11docker [OPTIONS] start [DOCKER_START_OPTIONS] CONTAINER [CONTAINER2 ...]<br>
 - x11docker without any option will only create a new X server and run twm window manager.<br>
<br>
Look at 'x11docker --help' to see all options.<br>

Important:<br>
To start x11docker from console, switch to tty1 with [CTRL][ALT][F1].<br>
To start x11docker from within X11, first run 'dpkg-reconfigure x11-common'
and choose option 'anybody'.

#Explanations
x11docker creates a new X server on a new X socket on a new display. Instead of using
display :0 (standard), docker images will run on display :1 or display :2 ...<br>
To switch to display :0, press [STRG][ALT][F7], to display :1, press [STRG][ALT][F8] and so on, 
equal to switch between virtual consoles (tty1 to tty6) with [STRG][ALT][F1] and so on.

To run single GUI applications, x11docker runs a window manager on the new X Server the dockered
applications can use. As a default, x11docker uses 'twm', which is shipped with every X installtion.
Option '-w, --wm' allows to choose another, more comfortable window manager. 
 - Example: 'x11docker --wm fluxbox run x11docker/lxde-desktop pcmanfm'

To run a full desktop environment like LXDE or XFCE, x11docker creates a new X server on a new display.
 - Example: 'xdocker --desktop run x11docker/lxde-desktop'<br>

Desktops known to work well are: LXDE, XFCE, Mate, KDE.<br>
Desktops known to have problems: Gnome 3.<br>


#Security
 - Using a separate X server / a new display for docker GUI applications avoids issues concerning 
security leaks inside a running X server. 
 - There are some solutions in the web to run dockered GUI applications with X forwarding on display :0, but all of them share the problem of breaking the isolation of dockered applications and allowing them access to X resources like keylogging with 'xinput test'.
 - With x11docker, GUI applications in docker can be isolated from the main display :0 and use the speed benefit of a direkt X connection over tcp, which is much faster than VNC or SSH. 
 - Authenthication is done with MIT-MAGIC-COOKIE, stored separate from ~/.Xauthority. The new X server doesn't know the cookies from the standart X server on display :0.

#Known issues / ToDo:
 - containers have to run on the same X socket as the image was running on when creating the container
