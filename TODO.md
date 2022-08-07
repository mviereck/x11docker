# ToDo
x11docker ToDo notes

## Work in progress
 - kata: add new runtime for nerdctl io.containerd.kata.v2 

 - --kwin in weston segfaults
 - --xc --xorg: MIT-SHM fails
 - --xc --xorg rootless fails
 - --xc --kwin on console: tty switch fails with unprivileged user

 - --build=nvidia?
 - x11docker/nvidia-base: use tags with version number?

 - --clipboard: improve Wayland clipboard support

 - further centralize argument checks
 - change global "no" to ""

 - --pulseaudio=host: check possible tcp setup
 - --interactive fails now with old systemd versions. (wontfix, not important enough)

 - --interactive --init=runit|openrc|sysvinit: no job control in shell
 - --init=openrc|runit: elogind fails
 - check elogind with cgroupv2. maybe drop --sharecgroup and set up in container only

 - sommelier
 - --backend=systemd-nspawn|lxc|lxd|runc
 - check empty XDG_RUNTIME_DIR e.g. with --user, --hostuser
 - --weston2-xwayland?
 
 - --backend=proot
   - --name
   - --init except systemd possible?
   - clean /tmp
   - how to disable old binds? issue e.g. with/without --home, --share
 

## Issues to fix
 - --build: download files for COPY/ADD (x11docker/check, x11docker/xserver)
 - `--remove`: give note about not removed files in `~./config/x11docker` and `/etc/x11docker`
 - `--update`: Check if installs not into `/usr/bin` or `/usr/local/bin`. Do not install other files then.
   Maybe change to $1 mode without `--`
   
## Checks
 - check all `--init=` in all backends rootful and rootless.
   - checked: 
     - rootful docker: all
     - rootless podman: systemd, openrc
     - rootful podman: openrc
     - rootless nerdctl: openrc
     - rootful nerdctl: openrc
 - `--user`: Check in all rootless modes, maybe disallow except for `--user=root`.
 - `--user=root --home` in rootless docker and nerdctl: Set up HOME in host user ~/x11docker?
 - `--backend=podman` rootless: disallow `--home` for different `--user`.

## Old issues to fix
 - `--kwin-xwayland`: broken? Xwayland says: "missing wl_shell protocol". Deprecated yet.
 - docker-for-win: DOS newline mess in `error()` #219.
 - docker-for-win: Double entries in log.

## Nice to fix
 - `--init=systemd`: check systemd warnings on x11docker services
 - `--printer`: regard host environment variable `CUPS_SERVER`. Maybe already done by `lpadmin`.
 - `pspid()`: On some systems (busybox) `ps -p` is not supported
 - `--runtime=kata-runtime`: `x11docker/lxde` needs `--init=systemd`, why? Sort of `menud` issue.
 - `--runtime=kata-runtime --nxagent`: ALT-GR works wrong.
 - `myrealpath()`: If `realpath` is missing, the path argument is returned without resolving.
 - `--interactive` not possible without `winpty` in WSL and Cygwin
 - `--interactive --enforce-i` fails. Issue is subshell containershell & in main, would work without it.
 - `--group-add`: gid 101 for both possible: `messagebus` and `systemd-journal`, works nonetheless.
 - `--keymap` does not work on tty with `--kwin` and `--kwin-xwayland`. No idea how to set it.
 - `--wayland --user`: wayland socket access denied due to `XDG_RUNTIME_DIR` file access permissions

## Nice to fix (images)
 - `x11docker/fluxbox` on arch host: background can miss, sometimes no context menu. Where is the difference to other hosts?

## 3rd party bugs
  - `kwin_wayland` needs `CAP_SYS_RESOURCE` even if running nested
  - `Xwayland` does not support X over IP (`-listen tcp`) or iglx.
 - Xwayland does not always sit at 0.0 on multiple outputs. 
   https://bugzilla.redhat.com/show_bug.cgi?id=1498665
 - `--kwin*`: wrong fullscreen and crashes in gnome-wayland, strange in weston, WAYLAND_DISPLAY="" does not help, probably bug in kwin
 - scale>1 Xwayland in Weston is too large (Xwayland bug), rendering issues on tty (switching scaled/unscaled Xwayland on keyboard/mouse events). 
   https://bugzilla.redhat.com/show_bug.cgi?id=1498669
  
## Improvements
 - `--cleanup`: avoid hardcoded pathes
 - `x11docker/check`: palinopsia: check video RAM size with `glxinfo`, adjust requested RAM size.
 - further checks of `/etc/pam.d`
 - further checks of multimonitor behaviour
 - `--init=s6-overlay`: find better solution then sleep loop for empty CMD
 - `--init=s6-overlay`: check possible shutdown routine for timetosaygoodbye
 - `--init=s6-overlay`: closer check of needed capabilities
 - fedora: SElinux issue: `--security-opt label=type:container_runtime_t`: need more restrictive setting to just allow socket access.
   https://unix.stackexchange.com/questions/386767/selinux-and-docker-allow-access-to-x-unix-socket-in-tmp-x11-unix
  
