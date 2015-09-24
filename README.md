# x11docker
Run X applications and desktop environments in docker on a separate X11 server
Useful to avoid security issues concerning X forwarding.

Known issues / ToDo:

 - containers have to run on the same X socket as the image did when creating the container
 - screensavers from within a docker container appear on the primary X display. (Maybe a security leak? Keylogging is not    possible anymore, but maybe "screenlooking")
 - some desktop environment based on QT have problems (plasma-desktop, KDE, razorqt)
