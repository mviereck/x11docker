# ToDo
x11docker ToDo notes

## Current
report: Xwayland -rootless -decorate: Misleading geometry error message
report: weston Xwayland display number
report?: --nxagent: -ac -auth bug
--clipboard: use wl-paste --watch if possible
--satellite version check, waiting for release yet
--weston=X: Do not terminate if Xwayland terminates?
--xpra firefox: black window on first firefox startup
--runtime=sysbox -xorg --xc fails
--labwc?
--display: Newwaylandnumber
screen capture in x11docker/check
profile.d: check for xrdp #554
bug NVIDIA: --xc=force --gpu --xorg (nvidia): black screen after terminating, no tty switch possible.
workaround yet: --backend=podman --hostdisplay fails > glxgears: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by /x11docker/XlibNoSHM.so)
further centralize argument checks

## Old issues to check
 - use ~/.Xauthority in general? issues with --retain setups, need to check images for HOME and USER etc.
 - `--remove`: give note about not removed files in `~./config/x11docker` and `/etc/x11docker`
 - `--update`: Check if installs not into `/usr/bin` or `/usr/local/bin`. Do not install other files then.
 - bug: ssh: --hostdisplay fails
 - bug: setting XAUTHORITY with systemctl
 - --xc --xorg: MIT-SHM fails
 - --xc --xorg rootless fails
 - check empty XDG_RUNTIME_DIR e.g. with --user, --hostuser 
 - --interactive --init=runit|openrc|sysvinit: no job control in shell
 - --interactive fails now with old systemd versions. (wontfix, not important enough)
 - --init=openrc|runit: elogind fails
 - check elogind with cgroupv2. maybe drop --sharecgroup and set up in container only
 - docker-for-win: DOS newline mess in `error()` #219.
 - docker-for-win: Double entries in log.
 - `--init=systemd`: check systemd warnings on x11docker services
 - `--printer`: regard host environment variable `CUPS_SERVER`. Maybe already done by `lpadmin`.
 - `myrealpath()`: If `realpath` is missing, the path argument is returned without resolving.
 - `--interactive` not possible without `winpty` in WSL and Cygwin
 - `--interactive --enforce-i` fails. Issue is subshell containershell & in main, would work without it.
 - `--group-add`: gid 101 for both possible: `messagebus` and `systemd-journal`, works nonetheless.
 - `--wayland --user`: wayland socket access denied due to `XDG_RUNTIME_DIR` file access permissions

## Nice to check
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

## 3rd party bugs
  - `Xwayland` does not support X over IP (`-listen tcp`) or iglx.
 - Xwayland does not always sit at 0.0 on multiple outputs. 
   https://bugzilla.redhat.com/show_bug.cgi?id=1498665
 - scale>1 Xwayland in Weston is too large (Xwayland bug), rendering issues on tty (switching scaled/unscaled Xwayland on keyboard/mouse events). 
   https://bugzilla.redhat.com/show_bug.cgi?id=1498669
  
## Improvements
 - `--cleanup`: avoid hardcoded paths
 - `x11docker/check`: palinopsia: check video RAM size with `glxinfo`, adjust requested RAM size.
 - further checks of `/etc/pam.d`
 - further checks of multimonitor behaviour
 - `--init=s6-overlay`: find better solution than sleep loop for empty CMD
 - `--init=s6-overlay`: check possible shutdown routine for timetosaygoodbye
 - `--init=s6-overlay`: closer check of needed capabilities
 - fedora: SElinux issue: `--security-opt label=type:container_runtime_t`: need more restrictive setting to just allow socket access.
   https://unix.stackexchange.com/questions/386767/selinux-and-docker-allow-access-to-x-unix-socket-in-tmp-x11-unix
  
