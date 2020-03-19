# ToDo
x11docker ToDo notes

## Actually to fix
 - `--xorg` does not enable `--wm` but should do it.
 - docker-for-win: DOS newline mess in `error()` #219.
 - docker-for-win: Double entries in log.
 - `--wm`: XTEST warning does not appear if dockerrc runs host wm as a fallback.
 - `--install`/`--update`: first install shows entire `CHANGELOG.md`. Should only show most recent release notes.
 - replace `find` in `containerrootrc`, missing in fedora images.
 - error message window in Wayland fails: xterm: no display. x11docker should use `konsole` or `xfce4-terminal`.
 - `--env`: check escapestring results in `containerrc`, some ugly strings are not escaped well

## Nice to fix
 - `--init=systemd`: check systemd warnings on x11docker services
 - `--xpra-xwayland --desktop --size`: wrong size
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
 - `--wayland --user|--hostuser`: wayland socket access denied due to `XDG_RUNTIME_DIR` file access permissions

## Nice to fix (images)
 - `x11docker/fluxbox` on arch host: background can miss, sometimes no context menu. Where is the difference to other hosts?
 - `--sudouser`: `su` to root in void containers fails.
 - `elogind` in alpine: `su` does not take effect. missing policykit? pam corrupted by x11docker?
 - `elogind` in void container: loginctl is empty. ck-list-sessions, too.

## Needs investigation and probably 3d party bug report
  - `--weston-xwayland`: Weston is resizeable now, but Xwayland root window does not draw new area
  - `--xpra-xwayland`, `--weston-xwayland`: Xwayland does not fit Weston window size if parts of weston window are offscreen
  - `startplasmacompositor`: hardcoded `--libinput` causes failure if running nested
  - `kwin_wayland` needs `CAP_SYS_RESOURCE` even if running nested
  - `--xpra-xwayland --desktop`: resize & redraw issues
  - `--xpra --desktop`: sometimes redraw issues on resize
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
 - x11docker-gui in weston freezes weston in combo boxes. Weston bug ? QT3/4 bug?
 - debian bug report lightdm/sddm contra gdm, dm can crash on tty switch if multiple graphical sessions are running
  
## Improvements
 - `--update`: regard possible location in `/opt`
 - `--cleanup`: avoid hardcoded pathes
 - support `--exe --user` ?
 - avoid loosing `dockerstopshell` from process tree
 - avoid loosing hostexe from process tree
 - `dockerstopshell` does not react if fifofile is deleted.
 - reduce number of variables with `storeinfo()`
 - dependeny wiki: Cygwin packages
 - `capsh`: replace `su` with `capsh`? (missing in alpine) But how to trigger login?
 - `x11docker/check`: palinopsia: check video RAM size with `glxinfo`, adjust requested RAM size.
 - further checks of `/etc/pam.d`
 - further checks of multimonitor behaviour
 - `--init=s6-overlay`: find better solution then sleep loop for empty CMD
 - `--init=s6-overlay`: check possible shutdown routine for timetosaygoodbye
 - `--init=s6-overlay`: closer check of needed capabilities
 - fedora: SElinux issue: `--security-opt label=type:container_runtime_t`: need more restrictive setting to just allow socket access.
   https://unix.stackexchange.com/questions/386767/selinux-and-docker-allow-access-to-x-unix-socket-in-tmp-x11-unix
  
