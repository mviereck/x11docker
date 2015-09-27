# x11docker (beta version)
 - Run X applications and desktop environments in docker on a separate X11 server.<br>
 - Useful to avoid security issues concerning X forwarding.<br>
 - Doesn't need VNC or SSH. docker applications can directly access the new X server.<br>
 - This software is in development and will have major changes in the near future. Please look at 'Known issues / ToDo' list before using it.

#Usage
 - To run a docker image on a separate X server:<br>
   x11docker [OPTIONS] run [DOCKER_RUN_OPTIONS] IMAGE [COMMAND [ARG1 ARG2 ...]]<br>
 - To start a docker container on a separate X server:<br>
   x11docker [OPTIONS] start [DOCKER_START_OPTIONS] CONTAINER [CONTAINER2 ...]<br>
 - x11docker without any option will only create a new X server and run flwm.<br>
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
applications can use. As a default, x11docker uses 'flwm', which is lightweight and fast. 
Option '-w, --wm' allows to choose another window manager. 
 - Example: 'x11docker --wm fluxbox run x11docker/lxde-desktop pcmanfm'

To run a full desktop environment like LXDE or XFCE, x11docker creates a new X server on a new display
and forwards it to the image. 
 - Example: 'xdocker --desktop run x11docker/lxde-desktop'<br>

Desktops known to work well are: LXDE, XFCE, Mate.<br>
Desktops known to have problems: KDE, razorqt, Gnome 3.<br>

#Security
Using a separate X server / a new display for docker GUI applications avoids issues concerning 
security leaks inside a running X server. There are some solutions in the web to run dockered GUI 
applications with X forwarding on display :0, but all of them share the problem of breaking the isolation
of dockered applications and allowing them access to X resources like keylogging with 'xinput test'.<br>
With x11docker, GUI applications in docker can be isolated from the main display :0 and use the speed benefit
of X forwarding, which is much faster than VNC tunneling.
<br>

#Known issues / ToDo:
major:
 - sometimes even well working desktops like lxde and xfce show damaged icons or cannot run desktop manager. Stopping and restarting often solves the issue. It seems to be a problem either in X or in the connection between X and container.
 - The main display 0: is not accessable for containers, and that is as it should be, but the new X server needs to have its own authentication so only the container can access it (not implemented yet, important to do).<br>

minor:<br> 
 - containers have to run on the same X socket as the image was running on when creating the container
 - screensavers from within a docker container appear on the primary X display. (Maybe a security leak? Keylogging is not possible anymore, but maybe "screenlooking")
 - some desktop environment based on QT can start, but have problems to display their content (plasma-desktop, KDE, razorqt)
 - gnome-shell crashes in docker

