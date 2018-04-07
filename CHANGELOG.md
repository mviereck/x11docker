# Changelog of x11docker
### Website: https://github.com/mviereck/x11docker

----------------

## Version: 4.0.0
#### Date: 2018-04-07
 - Outsourced changelog from x11docker source code to `CHANGELOG.md` [(#38)](https://github.com/mviereck/x11docker/issues/38)
 - Stricter compliance to [Semantic Versioning](https://semver.org/) rules. [(#38)](https://github.com/mviereck/x11docker/issues/38)

## Version: [3.9.9](https://github.com/mviereck/x11docker/tree/)
#### Date: 2018-04-06
 - Removed `--security-opt=no-new-privileges` for `--systemd`/`--sysvinit`/`--runit`/`--openrc`. (Undoes some changes from V3.9.8.1). Will be reintroduced after further checks, caused issues with `x11docker/deepin` and `x11docker/cinnamon`.
 - `--env`: set environment variables in `docker run`, too. Makes them available within `docker exec`.

## Version: [3.9.8.5](https://github.com/mviereck/x11docker/tree/6227a1eebc5b63df305822896d7360a14440caf4)
#### Date: 2018-04-05
 - `finish()`: run `docker stop` before creating `timetosaygoodbye` for more graceful shutdown [(#37)](https://github.com/mviereck/x11docker/issues/37)
 - **bugfix** correct `XAUTHORITY` in setup script
 - **bugfix** disable `User` in systemd journal service

## Version: [3.9.8.4](https://github.com/mviereck/x11docker/tree/d74fa2defceb538d8c9e90932d48f23cae0f102b)
#### Date: 2018-04-04
 - **new option** `--workdir` to set working directory different from `HOME`. ([#36](https://github.com/mviereck/x11docker/issues/36))
 - `--systemd`/`--dbus-system`: changed `su` command to remove `sh` from pstree
 - **bugfix** user group entry in `/etc/group`

## Version: [3.9.8.3](https://github.com/mviereck/x11docker/tree/6ce5d2cbd7a14556723a3c8e1163988f2ddda8ce)
#### Date: 2018-04-04
 - **bugfix** `--dbus-system`: **regression**: must not set `--security-opt=no-new-privileges`

## Version: [3.9.8.2](https://github.com/mviereck/x11docker/tree/a58e6808254ce78eb528010584ff9d7ef9b8aa26)
#### Date: 2018-04-03
 - disable entrypoint `tini` if x11docker already runs an init system (default: `tini` from docker).

## Version: [3.9.8.1](https://github.com/mviereck/x11docker/tree/75f79c9888beee08ca08c42c5f70feaa0f02cd30)
#### Date: 2018-04-03
 - show container ID on stdout ([#36](https://github.com/mviereck/x11docker/issues/36))
 - `--security-opt=no-new-privileges` now always set except for `--sudouser`. It does not harm switching from root to less privileged users.
 - setup script with user switching: `exec su` instead of `su` to avoid root shell in parent tree. `su` is now child of `init`.

## Version: [3.9.8.0](https://github.com/mviereck/x11docker/tree/a4067993a91f39bce145b48406453f786d1707eb)
#### Date: 2018-04-02
 - Removed Xtermlogfile,  using Dockerlogfile instead. Strange: solved missing output with `--pw=su` or `--pw=sudo`, too.
 - Escape special characters in `--env`, `ENV` and image command. (adresses [#34](https://github.com/mviereck/x11docker/issues/34), too, now solved better)

## Version: [3.9.7.9](https://github.com/mviereck/x11docker/tree/)
#### Date: 2018-03-31
 - Store parsed parts of $Imagecommand in single backticks to allow constructs like:  `sh -c "cd /etc ; xterm"`
 - **bugfix**: add `--rm` to docker run for environment check

## Version: [3.9.7.8](https://github.com/mviereck/x11docker/tree/4d619bfbcae605b25ee93778936245019a8a7020)
#### Date: 2018-03-31
 - Handle equal signs in container environment defined with `ENV` ([#34](https://github.com/mviereck/x11docker/issues/34))

## Version: [3.9.7.7](https://github.com/mviereck/x11docker/tree/733b8f9b9228d5fa3b167a4771976bcc610ac0de)
#### Date: 2018-03-31
 - Handle whitespaces in container environment defined with `ENV` ([#34](https://github.com/mviereck/x11docker/issues/34))

## Version: [3.9.7.6](https://github.com/mviereck/x11docker/tree/65305faba992415b8b255a4fac7e89c4417e5a1e)
#### Date: 2018-03-30
 - mount X socket and lockfile read-only to protect from `/tmp` cleanup of init systems
 - minor improvements of init system initialization
 - remove checks for `--userns-remap` and `--selinux-enabled`. [(#33)](https://github.com/mviereck/x11docker/issues/33)

## Version: [3.9.7.5](https://github.com/mviereck/x11docker/tree/0f0b138db7c2f3093511fae7583b34bc44db3423)
#### Date: 2018-03-30
 - `--dbus-system`: drop consolekit
 - `--sysvinit`,`--openrc`: disable getty in inittab instead of overwriting inittab with shared volume
 - `--sysvinit`: change `rc.local` in setupscript instead of overwriting it with shared volume
 - `--openrc`, `--runit`: create service in setupscript, drop some more capabilities

## Version: [3.9.7.4](https://github.com/mviereck/x11docker/tree/)
#### Date: 2018-03-26
 - **new option** `--sysvinit` for init system SysVinit in container. Tested with devuan.
 - **bugfix** `--pulseaudio`: need to set environment variable `PULSE_SERVER`
 - `--runit`: add softlink for X socket in `x11docker.CMD.sh` for compatibility with `runit` on debian

## Version: [3.9.7.3](https://github.com/mviereck/x11docker/tree/57e34236dca42e05434a304c77f61202d678398a)
#### Date: 2018-03-21
 - `--pulseaudio`: share socket `XDG_RUNTIME_DIR/pulse` instead of connecting over tcp

## Version: [3.9.7.2](https://github.com/mviereck/x11docker/tree/25201b916159b2f77d6c6188ea875d80004733d1)
#### Date: 2018-03-20
 - Fix `writeaccess()` for user/group names with spaces in it [#30](https://github.com/mviereck/x11docker/issues/30)
 - `--wm`: fall back to autodetection if specified window manager not found
 - **bugfix** `--env`: regard whitespace. Still need to handle special chars like"\`$.
 - **new option** `--add` to add a host command in `xinitrc`
 - consolekit: enable and use automatically for `--dbus-system`, `--openrc`, `--runit`
 - `--dbus`: enable automatically for `--runit`, `--openrc`
 - `mywatch()`: use `watch` again, now without `sh -c`
 - **new option** `--debug` to set `-x` in all scripts showing code lines while executed.
 - **deprecated** `--sharewayland`, `--waylandenv`: not needed for anything anymore. `--wayland` does the job.
 - `--help`: `usage()` cleanup

## Version: [3.9.7.1](https://github.com/mviereck/x11docker/tree/4aaa1cf3c9de7b5924a05cd1ace29e60b3903327)
#### Date: 2018-03-16
 - **bugfix** alpine images: `/etc/shadow` entry must be `/bin/sh`, `--dbus-system` with `su` fails with `/bin/bash`
 - **bugfix** openSUSE: `finish()`: replace `bc` with bash-only calculation, `bc` is missing on openSUSE

## Version: [3.9.7](https://github.com/mviereck/x11docker/tree/82e573068bfe78a9650f40cb5b98df9b1e08d483)
#### Date: 2018-03-15
 - **bugfix** openSUSE/fedora: `ps` check for container pid; fixed desktop logout issue, too.
 - structure change: don't `sleep 1` for setup; instead wait for it in `x11docker.CMD.sh` resp. run `su` or `init` in setup
 - SSH with `--hostdisplay`: set `--hostipc`, `--hostnet` and `--trusted`. Do not X-generate cookie, bake it myself.
 - **bugfix** `---weston`/`--weston-xwayland`: do not start drm backend if started within X without `DISPLAY` -> crashed host X
 - **bugfix**: regard ssh session, assume tty if `DISPLAY` is empty
 - **bugfix**: `--hostdisplay`: don't set keymap
 - xinitrc: some cleanup
 - `--verbose`: power of moo

## Version: [3.9.6.1](https://github.com/mviereck/x11docker/tree/1e482bc9341a6c22771b3ba602edb847e25d6d82)
#### Date: 2018-03-10
 - `--lang`: replace `locale-gen` with more general available `localedef`
 - `--tini`: check for `docker-init` in `PATH`, disable option if missing ([#23](https://github.com/mviereck/x11docker/issues/23))

## Version: [3.9.6](https://github.com/mviereck/x11docker/tree/0a4166c020c9700e592c0d7600b4a8b5e9850222)
#### Date: 2018-03-09
 - **new option** `--lang` to set language locale in utf8, create it if missing.

## Version: [3.9.5](https://github.com/mviereck/x11docker/tree/9a86a235f82e900d83bb0bbd4e2b85db60c5335b)
#### Date: 2018-03-06
 - **new option** `--keymap` to set keyboard layout

## Version: [3.9.4.2](https://github.com/mviereck/x11docker/tree/4777416424b379dfc52240e8a32fe10bbef0a25f)
#### Date: 2018-03-06
 - store keyboard layout (xkb_keymap) in separate file, not in xinitrc. Set on all X servers. [#25](https://github.com/mviereck/x11docker/issues/25)

## Version: [3.9.4.1](https://github.com/mviereck/x11docker/tree/68a7a529b807f40d102842ebc3fe16ca3435b771)
#### Date: 2018-03-06
 - **bugfix**/typo `--pulseaudio`
 - share `/etc/localtime` with container to have the same time

## Version: [3.9.4.0](https://github.com/mviereck/x11docker/tree/fa043c37d029982ed44431032f37e05f5c5f0024)
#### Date: 2018-03-05
 - `--pulseaudio` `--hostnet`: no fallback to `--alsa`, use localhost IP instead
 - `--pulseaudio` `--no-internet`: fallback to `--alsa`
 - clean up error message on docker startup failure, remove multiple error lines
 - **bugfix**: `--systemd`: terminate x11docker if systemd startup fails
 - stdout and stderr of image command outsourced of docker.log
 - docker log -f > docker.log to get output in detached mode
 - `--sys-admin`: no longer **deprecated**, needed for debian 9 images (but not debian 10).
 - `--net` and `--ipc` changed to `--hostnet` and `--hostipc`
 - `--dbus-daemon` changed to `--dbus-system`
 - `--auto` `--gpu`: fallback to `--hostdisplay` for seamless mode if xpra and weston not found ([#23](https://github.com/mviereck/x11docker/issues/23))
 - [#24](https://github.com/mviereck/x11docker/issues/24) mount /dev/dri and /dev/snd not only with `--device`, but also `--volume` to keep ownership+group
 - **bugfix** `--hostdisplay`: Use correct display number to share /tmp/.X0-lock, only share if it exists
 - more verbose messages in waiting routines

## Version: [3.9.3.2](https://github.com/mviereck/x11docker/tree/f28e182de62f7f25a5458d6d1db28aee5f339eb3)
#### Date: 2018-03-01
 - `--no-xtest`: disable extension XTEST. Default for most options.
 - openSUSE docker package misses init binary, show warnings for `--tini`, issue [#23](https://github.com/mviereck/x11docker/issues/23)

## Version: [3.9.3.1](https://github.com/mviereck/x11docker/tree/7883bb089dc1ea8c438ed7be123e3bfcbd4eded2)
#### Date: 2018-03-01
 - fix XTEST warning messages

## Version: [3.9.3](https://github.com/mviereck/x11docker/tree/4f8cd878dcc44469bdb9afce2f91afce3abcda8a)
#### Date: 2018-03-01
 - `--tini`: show warning for outdated docker versions without option `--init` and fall back to `--no-init`, issue [#23](https://github.com/mviereck/x11docker/issues/23)
 - **new option** `--xtest` to enable X extension XTEST. Default for `--xdummy`, `--xvfb`, `--xpra`
 - `--pulseaudio` with `--net`: fallback to `--alsa`, disabling `--pulseaudio`

## Version: [3.9.2.3](https://github.com/mviereck/x11docker/tree/62e31a381b79b67a1eea9f84b629a849833249c0)
#### Date: 2018-02-25
 - set container GID of video and audio to same as on host
 - cat docker daemon messages for startup error message
 - **bugfix** `--kwin`: kwin_wayland seems to need dbus-launch now
 - mywatch(): replaced watch with custom sleep loop, watch failed in `--hostdisplay` (xinitrc) setups
 - `--exe`: only forward stdin if not empty
 - finish(): use pkill in most cases instead of kill to avoid kill success messages
 - **bugfix** `--weston`/`--kwin`: wait for file creation of wayland socket, checking logfile is not enough
 - mywatch(): verbose output

## Version: [3.9.2.2](https://github.com/mviereck/x11docker/tree/699cdd4d4eb40846619233ef65edefe74e1246d0)
#### Date: 2018-02-09
 - **bugfix** `--exe`: avoid possible hostexe options with basename for $Hostexebasename
 - **bugfix**: typo checking `/tmp/.Xn-lock`
 - check free display and cache folder with find only
 - **bugfix** checking free display number: race condition if starting two x11docker instances at same time, second one failed because display number already in use
 - plasmashell added to possible window managers

## Version: [3.9.2.1](https://github.com/mviereck/x11docker/tree/3c28c1b61596fbc8a7e2b3ea0bbbe75dbc320fc4)
#### Date: 2018-01-29
 - correct date/year in changelog (issue [#21](https://github.com/mviereck/x11docker/issues/21))
 - **bugfix** finish(): wrong warning although terminating bgpid was successfull
 - create /x11docker/environment to store and provide container environment variables

## Version: [3.9.2](https://github.com/mviereck/x11docker/tree/64556a1096470761e66f15c21b5054a6cba7a734)
#### Date: 2018-01-21
 - **bugfix**: add groups video and audio if su is not used in container. /etc/group changes by dockerrc seem to be not regarded in that case.
 - finish(): more precise check with pid and name before killing background pids

## Version: [3.9.1.9](https://github.com/mviereck/x11docker/tree/f789a74ceab2f547b3d2939a5e23f21b32c0cd7c)
#### Date: 2018-01-17
 - `--xpra`: if server crashes, use xpra option `--mmap=no` on restart

## Version: [3.9.1.8](https://github.com/mviereck/x11docker/tree/363351c54eeaad227c942bbe3eeb035085930580)
#### Date: 2018-01-16
 - `--xpra`: stop x11docker if xpra server crashes multiple times

## Version: [3.9.1.7](https://github.com/mviereck/x11docker/tree/3b20fd795ac133b36702ed516e2e4efb1669f7d4)
#### Date: 2018-01-15
 - `--gpu`: share /dev/vga_arbiter and /dev/nvidia*

## Version: [3.9.1.6](https://github.com/mviereck/x11docker/tree/f4797498300a30aad91985ca08269eb475826984)
#### Date: 2018-01-15
 - restart xpra server if it crashes (can happen with xpra 2.2, reason unknown)

## Version: [3.9.1.5](https://github.com/mviereck/x11docker/tree/c2b217885e424e889d206018b584ca4e4caaf837)
#### Date: 2018-01-13
 - **bugfix** xpra: reconnect to server after timeout (60s) if switching to console

## Version: [3.9.1.4](https://github.com/mviereck/x11docker/tree/7a4c0093bb643a3de00ab81f177b24597cc60a64)
#### Date: 2018-01-12
 - `--help`: some usage updates
 - `--xorg`: create virtual framebuffer if no monitor is connected (headless server setup)
 - `--xpra`: note that 2.1.x series is more stable than 2.2.x series
 - create `$Cacherootfolder/Xenv.latest` with latest X environment variables for easier custom access
 - `--verbose --systemd`: hide error messages: `Failed to add fd to store | Failed to set invocation ID | Failed to reset devices.list`
 - `--systemd`: set global environment XAUTHORITY

## Version: [3.9.1.3](https://github.com/mviereck/x11docker/tree/4c82febbcf6d7a568bbb117c93047c3dd666fc9d)
#### Date: 2018-01-04
 - `--dbus-daemon`: set xhost +SI:localuser:$USER, needed for deepin
 - **bugfix** `--systemd`: global XAUTHORITY setting was wrong, removed at all
 - faster startup of pulseaudio, no sleep 1
 - **bugfix**: pull terminal did not appear if running from terminal
 - create fake homedir and softlinks to sharedirs in CMD.sh, base is /fakehome now
 - extension XTEST: more restrictive defaults

## Version: [3.9.1.2](https://github.com/mviereck/x11docker/tree/a88992416fedc2c0b3f57def7ecd8f8e00e78bff)
#### Date: 2017-12-28
 - `--sudouser`: root gets password `x11docker`, too
 - check environment variables in image and set them in x11docker.CMD.sh. Allows PATH of x11docker/trinity again.
 - **bugfix** parsing host XAUTHORITY if running from gksu
 - cut image command at `#`

## Version: [3.9.1.1](https://github.com/mviereck/x11docker/tree/31f36368883ee456f4fa48c5edf0fa062b030a51)
#### Date: 2017-12-28
 - **bugfix** `--systemd`: directly share X socket as systemd can have issues with soft links

## Version: [3.9.1](https://github.com/mviereck/x11docker/tree/038bf252c699b438011260ec0dc61d4192f4b5e4)
#### Date: 2017-12-25
 - run in detached mode, drop mess of nohup/setsid/script
 - `--dbusdaemon`: dropped consolekit, not really useful
 - `--dbusdaemon`: switch only for  `--tini`/`--none`. Always run daemon for `--systemd` `--openrc` `--runit`
 - `--systemd`: create /sys/fs/cgroup/systemd if missing on host
 - `--sys-admin`: deprecated thanks to `--tmpfs=`/run/lock
 - containersetup.sh collects most former `docker exec` commands from dockerrc

## Version: [3.9.0.5](https://github.com/mviereck/x11docker/tree/a264d9b778c0c9dcf76dc5be1e2f362c120acf4f)
#### Date: 2017-12-21
 - add capability DAC_OVERRIDE if user switching is allowed -> needed to change /etc/sudoers if ro
 - **bugfix**: only create XDG_RUNTIME_DIR if not already existing
 - `--systemd`: adding `--tmpfs=`/run/lock allows to drop `--sys-admin` !

## Version: [3.9.0.4](https://github.com/mviereck/x11docker/tree/c1b307a7f3981cf0b63aebfd2672baa319afa0ab)
#### Date: 2017-12-20
 - docker run `--workdir=`/tmp, avoids issues with WORKDIR in image (seen with lirios/unstable)
 - **bugfix** `--dbus`: check for dbus-launch in x11docker.CMD.sh, not in dockerrc on host
 - changes to satisfy lirios:
 - add docker run -ti
 - run docker command with script -c to provide fake tty
 - change /tmp/fakehome to /home/fakehome

## Version: [3.9.0.3](https://github.com/mviereck/x11docker/tree/)
#### Date: 2017-12-17
 - switched back to /tmp/fakehome to avoid CHOWN and issues with `--sharedir`
 - drop `--cap-add` CHOWN
 - **bugfix** `--sudouser`, failed to start
 - `--sharedir`: without `--home`[dir], create softlinks to /tmp/fakehome
 - `--home`: avoid conflict with `--sharedir=`$HOME, mount as $HOME/$(basename $HOME)
 - only chown $Benutzerhome if `--home`[dir] is not used. Change non-writeable error in warning only
 - `--hostdisplay`: warning if host has no own cookie
 - avoid grey edge with Xwayland, Xaxis must be dividable by 8

## Version: [3.9.0.2](https://github.com/mviereck/x11docker/tree/55923adf38ae3a5bb13373419e8e7473ab4e88eb)
#### Date: 2017-12-16
 - /etc/sudoers[.d/]: replace completly to avoid possible evil image setups
 - `--cap-add` CHOWN as default to allow /home/$Benutzer with `--sharedir`

## Version: [3.9.0.1](https://github.com/mviereck/x11docker/tree/f95bdb31a51255c8fb8515d6d2d03542383a7301)
#### Date: 2017-12-16
 - **bugfix**: `--systemd`: do not set $HOME globally, root may write into it
 - use /home/$Benutzer instead of /tmp/fakehome

## Version: [3.9.0](https://github.com/mviereck/x11docker/tree/f4459cac35165c9e2dec964204505f440c9ea297)
#### Date: 2017-12-15
 - /etc/shadow: disable possible root password
 - **new option** `--dbusdaemon` to run dbus system daemon and consolekit in container
 - re-checked capabilities for init systems
 - `--systemd`: set environment globally, especially DISPLAY for deepin is needed
 - `--systemd`: set xhost+SI:localuser:$Benutzer as XAUTHORITY seems to be ignored
 - /tmp/.ICE-unix created in dockerrc, root owned with 1777, needed for SESSION_MANAGER
 - **deprecated**: `--rw`, root file system is always r/w now due to `docker exec` in dockerrc
 - **bugfix** Ubuntu: avoid Wayland backend for Weston due to MIR issue [#19](https://github.com/mviereck/x11docker/issues/19)
 - `--xorg`: change Xorg to X. X is setuid wrapper for Xorg on Ubuntu 14.04
 - `--xorg`: +iglx removed from X options, not present in older versions of X, and maybe security issue.
 - create user in dockerrc with `docker exec` instead of using createuser.sh
 - **new option** `--openrc` for init system OpenRC in container
 - **new option** `--sharecgroup` to share /sys/fs/cgroup. default for `--systemd`.
 - create /var/lib/dbus in dockerrc to avoid dbus errors with init systems
 - show image name and display in weston windows
 - **bugfix** `--runit`: add SYS_BOOT even with `--cap-default`

## Version: [3.8.0](https://github.com/mviereck/x11docker/tree/a9e15fc63b6ffbdad2ff0db35bdea1a5b26df336)
#### Date: 2017-12-04
 - `--sudouser`: create user with docker run options instead of createuser script
 - `--sudouser`: create /etc/sudoers.d/$Benutzer with docker exec in dockerrc
 - `--sudouser`: create /etc/sudoers.d/$Benutzer instead of adding groups wheel and sudo
 - createuser.sh: check for useradd, if missing use adduser (fits fedora and alpine/busybox as well)
 - **new option** `--runit` for init system runit
 - **new option** `--init` for init system tini (default now, docker run option `--init`)
 - **new option** `--no-init` to run image command as PID 1 (has been default before x11docker 3.8)
 - **new option** `--sys-admin` for `--cap-add=`SYS_ADMIN. Needed for systemd in debian based images.
 - `--sudouser`, `--systemd`: set needed capabilities only instead of `--cap-default`
 - `--xpra` `--hostuser`: create /run/user/$Hostuseruid if missing
 - $Sharefolder/stdout+sterr: chmod 666 to allow access with `--user`
 - container user password: x11docker (creating volume /etc/shadow)
 - init system tini as default with `docker run --init`
 - `--systemd`: unprivileged systemd in container
 - `--exe` and `--xonly`: regard `--home` and `--homedir`, `--user` and `--hostuser`
 - **new option** `--wayland` to auto-setup Wayland environment
 - -W is now `--wayland` instead of `--weston`, -T for `--weston` now
 - check pids before calling mywatch()
 - **bugfix**: `--hostdisplay` `--gpu` needs trusted cookies
 - colored logfile output
 - **bugfix** in createuser.sh: adduser failed with fedora based images, use useradd and usermod instead
 - **bugfix**: `--pw=gksu`: avoid wrong docker startup error message, use nohup in dockerrc
 - `--verbose`: green colored output for logfile titles and verbose() lines
 - set env DISPLAY XAUTHORITY and WAYLAND_DISPLAY in x1docker.CMD.sh as systemd eats them otherwise
 - **new option** f`--systemd` to run systemd as PID1 in container and image command as a service
 - use docker run option `--tmpfs` for /tmp, /var/tmp and /run instead of `--volume=`/tmp
 - `--sudouser`: instead of empty password, user name is password now
 - changed container share folder /tmp/x11docker to /x11docker to avoid issues with `--tmpfs` /tmp

## Version: [3.7.2](https://github.com/mviereck/x11docker/tree/e062b07b91b87a1b9b26d10e41d0d7dd1c3b6299)
#### Date: 2017-11-11
 - allow rw with `--volume=`/var/tmp, needed for trinity
 - **bugfix** for su on console: exec </dev/tty
 - `--nxagent`: removed xhost startup workaround
 - $Hostxenv: removed custom environment
 - `--nxagent`: shift+F11 toggles fullscreen
 - `--nxagent` on Mageia: only show warning about seamless mode instead of disabling it

## Version: [3.7.1](https://github.com/mviereck/x11docker/tree/d3c841246548e9667909cc25ffad5396b0ebfde2)
#### Date: 2017-11-03
 - **bugfix** for gksudo and lxsudo
 - read host cookie with xauth if XAUTHORITY is empty, can happen with xdm
 - `--nxagent` on Mageia: no seamless mode
 - Ubuntu 16.04: **bugfix** for `--xpra` (must not set `--webcam=no`)
 - replaced while/sleep loops with watch
 - **bugfix** for weston and kwin on konsole, terminal for password prompt failed
 - alertbox(): regard $DISPLAY, use $Anyterminal otherwise to support Wayland
 - weston.ini: keyboard config setting on console
 - fedora: show alert for `--ipc`/`--trusted` due to missing extension security

## Version: [3.7.0](https://github.com/mviereck/x11docker/tree/d06c59495775bfbb0bc79dea3ace02dbfb2293c9)
#### Date: 2017-10-30
 - **new option** `--alsa`; use -wm for `--xephyr` and the likes; support more terminals and message dialogs

## Version: [3.7.0](https://github.com/mviereck/x11docker/tree/d06c59495775bfbb0bc79dea3ace02dbfb2293c9)
#### Date: 2017-10-30
 - auto-choose window manager in `--xephyr`/`--xorg`/`--weston-xwayland`/`--kwin-xwayland`/`--xwayland` except `--desktop` is set
 - **new option** `--alsa` for ALSA sound
 - changed content of variable $Xserver to X server option names itself
 - `--kwin-xwayland`: set keyboard layout
 - **deprecated**`--kwin-native`, too much trouble, but less use
 - extended terminal list for password prompt/docker pull
 - `--xhost`: always disabling with no_xhost(), afterwards setting `--xhost`
 - **bugfix** `--weston`/`--weston-xwayland`: set backend in compositor command, weston's autodetection can fail
 - **bugfix** `--kwin`/`--kwin-xwayland`: set backend in compositor command, weston's autodetection can fail
 - new function alertbox, outsourced from error(). yad, kaptain, kdialog, gxmessage, xterm: additional messagebox tools

## Version: [3.6.3.9](https://github.com/mviereck/x11docker/tree/1f4353964dba1d01289a5379a1b4d0bf10c666f1)
#### Date: 2017-10-25
 - show error messages regardless of `--silent`
 - change `sudo` to `sudo -E`, needed for OpenSUSE
 - code cleanup, some improved messages

## Version: [3.6.3.8](https://github.com/mviereck/x11docker/tree/2e027c2b9bab8af2244fe65218276f0ad7a84736)
#### Date: 2017-10-25
 - fedora: set `--ipc` and `--trusted` for `--hostdisplay` only

## Version: [3.6.3.7](https://github.com/mviereck/x11docker/tree/6034608f9d49c138d3f58b647257114b9c66052e)
#### Date: 2017-10-25
 - **bugfix** `--hostdisplay` on fedora: use host cookie, custom cookie is rejected

## Version: [3.6.3.6](https://github.com/mviereck/x11docker/tree/84881c51788eecc754f36288fbb8699c5dbc327f)
#### Date: 2017-10-24
 - **new option** `--wmlist` to retrieve list of window managers, used by x11docker-gui
 - `--gpu`: improved support in autochoosing mode
 - disabled note of xpra keyboard shortcuts, takes too long
 - hardcoded xpra environment variables, parsing `xpra showconfig` takes too long
 - **bugfix** for `--pw=sudo`, issue with setsid

## Version: [3.6.3.5](https://github.com/mviereck/x11docker/tree/12bb570b2c03157d4062391288f770e520307c0f)
#### Date: 2017-10-24
 - **bugfix** xpra with host user root: set environment variables
 - dbus-launch for konsole and terminator, needed in dockerrc

## Version: [3.6.3.4](https://github.com/mviereck/x11docker/tree/836d4f50e44cccc587819f002faa8d18e62ecbb3)
#### Date: 2017-10-23
 - add /usr/sbin to PATH, needed on mageia for ip
 - **bugfix** `--pw=sudo`: `setsid sudo` fails, must use `sudo setsid`

## Version: [3.6.3.3](https://github.com/mviereck/x11docker/tree/4256438ff948dd97a0887410e866121736a1893b)
#### Date: 2017-10-23
 - removed experimental Code
 - **bugfix** for `--wm` as root in xinitrc

## Version: [3.6.3.2](https://github.com/mviereck/x11docker/tree/58ea47a22270ad0a7f81196cb8c69bf300e87dff)
#### Date: 2017-10-23
 - remove debugging `set -x` in xinitrc

## Version: [3.6.3.1](https://github.com/mviereck/x11docker/tree/ed80f32c115066203b88b9681655c30bc2c42f13)
#### Date: 2017-10-23
 - **bugfix**: don't use su $USER in xinitrc
 - split X server command with \backslash in multiple lines

## Version: [3.6.3](https://github.com/mviereck/x11docker/tree/63410b85f617b3449c48212dda9d0e74ec6327bf)
#### Date: 2017-10-20
 - **new option** `--no-internet`; adjustments for CentOS/RHEL, Arch and Manjaro

## Version: [3.6.2](https://github.com/mviereck/x11docker/tree/)
#### Date: 2017-10-10
 - **new option** `--xfishtank`; better SELinux support; `--scale` and `--size` for `--xorg`

## Version: [3.6.1](https://github.com/mviereck/x11docker/tree/)
#### Date: 2017-08-15
 - **new option**s `--stdout` and `--stderr`; support stdin

## Version: [3.6.0](https://github.com/mviereck/x11docker/tree/)
#### Date: 2017-08-12
 - workaround: disabling SELinux for container until solution for sharing unix socket is found.
 - compare: http://www.projectatomic.io/blog/2015/06/using-volumes-with-docker-can-cause-problems-with-selinux/
 - install to /usr/bin instead of /usr/local/bin to support root
 - chmod 755 instead of +x in installation
 - check if docker is installed
 - check if docker daemon is running (with ifconfig)
 - use zenity or notify-send if xmessage is not available in error()
 - **bugfix**: cookie creation failed on X without extension security. (fedora)
 - replaced sed in xauth cookie creation, sed fails in openSUSE (!?)
 - **new option** `--rw` to allow read/write access to container root file system
 - check for xpra `--dpi` bug in 2.1 series
 - xpra `--start-via-proxy=no` for xpra >= 2.1
 - `--nxagent`: temporary xhost +SI:localuser:$Hostuser workaround as it fails again to authenticate, not dividing between `XAUTHORITY` and `--auth`
 - **new option** `--pw` to choose password prompt frontend. default: pkexec
 - reduce dependency warnings for `--auto`
 - **bugfix**: repeating error message if waitforlogentry() failes
 - prefer $Hostenv instead of $Newxenv for password prompt -> better support for gksu
 - show docker pull in a terminal window
 - allow `--hostdisplay` with `--xonly`. May at least be usefull to create an untrusted cookie.
 - **bugfixes** in "check window manager"
 - slit docker startup from xinitrc
 - copy host cookie into $Cachefolder for compatibility with gksu
 - use gksu/gksudo if available
 - `--showenv` for `--xonly`
 - finish(): docker stop $Containername
 - dockerrc: no ps/sleep loop if running as root
 - **new option** `--no-entrypoint` to disable ENTRYPOINT in image
 - `--root`: **deprecated**. Can be achieved with `--hostuser=root`
 - **new option** `--hostuser` to set host user different from  $(logname)
 - check if docker can run without password to make `--no-password` needless
 - don't start docker in xinitrc as xinit runs unprivileged
 - `--ps` keeps cache files, too (formerly container only)
 - `--desktop`: no longer **deprecated**, easier to understand and remember than `--wm=none`
 - -d: used for `--desktop` again, no longer for `--dbus`. `--dbus` now has short opt -b
 - improved X server check due to new variable $Desktopmode
 - **bugfix**: &, &&, ;, <, >, | and the like possible in image command again
 - `--fullscreen`. Set fullscreen screen size for windowed options (xpra),too
 - allow root to start x11docker, use $(logname) for X server and as container user

## Version: [3.5.11](https://github.com/mviereck/x11docker/tree/)
#### Date: 2017-07-12
 - pull image if not available before calling `docker run`

## Version: [3.5.10](https://github.com/mviereck/x11docker/tree/dbd85cfc9f26948ddf8e27075923ff673dc5a89b)
#### Date: 2017-07-12
 - regard `ENTRYPOINT` in dockerrc

## Version: [3.5.9](https://github.com/mviereck/x11docker/tree/623c20b427b50fc16c127c760688cfbb556c0b8b)
#### Date: 2017-07-09
 - `--user`: **bugfix** parsing custom gid, gid was set to username
 - `--home` with `--user=`(unknown): only show warning (instead of error) not creating persistent home
 - do not set write permissions on `--home` or `--homedir` folder for different users than $USER or `--user`. (Not x11docker's job)
 - do not set `--read-only` if `--user=`0
 - minor **bugfix**: chown x11docker_CMD to host user to avoid permission issues in $Sharefolder

## Version: [3.5.8](https://github.com/mviereck/x11docker/tree/fc88928119202eef80d6e3eba788fcd367dbc629)
#### Date: 2017-06-07
 - `--nxagent`: **bugfix** due to update? must set nxagent -ac (=xhost +) temporary to allow xinit
 - `--kwin-native`: always share Wayland (`--sharewayland` `--waylandenv` `--dbus`)
 - minor **bugfix**: allow `--wm` for `--kwin-xwayland`
 - docker run "`--read-only` `--volume=`/tmp" to restrict container filesystem as read-only (except for `--sudouser`)
 - `--xorg` supports `--rotate`. (Xephyr could, but crashes -> Xephyr bug. Nxagent, Xdummy, Xvfb and Xwayland refuse this.)
 - **new option**` --xhost` STR: to specify "xhost STR". Deprecated: `--xhost`+
 - **new option** `--xvfb` to explicitly use Xvfb and to clearly use Xdummy on `--xdummy`
 - Xdummy script in $Cachefolder forked from https://xpra.org/trac/browser/xpra/trunk/src/scripts/xpra_Xdummy
 - calculate VideoRam in xorg.xdummy.conf (instead of fat hardcoded 256000 kb)

## Version: [3.5.7](https://github.com/mviereck/x11docker/tree/6d8a4cd471f31e7053a10390ab2ca3f90ae80239)
#### Date: 2017-06-28
 - usage info for HTML5 web application setup
 - redirect verbose output to &3 to show it in subshells, too, and to avoid possible collision with read < <()
 - `--env`: set custom environment variables in dockerrc instead of in docker run
 - removed `unix` in $Newxenv for DISPLAY to make xpra ssh setup easier
 - Xdummy-Xwayland: new X server to provide `--gpu` for `--xdummy` based on weston, xwayland and xdotool
 - always enable extension Xtest on `--xdummy` to allow xpra access
 - share X socket to /tmp, create .X11-unix in dockerrc and softlink socket. This avoids writeable X11-unix in $Cachedir.
 - `--setwaylandenv`: env now set in dockerrc instead of docker command

## Version: [3.5.6](https://github.com/mviereck/x11docker/tree/1f6496421f958d5ebf4fcf9abbe6e5d51d19f212)
#### Date: 2017-06-21
 - `--sudouser`: reincarnated option to give sudo without password to container user.
 - docker command one-liner extended to dockerrc. dockerrc creates x11docker_CMD. Can always extract image command without additional password prompt and create some environment.
 - **bugfix** parsing option `--wm`
 - **bugfix**: export $Hostxenv in error() was empty if called in xtermrc
 - create `/tmp/XDG_RUNTIME_DIR` and softlink to wayland socket in container due to some KDE issues (`XDG_RUNTIME_DIR` must be owned by user). Fails with different `--user`
 - create `/tmp/.X11-unix` with 1777 in container to allow new X sockets (especially for startplasmacompositor). Drawback: container writeable folder in cache
 - **bugfix**: avoid pointless warning about `XTEST` if not using xpra
 - shorter sleep in finish()
 - don't search for deprecated `/tmp/x11docker` in checkorphaned()
 - **bugfix** typo preventing start of `--kwin` and `--kwin-native` (-width instead of `--width`)
 - warning with hint to use `--xpra-xwayland` if `--scale` is used with `--weston-xwayland`.

## Version: [3.5.5.2](https://github.com/mviereck/x11docker/tree/547aea540aed165fc22def77724caccbd6424c63)
#### Date: 2017-06-10
 - update usage info for `--xpra` and `--xpra-xwayland`

## Version: [3.5.5.1](https://github.com/mviereck/x11docker/tree/1867023c5913a09ed63f98c3d28e9b19f1b332b2)
#### Date: 2017-06-10
 - **bugfix** in `--auto` always choosing `--xorg`

## Version: [3.5.5](https://github.com/mviereck/x11docker/tree/e6021187f59caef2a49b36e02417ec79591c7f1d)
#### Date: 2017-06-09
 - autochoose xpra-desktop if xephyr is missing
 - improved part: check virtual screen size
 - changed dpi calculation depending on xpra mode
 - desktop mode for xpra if `--wm` is given
 - always set `XDG_RUNTIME_DIR=/tmp` as some apps may expect it

## Version: [3.5.4](https://github.com/mviereck/x11docker/tree/c09d6f3022ddf2c0ab6862e0f3db6ab6e9fa9c53)
#### Date: 2017-06-02
 - set rw access for `/dev/dri` ([#12](https://github.com/mviereck/x11docker/issues/12))
 - disable extension `XTEST` if using wm from host (to avoid abuse of context menu of openbox and the like)

## Version: [3.5.3](https://github.com/mviereck/x11docker/tree/870a63b67480caedb7645011666a325dbdbb8ce7)
#### Date: 2017-05-29
 - `--pulseaudio`: get and use IP of container instead of docker0 IP range ([#11](https://github.com/mviereck/x11docker/issues/11)), disabling TCP module on exit
 - changed `--volume` to `--sharedir` to avoid confusion
 - update `usage()`
 - mount $Sharefolder and its content read-only
 - remove X11-unix from $Sharefolder
 - set read-only for /dev/dri on `--gpu`
 - `--security-opt=no-new-privileges` added to docker run

## Version: [3.5.2](https://github.com/mviereck/x11docker/tree/d88d32605ece42324f14cf41e54482888ae539c4)
#### Date: 2017-05-22
 - **new option** `--volume` to share host folders

## Version: [3.5.1](https://github.com/mviereck/x11docker/tree/4f1e4d14a904d499445fd479efb37b3c7cd46451)
#### Date: 2017-05-19
 - user creation with `--addgroup video` to support pre-systemd and kdeneon gpu support
 - create `/tmp/.X11-unix` with `1777`

## Version: [3.5.0](https://github.com/mviereck/x11docker/tree/2f354525b3443250c3fe4c18ebfe4a3fc57f5ca0)
#### Date: 2017-05-17
 - avoid Terminal window with `--no-password`
 - `--env`: regard whitespaces, use \n to divide entrys
 - set mode=preferred for Weston on tty, ignore $Screensize
 - extension XINERAMA disabled as multiple Xephyr outputs cannot handle it well
 - create container home folder /tmp/fakehome in x11docker_CMD (avoids ownership problems with wine, and is less messy in /tmp)
 - more failure checks in installer()
 - check for `--userns-remap`, disabling it with `--userns=host` if `--home` or `--homedir` are set
 - minor exploit check for DISPLAY XAUTHORITY XDG_RUNTIME_DIR WAYLAND_DISPLAY HOME
 - **new option** `--output-count` to set amount if virtual screens/desktop windows for Weston, Kwin, Xephyr
 - **new option** `--westonini` to specify a custom weston.ini for `--weston` and `--weston-xwayland`
 - **bugfix**: -s KILL for weston on finish avoids zombies
 - **new option** `--cachedir`:  specify custom cache folder
 - **new option** `--homedir`: specify host folder to share as home
 - automatically choose trusted or untrusted cookies
 - **new option** `--trusted`: enforce trusted cookies for `--hostdisplay` and `--kwin-native`
 -  **deprecated** `--cache`
 - `--cap-default`: Allow docker default capabilities
 - `--orphaned` cleans /tmp/x11docker
 - show docker log in xtermrc if pulling image
 - `docker run `--cap-drop=`ALL` as default
 - **new option**`--user` to set user to use (name or uid, non-existing uids possible. default: host user)
 - reduce /etc/passwd and /etc/group to container user and groups user and videp only (except root, keeps whole files).
 - creating container user similar to host user with docker run option `--user` and custom /etc/passwd instead of script createuser.
 - **removed** `--hostuser` `--sudouser`, effect of `--hostuser` is default now, `--sudouser` not possible due to `--cap-drop=`ALL
 - `--gpu`: only share `--device=`/dev/dri instead of listing all files in it

## Version: [3.2.1](https://github.com/mviereck/x11docker/tree/7600e599e757398d2e7ca3f53d4567f9286e31bb)
#### Date: 2017-05-05
 - minor **bugfix**: `--scale` with `--xpra-xwayland` under X without Wayland failed

## Version: [3.2.0](https://github.com/mviereck/x11docker/tree/32a9b75e0a7e6511b85dd2e01353adc77b76bfb9)
#### Date: 2017-05-04
 - **new option** `--scale`: for xpra and weston
 - **new option** `--rotate` for weston
 - **new option** `--dpi` for screen density
 - **bugfix**: checking screensize in Gnome-Wayland failed looking for primary display, window was not roughly maximized
 - **bugfix**: missing error() in xinitrc
 - allow MIT-SHM for `--exe`

## Version: [3.1.16](https://github.com/mviereck/x11docker/tree/bab08db10c8b4d360c58ec7c7bb42a6fa6567b69)
#### Date: 2017-05-03
 - **bugfix** `--xpra-wayland` in check for `WAYLAND_DISPLAY`

## Version: [3.1.15](https://github.com/mviereck/x11docker/tree/58536075aec99859ad212f7377724a5b60cb3dd6)
#### Date: 2017-05-02
 - **bugfix** in choosing terminal, replace $Waylandterminal with $Terminal in re-check
 - **bugfix** xtermrc and xinitrc: check if $Dockerpidfile is not empty
 - faster startup for `--xpra-xwayland`, `--weston-xwayland`, `--kwin` and `--kwin-xwayland`
 - code cleanup

## Version: [3.1.14](https://github.com/mviereck/x11docker/tree/af37faddec2642e44a0c586ac9c84694c9989fad)
#### Date: 2017-05-01
 - checkorphaned() uses container names instead of numbers
 - **bugfix** `--exe`: reliable kill $Hostexe, even with `--weston`* and `--kwin`*
 - **bugfix**: remove : and / from image name in $Containername

## Version: [3.1.13](https://github.com/mviereck/x11docker/tree/e8e428edbb259d1d317a52fb43ee7be25e5b2cf7)
#### Date: 2017-04-30
 - Improved multimonitor support (still missing: multihead)
 - **bugfix**: redirection of stderr wihout cat, avoids broken pipe on ctrl-c in ubuntu and opensuse
 - **bugfix**: removed custom socket in xpra (failed in opensuse)
 - removed $Cidfile at all, cleanup hint in finish() with $Containername
 - avoid root ownership for $Dockerlogfile and $Dockerpidfile

## Version: [3.1.12](https://github.com/mviereck/x11docker/tree/06fc8fc7f4bf2945692c8b38476e76b760bd8877)
#### Date: 2017-04-29
 - clean up confusion with x11docker.log
 - **bugfix**: include warning() in xinitrc
 - **bugfix** in xinitrc for `--no-xhost`
 - don't share $Xclientcookie as $Sharefolder is already shared
 - don't use $Cacherootfolder for parsererror
 - hint to use `--sudo` on some systems
 - use id -g instead of $Benutzer for group name
 - add lsb-release -ds to verbose output

## Version: [3.1.11](https://github.com/mviereck/x11docker/tree/0248fd878cdb1b1cacd42758f883ea4dc75d0c27)
#### Date: 2017-04-29
 - disabled $Cidfile as not important and due to [#10](https://github.com/mviereck/x11docker/issues/10)

## Version: [3.1.10](https://github.com/mviereck/x11docker/tree/969494282073ef5098820325472ac02872c7c5f6)
#### Date: 2017-04-28
 - **bugfix**: check for xenial instead of 16.04/xvfb
 - **regression** fix: set XPRA_XSHM=0 on Shareipc=no
 - disable `--desktop-scaling` in xpra, not supported before xpra v1.x

## Version: [3.1.9](https://github.com/mviereck/x11docker/tree/c1eb6a60fab62bc7a10cb97020e36bf9bdb8a8ed)
#### Date: 2017-04-27
 - don't create Cacherootfolder in variable definitions
 - check for Xvfb on Ubuntu 16.04

## Version: [3.1.8](https://github.com/mviereck/x11docker/tree/3f4a54c01d340293a8c831b0a0757c2a97326aa2)
#### Date: 2017-04-25
 - Add advice for `--xorg` how to setup xserver-xorg-legacy

## Version: [3.1.7](https://github.com/mviereck/x11docker/tree/85bb3e72ae449b2057f93390a2bbfdb86a89286a)
#### Date: 2017-04-25
 - `--xpra` and `--xdummy` now use Xvfb if installed. Compare #9, Xdummy cannot be used on Ubuntu 16.04 due to xorg.conf location
 - set $Windowmanager in auto choosing X server if switching to desktop windows

## Version: [3.1.6](https://github.com/mviereck/x11docker/tree/2623286e141ddb4aec6a7b5162cafbb19b5c6e6c)
#### Date: 2017-04-21
 - **bugfix** 2 `--nxagent`: don't close nxagent on every call of nxclient

## Version: [3.1.5](https://github.com/mviereck/x11docker/tree/a13bd270d1146ad6fedcfbb1c2ccf1583531e0d5)
#### Date: 2017-04-20
 - **bugfix** `--nxagent`: don't close nxagent on every call of nxclient

## Version: [3.1.4](https://github.com/mviereck/x11docker/tree/b2641dbd874e8df51762a31c6a6d2e5344bd9efa)
#### Date: 2017-04-19
 - `--nxagent` supports untrusted cookies
 - **bugfix**: don't set dpi if xdpyinfo fails

## Version: [3.1.3](https://github.com/mviereck/x11docker/tree/06e021a0dae63eef02661420942b8430f7dcca42)
#### Date: 2017-04-18
 - `--nxagent` cookie workaround as it ignores XAUTHORITY on option -auth
 - `--nxagent` workaround to terminate on pressing window close button -> fake nxclient
 - **bugfix** typo in finish() looking for docker pid

## Version: [3.1.2](https://github.com/mviereck/x11docker/tree/289017045514d966a5f378b4649fbd2606a03c9a)
#### Date: 2017-04-18
 - `--nxagent` sets right keyboard layout, thanks to Ulrich!

## Version: [3.1.1](https://github.com/mviereck/x11docker/tree/dbb3c60d525c372906e5f75fb464f8cd0f466a87)
#### Date: 2017-04-18
 - `--nxagent` now supports `--size`, `--fullscreen` and `--clipboard`, thanks to Ulrich Sibiller from Arctica!
 - check dpi from host and set this to new X server
 - xpra xmessage to be patient
 - disabled keyboard adjusting for `--nxagent`

## Version: [3.1.0](https://github.com/mviereck/x11docker/tree/60b704f068fe99e64b873c8fe4fc0ae6da35ab87)
#### Date: 2017-04-16
 - **new option** `--nxagent` for X server `nxagent`

## Version: [3.0.0](https://github.com/mviereck/x11docker/tree/a62b2f47472ab60b98d2a2471135e0e33fa46757)
#### Date: 2017-04-15
 - Wayland support.
 - code cleanup
 - second stderr &3 to show warnings and errors also from within xinitrc and xtermrc
 - error messages on docker startup failure in xtermrc
 - `--xhost` changed to `--xhost`+, affects new X server only
 - `--kwin` und `--kwin-wayland`: new X server / wayland options
 - `xdummy.conf` or `--xpra`: custom modeline setting fittung to actual resolution
 - `--xdummy` regards `--size`
 - x11docker_CMD checks if ps is available
 - `--wm` changed, autochoosing no longer default
 - old `--env` now is called `--showenv`
 - **new option** `--env`: set custom envionment variables
 - **new option**`--dbus`: run image command with `dbus-launch`
 - `chmod 1777 /tmp/X11-unix` to allow creation of X sockets in container
 - `--verbose` output much more reliebalenow, tail improved
 - use prefix unix for `DISPLAY` to disable `MIT_SHM` instead using other environment variables
 - **removed** `--virtualgl`, `--dockerenv`, `--xpra-image`, `--xorg-image`, `--xdummy-image`, `--tcp` `--tcpxsocket` `--xsocket`, `--glamor`, `--sharegpu`, `--desktop`
 - **new option**s `--weston`, `--wayland`: for pure Wayland applications
 - `--xpra-xwayland`: new X server option
 - create dektop starter with basename instead of $0
 - createuser: start with `--user=`0 to allow useradd and su
 - **new option**`--setwaylandenv`: setting environment variables for toolkits like QT and GTK to use wayland
 - `--nothing`: Provide no X or Wayland server
 - `--sharewayland`: Share host wayland socket and set WAYLAND_DISPLAY
 - reverse order of killing of bgpids in finish(),last one first, to catch possible further output with tail -F
 - Newdisplaynumber for xorg starts with 8, Newxvt not added 7
 - xinitrc: `XPRA_OPENGL_DOUBLE_BUFFERED=1` to avoid xpra bug 1469
 - check and set `XDG_RUNTIME_DIR` for weston and Xwayland
 - `--weston-xwayland` and `--xwayland`: new X server options
