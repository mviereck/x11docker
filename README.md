# x11docker
 - Run X applications and desktop environments in docker on a separate X11 server.
 - Useful to avoid security issues concerning X forwarding.
 - Can either open a new X display, or can use Xpra and Xephyr to show dockered GUI applications an your main X display
 - Doesn't need VNC or SSH. docker applications can directly access the new X server via tcp.
 - Doesn't have dependencies inside the image - can run any GUI applications in docker. (Doesn't even need an X server to be installed in the image.)
 - Authentication via MIT-MAGIC-COOKIES. Separate Xauthority file, it is _not_  ~/.Xauthority

# Usage
To run a docker image with new X server:
 -  x11docker [OPTIONS] IMAGE [COMMAND]
 -  x11docker [OPTIONS] -- [DOCKER_RUN_OPTIONS] IMAGE [COMMAND [ARG1 ARG2 ...]]
  
To run a host application on a new X server:
 -  x11docker [OPTIONS] --exe COMMAND
 -  x11docker [OPTIONS] --exe -- COMMAND [ARG1 ARG2 ...]

To run only a new X server with window manager:
 -  x11docker [OPTIONS]

Look at 'x11docker --help' to see all options.

#Explanations
x11docker creates a new X server on a new X socket on a new display. Instead of using
display :0 (standard), docker images will run on display :1 or display :2 ...

To switch to between displays, press [STRG][ALT][F7] ... [STRG][ALT][F12], it is the
same as switching between virtual consoles (tty1 to tty6) with [STRG][ALT][F1] and so on.

To have it more comfortable, you can install and use Xpra and Xephyr. With Xpra and Xephyr 
the dockered GUI applications will show up on your main display, and you don't need to switch
between different tty's.

Example: This will run an LXDE desktop environment in docker, showing it in a Xephyr window on your main display:
 - x11docker --xephyr --desktop x11docker/lxde-desktop

#Security
 - Using a separate X server / a new display for docker GUI applications avoids issues concerning 
security leaks inside a running X server. 
 - There are some solutions in the web to run dockered GUI applications with X forwarding on display :0, but all of them share the problem of breaking the isolation of dockered applications and allowing them access to X resources like keylogging with 'xinput test'.
 - With x11docker, GUI applications in docker can be isolated from the main display :0 and use a really fast connection over local tcp to the new X server. This is much faster than VNC or SSH. 
 - x11docker uses tcp instead of mounting a host X socket in docker. (Direct access from docker to a host X socket causes dangerous issues including bad RAM access, framebuffer errors and application crashes. x11docker avoids this using tcp).
 - Authenthication is done with MIT-MAGIC-COOKIE, stored separate from ~/.Xauthority. The new X server doesn't know the cookies from the standart X server on display :0.
