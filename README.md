# Screenshots of GUI applications and desktop environments running with x11docker 

`x11docker --desktop --gpu --init=systemd -- x11docker/gnome`
![screenshot](screenshot-gnome.png "Gnome 3 desktop")

`x11docker --wm --gpu x11docker/check`
![screenshot](screenshot-check.png "Checking container isolation with x11docker/check")

`x11docker --desktop x11docker/lxqt`
![screenshot](screenshot-lxqt.png "LXQT desktop running in Xnest window using x11docker")

`x11docker --desktop --gpu --systemd --pulseaudio x11docker/deepin`
![screenshot](screenshot-deepin.png "deepin desktop running in Weston and Xwayland window using x11docker")

`x11docker --desktop --gpu x11docker/plasma`
![screenshot](screenshot-plasma.png "plasma desktop running in Weston window using x11docker")

`x11docker --desktop x11docker/fluxbox`
![screenshot](screenshot-fluxbox.png "fluxbox window manager running in Xephyr window using x11docker")

`x11docker --desktop x11docker/mate`
![screenshot](screenshot-mate.png "Mate desktop running in Xnest window using x11docker")

`x11docker --desktop --runit --gpu x11docker/enlightenment`
![screenshot](screenshot-enlightenment.png "enlightenment window manager running in Weston window using x11docker")

`x11docker --desktop --gpu x11docker/trinity`
![screenshot](screenshot-trinity.png "Trinity desktop")

`x11docker --desktop --gpu --systemd x11docker/cinnamon`
![screenshot](screenshot-cinnamon.png "Cinnamon desktop started with systemd")

`x11docker --desktop x11docker/xfce`
![screenshot](screenshot-xfce.png "Xfce desktop running in Xephyr window using x11docker")

`x11docker --desktop x11docker/lxde`
![screenshot](screenshot-lxde.png "LXDE desktop running in Xephyr window using x11docker")

`x11docker --desktop x11docker/xfce-wine-playonlinux`
![screenshot](screenshot-xfce-wine-playonlinux.png "xfce-wine-playonlinux desktop running in Xephyr window using x11docker")

`x11docker --desktop x11docker/lxde-wine`
![screenshot](screenshot-lxde-wine.png "lxde-wine desktop running in Xephyr window using x11docker")

`x11docker --desktop x11docker/lumina`
![screenshot](screenshot-lumina.png "lumina desktop running in Xephyr window using x11docker")

`x11docker --wayland --gpu x11docker/xwayland`
![screenshot](screenshot-xwayland.png "Xwayland in docker with fvwm desktop in Weston window")

`x11docker --xfishtank`
![screenshot](screenshot-xfishtank.png "X fish tank")

`x11docker jess/cathode`

![screenshot](screenshot-retroterm.png "cool retro term running in Xpra window using x11docker")

`x11docker --desktop --size 320x240 x11docker/lxde`

![screenshot](screenshot-lxde-small.png "LXDE desktop in Xephyr window using x11docker")

`x11docker x11docker/lxde-wine xterm`

![screenshot](screenshot-xpra-pstree.png "xterm showing pstree in xpra window using x11docker")

[Interactive xterm during `docker build`](https://github.com/mviereck/x11docker/wiki/docker-build-with-interactive-GUI)
![screenshot](screenshot-dockerbuild.png "Interactive xterm during docker build")

![screenshot](x11docker-gui.png "x11docker GUI main")

![screenshot](x11docker-512x512.png "x11docker logo")
