# ToDo
x11docker ToDo notes

## Enhacement
 - `--weston[-xwayland]/--kwin[-xwayland]`: check for nvidia/Xwayland versions
 - `--runtime`: check sysbox runtime: https://github.com/nestybox/sysbox

## Actually to fix
 - `--exe`: Give notes for invalid options.
 - `--update`: Check if root is needed in custom installation path. Do not install other files then.
 - `--password, --install, --update, --cleanup`, etc.: give note about dropped options.
   Maybe change to $1 mode without `--`
 - check `--init=` in all backends rootful and rootless.
 - `--user`: Check in all rootless modes, maybe disallow except for `--user=root`.
 - `--user=root --home` in rootless docker and nerdctl: Set up HOME in host user ~/x11docker.
 - `--backend=podman` rootless: disallow `--home` for different `--user`.
 - `--init=systemd`: cgroupv2 support #349

## Old issues to fix
 - `--gpu --webcam` adds user to group `video` twice.
 - docker-for-win: DOS newline mess in `error()` #219.
 - docker-for-win: Double entries in log.
 - `--install`/`--update`: first install shows entire `CHANGELOG.md`. Should only show most recent release notes.
 - replace `find` in `containerrootrc`, missing in fedora images.
 - error message window in Wayland fails: xterm: no display. x11docker should use `konsole` or `xfce4-terminal`.
 - `--env`: check escapestring results in `containerrc`, some ugly strings are not escaped well

## Nice to fix
 - `--init=systemd`: check systemd warnings on x11docker services
 - `--printer`: regard host environment variable `CUPS_SERVER`. Maybe already done by `lpadmin`.
 - `pspid()`: On some systems (busybox) `ps -p` is not supported
 - `--runtime=kata-runtime`: `x11docker/lxde` needs `--init=systemd`, why? Sort of `menud` issue.
 - `--runtime=kata-runtime --nxagent`: ALT-GR works wrong.
 - `myrealpath()`: If `realpath` is missing, the path argument is returned without resolving.
 - `--interactive --init=runit|openrc|sysvinit`: no job control in shell
 - `--interactive` not possible without `winpty` in WSL and Cygwin
 - `--interactive --enforce-i` fails. Issue is subshell containershell & in main, would work without it.
 - `--group-add`: gid 101 for both possible: `messagebus` and `systemd-journal`, works nonetheless.
 - `--keymap` does not work on tty with `--kwin` and `--kwin-xwayland`. No idea how to set it.
 - `--wayland --user`: wayland socket access denied due to `XDG_RUNTIME_DIR` file access permissions

## Nice to fix (images)
 - `x11docker/check`: Print several checks in terminal before running gui
 - `x11docker/fluxbox` on arch host: background can miss, sometimes no context menu. Where is the difference to other hosts?
 - `--sudouser`: `su` to root in void containers fails.
 - `elogind` in alpine: `su` does not take effect. missing policykit? pam corrupted by x11docker?
 - `elogind` in void container: loginctl is empty. ck-list-sessions, too.

## Needs investigation and probably 3d party bug report
  - `startplasmacompositor`: hardcoded `--libinput` causes failure if running nested
  - `kwin_wayland` needs `CAP_SYS_RESOURCE` even if running nested
  - `--xpra --desktop --xdummy`: --size modeline does not work, might not even appear in xrandr although set in xdummy.xorg.conf
  - `Xwayland` does not support X over IP (`-listen tcp`)

## 3rd party bugs
 - `--iglx --gpu` fails since X.org 1.18.4: 
   https://gitlab.freedesktop.org/xorg/xserver/issues/211
 - Xwayland does not always sit at 0.0 on multiple outputs. 
   https://bugzilla.redhat.com/show_bug.cgi?id=1498665
 - `--kwin*`: wrong fullscreen and crashes in gnome-wayland, strange in weston, WAYLAND_DISPLAY="" does not help, probably bug in kwin
 - scale>1 Xwayland in Weston is too large (Xwayland bug), rendering issues on tty (switching scaled/unscaled Xwayland on keyboard/mouse events). 
   https://bugzilla.redhat.com/show_bug.cgi?id=1498669
 - x11docker-gui in weston freezes weston in combo boxes. Weston bug? QT3/4 bug?
 - debian bug report lightdm/sddm contra gdm, dm can crash on tty switch if multiple graphical sessions are running
  
## Improvements
 - `--cleanup`: avoid hardcoded paths
 - support `--exe --user` ?
 - avoid losing `dockerstopshell` from process tree
 - avoid losing hostexe from process tree
 - `dockerstopshell` does not react if fifofile is deleted.
 - dependency wiki: Cygwin packages
 - `capsh`: replace `su` with `capsh`? (missing in alpine) But how to trigger login?
 - `x11docker/check`: palinopsia: check video RAM size with `glxinfo`, adjust requested RAM size.
 - further checks of `/etc/pam.d`
 - further checks of multimonitor behaviour
 - `--init=s6-overlay`: find better solution then sleep loop for empty CMD
 - `--init=s6-overlay`: check possible shutdown routine for timetosaygoodbye
 - `--init=s6-overlay`: closer check of needed capabilities
 - fedora: SElinux issue: `--security-opt label=type:container_runtime_t`: need more restrictive setting to just allow socket access.
   https://unix.stackexchange.com/questions/386767/selinux-and-docker-allow-access-to-x-unix-socket-in-tmp-x11-unix
  
