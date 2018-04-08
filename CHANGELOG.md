# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html) since version 4.0.0.

Project website: https://github.com/mviereck/x11docker

## [4.0.1](https://github.com/mviereck/x11docker/releases/tag/v4.0.1) - 2018-04-08
### Added
 - `--update-master` updates to lastest x11docker master version. (Formerly job of `--update`).
### Changed
 - `--update` updates to latest x11docker release on github. (Formerly: latest master version).

## [4.0.0](https://github.com/mviereck/x11docker/releases/tag/v4.0.0) - 2018-04-07
### Changed
 - Outsourced changelog from x11docker source code to `CHANGELOG.md`. [(#38)](https://github.com/mviereck/x11docker/issues/38)
 - Follow guidelines of [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).
 - Stricter compliance to [Semantic Versioning](https://semver.org/) rules.
### Notes
 - Previous version links in changelog lead to history tree leafs with corresponding `x11docker` script.
 - Upcoming version links in changelog will lead to corresponding [releases](https://github.com/mviereck/x11docker/releases).

## [3.9.9](https://github.com/mviereck/x11docker/blob/8abded01de9482ef70195550f936c9f07668b486/x11docker) - 2018-04-06
### Changed
 - Removed `--security-opt=no-new-privileges` for `--systemd`/`--sysvinit`/`--runit`/`--openrc`. (Undoes some changes from V3.9.8.1). Will be reintroduced after further checks, caused issues with `x11docker/deepin` and `x11docker/cinnamon`.
 - `--env`: set environment variables in `docker run`, too. Makes them available within `docker exec`.

## [3.9.8.5](https://github.com/mviereck/x11docker/blob/6227a1eebc5b63df305822896d7360a14440caf4/x11docker) - 2018-04-05
### Changed
 - `finish()`: run `docker stop` before creating `timetosaygoodbye` for more graceful shutdown [(#37)](https://github.com/mviereck/x11docker/issues/37)
### Fixed
 - Set correct `XAUTHORITY` in setup script
 - Disable `User` in systemd journal service, can fail in restricted setups

## [3.9.8.4](https://github.com/mviereck/x11docker/blob/d74fa2defceb538d8c9e90932d48f23cae0f102b/x11docker) - 2018-04-04
### Added
 - `--workdir` to set working directory different from `HOME`. ([#36](https://github.com/mviereck/x11docker/issues/36))
### Changed
 - `--systemd`/`--dbus-system`: changed `su` command to remove `sh` from pstree.
### Fixed
 - User group entry in `/etc/group` had wrong syntax.

## [3.9.8.3](https://github.com/mviereck/x11docker/blob/6ce5d2cbd7a14556723a3c8e1163988f2ddda8ce/x11docker) - 2018-04-04
### Fixed
 - `--dbus-system`: must not set `--security-opt=no-new-privileges`, important services like `polkitd` fail.

## [3.9.8.2](https://github.com/mviereck/x11docker/blob/a58e6808254ce78eb528010584ff9d7ef9b8aa26/x11docker) - 2018-04-03
### Changed
 - disable entrypoint `tini` if x11docker already runs an init system (default: `tini` from docker). ([#34](https://github.com/mviereck/x11docker/issues/34))

## [3.9.8.1](https://github.com/mviereck/x11docker/blob/75f79c9888beee08ca08c42c5f70feaa0f02cd30/x11docker) - 2018-04-03
### Changed
 - `--security-opt=no-new-privileges` now always set except for `--sudouser`. It does not harm switching from root to less privileged users. _(Note: is undone in v3.9.9)_
 - setup script with user switching: `exec su` instead of `su` to avoid root shell in parent tree. `su` is now immediate child of `init`.
### Added
 - show container ID on stdout ([#36](https://github.com/mviereck/x11docker/issues/36)). Can be catched e.g. with `read containerID < <(x11docker [...] )`.

## [3.9.8.0](https://github.com/mviereck/x11docker/blob/a4067993a91f39bce145b48406453f786d1707eb/x11docker) - 2018-04-02
### Changed
 - Removed `Xtermlogfile`, using `Dockerlogfile` instead. Strange: solved missing output with `--pw=su` or `--pw=sudo`, too.
### Fixed
 - Escape special characters in `--env`, `ENV` and image command. (adresses [#34](https://github.com/mviereck/x11docker/issues/34), too, now solved better). _(Note: still have to escape some other optional arguments)_

## [3.9.7.9](https://github.com/mviereck/x11docker/blob/7776de0f3128a679239037567626cca09f472ee5/x11docker) - 2018-03-31
### Changed
 - Store parsed parts of `Imagecommand` in `''` to allow constructs like:  `sh -c "cd /etc ; xterm"`
### Fixed
 - Added `--rm` to `docker run` of environment check. ([#34](https://github.com/mviereck/x11docker/issues/34))

## [3.9.7.8](https://github.com/mviereck/x11docker/blob/4d619bfbcae605b25ee93778936245019a8a7020/x11docker) - 2018-03-31
### Fixed
 - Handle equal signs in container environment defined with `ENV` ([#34](https://github.com/mviereck/x11docker/issues/34))

## [3.9.7.7](https://github.com/mviereck/x11docker/blob/733b8f9b9228d5fa3b167a4771976bcc610ac0de/x11docker) - 2018-03-31
### Fixed
 - Handle whitespaces in container environment defined with `ENV` ([#34](https://github.com/mviereck/x11docker/issues/34))

## [3.9.7.6](https://github.com/mviereck/x11docker/blob/65305faba992415b8b255a4fac7e89c4417e5a1e/x11docker) - 2018-03-30
### Changed
 - mount X socket and lockfile read-only to protect from `/tmp` cleanup of init systems
 - minor improvements of init system initialization
### Fixed
 - remove checks for `--userns-remap` and `--selinux-enabled`. [(#33)](https://github.com/mviereck/x11docker/issues/33)

## [3.9.7.5](https://github.com/mviereck/x11docker/blob/0f0b138db7c2f3093511fae7583b34bc44db3423/x11docker) - 2018-03-30
### Changed
 - `--dbus-system`: drop explicit consolekit support
 - `--sysvinit`,`--openrc`: disable getty in inittab instead of overwriting inittab with shared volume
 - `--sysvinit`: change `rc.local` in setupscript instead of overwriting it with shared volume
 - `--openrc`, `--runit`: create service in setupscript, drop some more capabilities

## [3.9.7.4](https://github.com/mviereck/x11docker/blob/85f1f29855090d2dba9328e9184f23365f4f1a6f/x11docker) - 2018-03-26
### Added
 - `--sysvinit` for init system SysVinit in container. Tested with devuan.
### Fixed
 - `--pulseaudio`: need to set environment variable `PULSE_SERVER`. (Was missing after switch from tcp to socket connection).
 - `--runit`: add softlink for X socket in `x11docker.CMD.sh` for compatibility with `runit` on debian.

## [3.9.7.3](https://github.com/mviereck/x11docker/blob/57e34236dca42e05434a304c77f61202d678398a/x11docker) - 2018-03-21
### Changed
 - `--pulseaudio`: share socket `XDG_RUNTIME_DIR/pulse` instead of connecting over tcp.

## [3.9.7.2](https://github.com/mviereck/x11docker/blob/25201b916159b2f77d6c6188ea875d80004733d1/x11docker) - 2018-03-20
### Added
 - `--add` to add a host command in `xinitrc`.
 - `--debug` to set `-x` in all scripts showing code lines while executed.
### Changed
 - `--wm`: fall back to autodetection if specified window manager not found.
 - `--dbus`: enable automatically for `--runit`, `--openrc`
 - consolekit: enable and use automatically for `--dbus-system`, `--openrc`, `--runit`
 - `mywatch()`: use `watch` again, now without `sh -c`
 - `--help`: `usage()` cleanup
### Deprecated
 - `--sharewayland`, `--waylandenv`: not needed for anything anymore. `--wayland` does the job.
### Fixed
 - `writeaccess()` handles user group names with spaces in it. [#30](https://github.com/mviereck/x11docker/issues/30)
 - `--env`: regard whitespace. Still need to handle special chars like "\'$.

## [3.9.7.1](https://github.com/mviereck/x11docker/blob/4aaa1cf3c9de7b5924a05cd1ace29e60b3903327/x11docker) - 2018-03-16
### Fixed
 - alpine images: `/etc/shadow` entry must be `/bin/sh`, `--dbus-system` with `su` fails with `/bin/bash`.
 - openSUSE: `finish()`: replace `bc` with bash-only calculation, `bc` is missing on openSUSE.

## [3.9.7](https://github.com/mviereck/x11docker/blob/82e573068bfe78a9650f40cb5b98df9b1e08d483/x11docker) - 2018-03-15
### Changed
 - structure change: don't `sleep 1` for setup; instead wait for it in `x11docker.CMD.sh` resp. run `su` or `init` in setup
 - `xinitrc`: some cleanup
 - `--verbose`: power of moo
 - SSH with `--hostdisplay`: set `--hostipc`, `--hostnet` and `--trusted`. Do not use X-generated cookie, bake it myself.
### Fixed
 - openSUSE/fedora: `ps` check for container pid; fixed desktop logout issue, too.
 - `---weston`/`--weston-xwayland`: do not start drm backend if started within X without `DISPLAY` -> crashed host X.
 - regard SSH session, assume tty if `DISPLAY` is empty.
 - `--hostdisplay`: don't set keymap.

## [3.9.6.1](https://github.com/mviereck/x11docker/blob/1e482bc9341a6c22771b3ba602edb847e25d6d82/x11docker) - 2018-03-10
### Changed
 - `--lang`: replace `locale-gen` with more general available `localedef`.
### Fixed
 - `--tini`: check for `docker-init` in `PATH`, disable default option `--tini` if missing. ([#23](https://github.com/mviereck/x11docker/issues/23))

## [3.9.6](https://github.com/mviereck/x11docker/blob/0a4166c020c9700e592c0d7600b4a8b5e9850222/x11docker) - 2018-03-09
### Added
 - `--lang` to set language locale in utf8, create it if missing.

## [3.9.5](https://github.com/mviereck/x11docker/blob/9a86a235f82e900d83bb0bbd4e2b85db60c5335b/x11docker) - 2018-03-06
### Added
 - `--keymap` to set keyboard layout.

## [3.9.4.2](https://github.com/mviereck/x11docker/blob/4777416424b379dfc52240e8a32fe10bbef0a25f/x11docker) - 2018-03-06
### Fixed
 - Store keyboard layout (xkb_keymap) in separate file, not in xinitrc. Set on all X servers. [#25](https://github.com/mviereck/x11docker/issues/25)

## [3.9.4.1](https://github.com/mviereck/x11docker/blob/68a7a529b807f40d102842ebc3fe16ca3435b771/x11docker) - 2018-03-06
### Changed 
 - share `/etc/localtime` with container to have the same time zone as on host.
### Fixed
 - typo `--pulseaudio`

## [3.9.4.0](https://github.com/mviereck/x11docker/blob/fa043c37d029982ed44431032f37e05f5c5f0024/x11docker) - 2018-03-05
### Added
 - `--sys-admin`: no longer deprecated, needed for systemd in debian 9 images (but not debian 10). Adds capability `SYS_ADMIN`.
 - `--hostnet` replaces former `--net`.
 - `--hostipc` replaces former `--ipc`.
 - `--dbus-system` replaces former `--dbus-daemon`.
### Changed
 - `--pulseaudio` with `--hostnet`: no fallback to `--alsa`, use localhost IP instead.
 - `--pulseaudio` `--no-internet`: fallback to `--alsa`.
 - `--auto` `--gpu`: fallback to `--hostdisplay` for seamless mode if xpra and weston not found. ([#23](https://github.com/mviereck/x11docker/issues/23))
 - clean up error message on docker startup failure, remove multiple error lines.
 - stdout and stderr of image command outsourced of `docker.log`.
 - `docker log -f >> docker.log` to get output in detached mode.
 - more verbose messages in waiting subroutines.
### Deprecated
 - `--net` is replaced by `--hostnet`.
 - `--ipc` is replaced by `--hostipc`.
 - `--dbus-daemon` is replaced by `--dbus-system`.
### Fixed
 - mount `/dev/dri` and `/dev/snd` not only with `--device`, but also `--volume` to keep ownership+group. Workaround for bug in docker. [#24](https://github.com/mviereck/x11docker/issues/24). 
 - `--hostdisplay`: Use correct display number to share `/tmp/.X0-lock`, only share if it exists.
 - `--systemd`: terminate x11docker if systemd startup fails.

## [3.9.3.2](https://github.com/mviereck/x11docker/blob/f28e182de62f7f25a5458d6d1db28aee5f339eb3/x11docker) - 2018-03-01
### Added
 - `--no-xtest`: disable extension `XTEST`. Default for most options.
### Fixed
 - openSUSE docker package misses init binary `docker-init`, show warnings for `--tini`. [#23](https://github.com/mviereck/x11docker/issues/23)

## [3.9.3.1](https://github.com/mviereck/x11docker/blob/7883bb089dc1ea8c438ed7be123e3bfcbd4eded2/x11docker) - 2018-03-01
### Fixed
 - Avoid wrong `XTEST` warning messages.

## [3.9.3](https://github.com/mviereck/x11docker/blob/4f8cd878dcc44469bdb9afce2f91afce3abcda8a/x11docker) - 2018-03-01
### Added
 - `--xtest` to enable X extension `XTEST`. Default for `--xdummy`, `--xvfb`, `--xpra`
### Changed
 - `--tini`: show warning for outdated docker versions without option `--init` and fall back to `--no-init`. [#23](https://github.com/mviereck/x11docker/issues/23)
 - `--pulseaudio` with `--net`: fallback to `--alsa`, disabling `--pulseaudio`.

## [3.9.2.3](https://github.com/mviereck/x11docker/blob/62e31a381b79b67a1eea9f84b629a849833249c0/x11docker) - 2018-02-25
### Changed
 - set container GID of video and audio to same as on host. Avoids issues if container system has different GIDs than host.
 - cat docker daemon messages for startup error message.
 - `mywatch()`: replaced watch with custom sleep loop, watch failed in `--hostdisplay` (xinitrc) setups.
 - `mywatch()`: verbose output.
 - `--exe`: only forward stdin if not empty.
 - `finish()`: use pkill in most cases instead of kill to avoid kill success messages.
### Fixed
 - `--weston`/`--kwin`: wait for file creation of wayland socket, checking logfile is not enough.
 - `--kwin`: kwin_wayland seems to need dbus-launch now.

## [3.9.2.2](https://github.com/mviereck/x11docker/blob/699cdd4d4eb40846619233ef65edefe74e1246d0/x11docker) - 2018-02-09
### Changed
 - check free display and cache folder with find only.
 - plasmashell added to possible window managers.
### Fixed
 - `--exe`: avoid possible hostexe options with `basename` for `$Hostexebasename`.
 - typo checking `/tmp/.Xn-lock`.
 - checking free display number: race condition if starting two x11docker instances at same time, second one failed because display number already in use.

## [3.9.2.1](https://github.com/mviereck/x11docker/blob/3c28c1b61596fbc8a7e2b3ea0bbbe75dbc320fc4/x11docker) - 2018-01-29
### Changed
 - create `/x11docker/environment` to store and provide container environment variables.
### Fixed
 - correct date/year in changelog. ([#21](https://github.com/mviereck/x11docker/issues/21))
 - `finish()`: wrong warning although terminating bgpid was successfull.

## [3.9.2](https://github.com/mviereck/x11docker/blob/64556a1096470761e66f15c21b5054a6cba7a734/x11docker) - 2018-01-21
### Changed
 - `finish()`: more precise check with pid and name before killing background pids.
### Fixed
 - add groups `video` and `audio` in `docker run` if `su` is not used in container. `/etc/group` changes by dockerrc seem to be not regarded in that case.

## [3.9.1.9](https://github.com/mviereck/x11docker/blob/f789a74ceab2f547b3d2939a5e23f21b32c0cd7c/x11docker) - 2018-01-17
### Changed
 - `--xpra`: if server crashes, use xpra option `--mmap=no` on restart.

## [3.9.1.8](https://github.com/mviereck/x11docker/blob/363351c54eeaad227c942bbe3eeb035085930580/x11docker) - 2018-01-16
### Changed
 - `--xpra`: stop x11docker if xpra server crashes multiple times.

## [3.9.1.7](https://github.com/mviereck/x11docker/blob/3b20fd795ac133b36702ed516e2e4efb1669f7d4/x11docker) - 2018-01-15
### Changed
 - `--gpu`: share `/dev/vga_arbiter` and `/dev/nvidia*`.

## [3.9.1.6](https://github.com/mviereck/x11docker/blob/f4797498300a30aad91985ca08269eb475826984/x11docker) - 2018-01-15
### Changed
 - `--xpra`: restart xpra server if it crashes (can happen with xpra 2.2, reason unknown)

## [3.9.1.5](https://github.com/mviereck/x11docker/blob/c2b217885e424e889d206018b584ca4e4caaf837/x11docker) - 2018-01-13
### Fixed
 - `--xpra`: reconnect to server after timeout (60s) if switching to console.

## [3.9.1.4](https://github.com/mviereck/x11docker/blob/7a4c0093bb643a3de00ab81f177b24597cc60a64/x11docker) - 2018-01-12
### Changed
 - `--help`: some `usage()` updates.
 - `--xorg`: create virtual framebuffer if no monitor is connected (headless server setup).
 - `--xpra`: note that 2.1.x series is more stable than 2.2.x series.
 - create `$Cacherootfolder/Xenv.latest` with latest X environment variables for easier custom access.
 - `--verbose --systemd`: hide error messages: `Failed to add fd to store | Failed to set invocation ID | Failed to reset devices.list`
 - `--systemd`: set global environment variable `XAUTHORITY`.

## [3.9.1.3](https://github.com/mviereck/x11docker/blob/4c82febbcf6d7a568bbb117c93047c3dd666fc9d/x11docker) - 2018-01-04
### Changed
 - `--dbus-daemon`: set `xhost +SI:localuser:$USER`, needed for deepin.
 - `--pulseaudio`: faster startup of pulseaudio, no sleep 1.
 - create fake home directory and softlinks to sharedirs in CMD.sh, base is `/fakehome` now.
 - extension `XTEST`: more restrictive defaults.
### Fixed
 - pull terminal did not appear if running from terminal.
 - `--systemd`: global `XAUTHORITY` setting was wrong, removed at all.

## [3.9.1.2](https://github.com/mviereck/x11docker/blob/a88992416fedc2c0b3f57def7ecd8f8e00e78bff/x11docker) - 2017-12-28
### Changed
 - `--sudouser`: root gets password `x11docker`, too. Allows `su` now.
 - cut image command at `#` to allow comments in x11docker-gui examples.
### Fixed
 - check environment variables in image and set them in `x11docker.CMD.sh`. Allows `PATH` of `x11docker/trinity` again.
 - parsing host `XAUTHORITY` if running from `gksu`.

## [3.9.1.1](https://github.com/mviereck/x11docker/blob/31f36368883ee456f4fa48c5edf0fa062b030a51/x11docker) - 2017-12-28
### Fixed
 - `--systemd`: directly share X socket as systemd can have issues with soft links

## [3.9.1](https://github.com/mviereck/x11docker/blob/038bf252c699b438011260ec0dc61d4192f4b5e4/x11docker) - 2017-12-25
### Changed
 - run in detached mode, drop mess of nohup/setsid/script
 - `--dbusdaemon`: dropped consolekit, not really useful
 - `--dbusdaemon`: switch only for  `--tini`/`--none`. Always run daemon for `--systemd` `--openrc` `--runit`
 - `--systemd`: create `/sys/fs/cgroup/systemd` if missing on host
 - `containersetup.sh` collects most former `docker exec` commands from `dockerrc`
### Deprecated
 - `--sys-admin`: thanks to `--tmpfs=/run/lock` _(Note: reintroduced in v3.9.4.0)_ 

## [3.9.0.5](https://github.com/mviereck/x11docker/blob/a264d9b778c0c9dcf76dc5be1e2f362c120acf4f/x11docker) - 2017-12-21
### Changed
 - add capability `DAC_OVERRIDE` if user switching is allowed -> needed to change `/etc/sudoers` if ro.
 - `--systemd`: adding `--tmpfs=/run/lock` allows to drop `--sys-admin` !
### Fixed
 - only create `XDG_RUNTIME_DIR` if not already existing.

## [3.9.0.4](https://github.com/mviereck/x11docker/blob/c1b307a7f3981cf0b63aebfd2672baa319afa0ab/x11docker) - 2017-12-20
 - changes to satisfy `lirios/unstable`:
 - add docker run `-ti`
 - run docker command with `script -c` to provide fake tty
 - changed `/tmp/fakehome` to `/home/fakehome`
 - use `--workdir=/tmp`, avoids issues with `WORKDIR` in image
### Fixed
 - `--dbus`: check for `dbus-launch` in `x11docker.CMD.sh`, not in `dockerrc` on host

## [3.9.0.3](https://github.com/mviereck/x11docker/blob/0b48a998d8f6c53636b3197899e0bacb002227c8/x11docker) - 2017-12-17
### Changed
 - switched back to `/tmp/fakehome` to avoid `CHOWN` and issues with `--sharedir`.
 - drop `--cap-add CHOWN`.
 - `--sharedir`: without `--home[dir]`, create softlinks to `/tmp/fakehome`.
 - `--home`: avoid conflict with `--sharedir=$HOME`, mount as `$HOME/$(basename $HOME)`.
 - only `chown $Benutzerhome` if `--home[dir]` is not used. Change non-writeable error in warning only.
 - `--hostdisplay`: warning if host has no own cookie.
### Fixed
 - avoid grey edge with Xwayland, `Xaxis` must be dividable by 8.
 - `--sudouser` failed to start

## [3.9.0.2](https://github.com/mviereck/x11docker/blob/55923adf38ae3a5bb13373419e8e7473ab4e88eb/x11docker) - 2017-12-16
### Changed
 - `/etc/sudoers[.d/]`: replace completly to avoid possible evil image setups.
 - `--cap-add CHOWN` as default to allow `/home/$Benutzer` with `--sharedir`

## [3.9.0.1](https://github.com/mviereck/x11docker/blob/f95bdb31a51255c8fb8515d6d2d03542383a7301/x11docker) - 2017-12-16
### Changed
 - use `/home/$Benutzer` instead of `/tmp/fakehome`.
### Fixed
 - `--systemd`: do not set environment variable `HOME` globally, root may write into it.

## [3.9.0](https://github.com/mviereck/x11docker/blob/f4459cac35165c9e2dec964204505f440c9ea297/x11docker) - 2017-12-15
### Added
 - `--dbusdaemon` to run dbus system daemon and consolekit in container.
 - `--openrc` for init system OpenRC in container.
 - `--sharecgroup` to share `/sys/fs/cgroup`. Default for `--systemd`, possible use cases for `--openrc`.
### Changed
 - `/etc/shadow`: disable possible root password.
 - re-checked capabilities for init systems.
 - `--systemd`: set environment globally, especially `DISPLAY` for `x11docker/deepin` is needed.
 - `--systemd`: set `xhost+SI:localuser:$Benutzer` as `XAUTHORITY` seems to be ignored.
 - `/tmp/.ICE-unix` created in dockerrc, root owned with `1777`, needed for `SESSION_MANAGER`.
 - `--xorg`: change Xorg to X. X is setuid wrapper for Xorg on Ubuntu 14.04.
 - `--xorg`: +iglx removed from X options, not present in older versions of X, and maybe security issue.
 - create user in dockerrc with `docker exec` instead of using createuser.sh.
 - show image name and display in weston window title.
### Deprecated 
 - `--rw`, root file system is always r/w now due to `docker exec` in dockerrc.
### Fixed
 - Ubuntu: avoid Wayland backend for Weston due to MIR issue. [#19](https://github.com/mviereck/x11docker/issues/19)
 - create `/var/lib/dbus` in dockerrc to avoid dbus errors with init systems.
 - `--runit`: add `SYS_BOOT` even with `--cap-default`.

## [3.8.0](https://github.com/mviereck/x11docker/blob/a9e15fc63b6ffbdad2ff0db35bdea1a5b26df336/x11docker) - 2017-12-04
### Added
 - `--systemd` to run systemd as PID 1 in container and run image command as a service.
 - `--runit` for init system runit.
 - `--init` for init system tini (default now, docker run option `--init`).
 - `--no-init` to run image command as PID 1 (has been default before x11docker 3.8).
 - `--sys-admin` for `--cap-add=SYS_ADMIN`. Needed for systemd in debian based images.
 - `--wayland` to auto-setup Wayland environment.
### Changed
 - run init system `tini` as default with `docker run --init`.
 - `-W` is now `--wayland` instead of `--weston`, `-T` for `--weston` now.
 - container user password: `x11docker` (creating volume `/etc/shadow`).
 - `--sudouser`: create user with docker run options instead of createuser script.
 - `--sudouser`: create `/etc/sudoers.d/$Benutzer` with docker exec in dockerrc.
 - `--sudouser`: create `/etc/sudoers.d/$Benutzer` instead of adding groups `wheel` and `sudo`.
 - createuser.sh: check for `useradd`, if missing use `adduser` (fits fedora and alpine/busybox as well).
 - $Sharefolder/stdout+sterr: `chmod 666` to allow access with `--user`.
 - `--exe` and `--xonly`: regard `--home` and `--homedir`, `--user` and `--hostuser`.
 - check pids before calling `mywatch()`.
 - colored logfile output.
 - `--verbose`: green colored output for logfile titles and verbose() lines.
 - set env `DISPLAY` `XAUTHORITY` and `WAYLAND_DISPLAY` in x11docker.CMD.sh as systemd eats them otherwise.
 - use docker run option `--tmpfs` for `/tmp`, `/var/tmp` and `/run` instead of `--volume=/tmp`.
 - changed container share folder `/tmp/x11docker` to `/x11docker` to avoid issues with `--tmpfs /tmp`.
### Fixed
 - in createuser.sh: `adduser` failed with fedora based images, use `useradd` and `usermod` instead.
 - `--pw=gksu`: avoid wrong docker startup error message, use nohup in dockerrc.
 - `--hostdisplay` with `--gpu` needs trusted cookies.
 - `--xpra` with `--hostuser`: create `/run/user/$Hostuseruid` if missing.

## [3.7.2](https://github.com/mviereck/x11docker/blob/e062b07b91b87a1b9b26d10e41d0d7dd1c3b6299/x11docker) - 2017-11-11
### Changes
 - allow `rw` with `--volume=/var/tmp`, needed for `x11docker/trinity`.
 - `--nxagent`: removed `xhost` startup workaround.
 - $Hostxenv: removed custom environment.
 - `--nxagent`: shift+F11 toggles fullscreen.
 - `--nxagent` on Mageia: only show warning about seamless mode instead of disabling it.
### Fixed
 - `su` on console needs `exec </dev/tty` to have a tty environment.

## [3.7.1](https://github.com/mviereck/x11docker/blob/d3c841246548e9667909cc25ffad5396b0ebfde2/x11docker) - 2017-11-03
### Changed
 - read host cookie with xauth if XAUTHORITY is empty, can happen with xdm.
 - `--nxagent` on Mageia: no seamless mode.
 - replaced while/sleep loops with `watch`.
 - `alertbox()`: regard `DISPLAY`, use `$Anyterminal` otherwise to support Wayland.
 - `weston.ini`: keyboard config setting on console.
 - fedora: show alert for `--ipc`/`--trusted` due to missing extension security.
### Fixed
 - fixes for gksudo and lxsudo.
 - Ubuntu 16.04: `--xpra`: must not set `--webcam=no` due to old xpra version.
 - `--weston` and `--kwin` on console, terminal for password prompt failed.

## [3.7.0](https://github.com/mviereck/x11docker/blob/d06c59495775bfbb0bc79dea3ace02dbfb2293c9/x11docker) - 2017-10-30
### Added
 - `--alsa` for ALSA sound.
### Changed
 - auto-choose window manager in `--xephyr`/`--xorg`/`--weston-xwayland`/`--kwin-xwayland`/`--xwayland` except `--desktop` is set.
 - new function `alertbox()`, outsourced from `error()`. Additional messagebox tools: yad, kaptain, kdialog, gxmessage, xterm.
 - changed content of variable `Xserver` to X server option names itself.
 - extended terminal list for password prompt/docker pull.
 - `--xhost`: always disabling with `no_xhost()`, afterwards setting `--xhost`.
### Deprecated
 - `--kwin-native`, too much trouble, but less use.
### Fixed
 - `--weston`/`--weston-xwayland`: set backend in compositor command, weston's autodetection can fail.
 - `--kwin`/`--kwin-xwayland`: set backend in compositor command, kwin's autodetection can fail.
 - `--kwin-xwayland`: set keyboard layout.

## [3.6.3.9](https://github.com/mviereck/x11docker/blob/1f4353964dba1d01289a5379a1b4d0bf10c666f1/x11docker) - 2017-10-25
 - show error messages regardless of `--silent`
 - change `sudo` to `sudo -E`, needed for OpenSUSE
 - code cleanup, some improved messages

## [3.6.3.8](https://github.com/mviereck/x11docker/blob/2e027c2b9bab8af2244fe65218276f0ad7a84736/x11docker) - 2017-10-25
 - fedora: set `--ipc` and `--trusted` for `--hostdisplay` only

## [3.6.3.7](https://github.com/mviereck/x11docker/blob/6034608f9d49c138d3f58b647257114b9c66052e/x11docker) - 2017-10-25
 - **bugfix** `--hostdisplay` on fedora: use host cookie, custom cookie is rejected

## [3.6.3.6](https://github.com/mviereck/x11docker/blob/84881c51788eecc754f36288fbb8699c5dbc327f/x11docker) - 2017-10-24
 - **new option** `--wmlist` to retrieve list of window managers, used by x11docker-gui
 - `--gpu`: improved support in autochoosing mode
 - disabled note of xpra keyboard shortcuts, takes too long
 - hardcoded xpra environment variables, parsing `xpra showconfig` takes too long
 - **bugfix** for `--pw=sudo`, issue with setsid

## [3.6.3.5](https://github.com/mviereck/x11docker/blob/12bb570b2c03157d4062391288f770e520307c0f/x11docker) - 2017-10-24
 - **bugfix** xpra with host user root: set environment variables
 - `dbus-launch` for `konsole` and `terminator`, needed in dockerrc

## [3.6.3.4](https://github.com/mviereck/x11docker/blob/836d4f50e44cccc587819f002faa8d18e62ecbb3/x11docker) - 2017-10-23
 - add `/usr/sbin` to `PATH`, needed on mageia for ip
 - **bugfix** `--pw=sudo`: `setsid sudo` fails, must use `sudo setsid`

## [3.6.3.3](https://github.com/mviereck/x11docker/blob/4256438ff948dd97a0887410e866121736a1893b/x11docker) - 2017-10-23
 - removed experimental Code
 - **bugfix** for `--wm` as root in xinitrc

## [3.6.3.2](https://github.com/mviereck/x11docker/blob/58ea47a22270ad0a7f81196cb8c69bf300e87dff/x11docker) - 2017-10-23
 - remove debugging `set -x` in xinitrc

## [3.6.3.1](https://github.com/mviereck/x11docker/blob/ed80f32c115066203b88b9681655c30bc2c42f13/x11docker) - 2017-10-23
 - **bugfix**: don't use `su $USER` in xinitrc
 - split X server command with \backslash in multiple lines

## [3.6.3](https://github.com/mviereck/x11docker/blob/63410b85f617b3449c48212dda9d0e74ec6327bf/x11docker) - 2017-10-20
 - **new option** `--no-internet`; adjustments for CentOS/RHEL, Arch and Manjaro
 - allow gnome-terminal / self-forking terminals in general
 - split docker command with \backslash in multiple lines

## [3.6.2.12](https://github.com/mviereck/x11docker/blob/e907bd364ed591fc1087fa64005f4f890345d43f/x11docker) - 2017-10-18
 -  **bugfix**: dbus-launch disturbed gksu

## [3.6.2.11](https://github.com/mviereck/x11docker/blob/a21a9d8cca6483b8c29b50e0a77b348867325e04/x11docker) - 2017-10-18
 -  CentOS/RHEL workaround: insist on root or gksu; terminal password prompt causes docker to terminate regardless of nohup

## [3.6.2.10](https://github.com/mviereck/x11docker/blob/18506dee00b987b0acaca9ed84531e3aadb07f8f/x11docker) - 2017-10-17
 -  **bugfixes** in terminal-emulator setup for password prompt and pull question (2)

## [3.6.2.9](https://github.com/mviereck/x11docker/blob/c4fcfac53be978322831fcad4a6b671598faa19f/x11docker) - 2017-10-17
 -  **bugfixes** in terminal-emulator setup for password prompt and pull question
 -  xpra: `--file-transfer=off` (stores files in `Downloads` from host, useless here)

## [3.6.2.8](https://github.com/mviereck/x11docker/blob/dc36c1d29958cdf48a8c45ec791220f869026cd1/x11docker) - 2017-10-12
 -  `--xdummy`/`--xpra`: add multiple modelines for virtual display sizes to allow flexible changes of xpra client desktop window
 -  `--xpra`: virtual display size always equal with physical display, create smaller mode in xinitrc -> allow fullscreen
 -  xpra: disable some unused, but possibly leaking features (forwarding of webcam, notifications, printer)
 -  xpra: set xpra specific environment variables in dockerrc
 -  xpra: show keyboard shortcuts

## [3.6.2.7](https://github.com/mviereck/x11docker/blob/51c5dab789c335d87c4d11c5ad91ebe7477766f1/x11docker) - 2017-10-08
 -  `--xephyr`: title for Xephyr windows
 -  `--xephyr`: Xnest as fallback for missing Xephyr
 -  `--xpra` `--desktop` hint: screensize bug fixed since xpra v2.2-r17117

## [3.6.2.6](https://github.com/mviereck/x11docker/blob/4d94c7eb5dc690e8a22135394cb2e9d4dd3ba9ab/x11docker) - 2017-10-07
 -  **bugfix**: `--xpra` `--desktop`: use start-desktop instead of shadow

## [3.6.2.5](https://github.com/mviereck/x11docker/blob/72e8afc59750310ac621c10c5ddcaf826bc167f2/x11docker) - 2017-10-05
 -  `no_xhost()?` after cookie creation avoids xhost warning on Xwayland
 -  `--output-count` in `--auto` mode: choose `--weston-xwayland`
 -  `--display`: allow : before display number
 -  `sh` instead of `bash` to run x11docker_CMD

## [3.6.2.4](https://github.com/mviereck/x11docker/blob/8ab3d12af1c14b437870788b72615eb89d0bfa0a/x11docker) - 2017-09-27
 -  `--starter`: missing xdg-user-dir is no longer an error
 -  `--silent`: redirect stderr already while parsing
 -  `--user=root`: disable `--cap-drop=`ALL
 -  `--help`: update usage info
 -  `weston.ini`: background color and zoom-in effect
 -  **bugfix** `--xonly`: do not fail if docker daemon is not running
 -  use Kwin/Kwin-Xwayland as fallback for Weston/Weston-Xwayland
 -  catch closing xpra client in every case, not only in desktop mode
 -  parsing cli options: check for remaining arguments `$#` instead of empty `$1`

## [3.6.2.3](https://github.com/mviereck/x11docker/blob/a24de4ad106ffa1c2c671a53c3c16582efe1ad14/x11docker) - 2017-09-19
 -  `--xorg`: only run setxkbmap in xinitrc if $Hostdisplay is set

## [3.6.2.2](https://github.com/mviereck/x11docker/blob/e137d771026424dcf4d0bbfc83bfec94195448c5/x11docker) - 2017-09-18
 -  `--xpra` `--scale` in desktop mode: regard different `--dpi` behaviour since xpra v2.2
 -  `--help`: update usage info
 -  `setxkbmap` for Xorg like for Xephyr, too
 -  `weston.ini`: added `panel-position=none`, different syntax for different weston versions (seen in Arch Linux).
 -  x11docker_CMD: replace shell with `exec $Imagecommand` (only if stdin is empty)

## [3.6.2.1](https://github.com/mviereck/x11docker/blob/3bffa70a029722a3aeeb6137720f0270bd359e3d/x11docker) - 2017-09-15
 -  `--home`: avoid creating $Adduserhomefolder with wrong restrictions if $Hostuser is different from $Benutzer
 -  removed `z` flag in docker command, not needed with current SELinux solution
 -  `--weston[-xwayland]`: no output section on tty without `--scale`, `--size` or `--rotate`
 -  `--weston[-xwayland]`: allow `--size` on tty, though only "real" resolutions will take effect
 -  `--xorg`: `--scale`, `--size`: change primary monitor only, will do better on multi monitor setup
 -  **bugfixes** in part: check screensize
 -  **bugfix**: watch for closing xpra client in desktop mode to avoid invisible remaining x11docker
 -  **bugfix**: `--xdummy` `--gpu` now possible on tty, too
 -  **bugfix**: `--xorg` on tty: do not set screen size without `--size`.

## [3.6.2](https://github.com/mviereck/x11docker/blob/d223b1b97d3c98b6dcf4769152122ee5e2e9dbc8/x11docker) - 2017-10-10
 -  **bugfix** `--sharedir`, `--homedir`: allow whitespaces in path
 -  **bugfix** `--cachedir`: path must not contain whitespaces -> error()
 -  **bugfix** `--westonini`: allow whitespaces in path
 -  **bugfix** `--pulseaudio`: remove tcp module, store id in file to not loose it in subshell
 -  **bugfix** `--exe`: support of `--stdout` and `--stderr`
 -  **bugfix** `error()`/`finish()`: reliable error code before cache folder creation
 -  **bugfix** weston on tty: clean logfile&pidfile to allow second weston
 -  `--westonini`: regard for `--xpra-xwayland` and `--xdummy-xwayland`, too.
 -  `PATH`: adding `/usr/games:/usr/local/bin`. Can miss for root, but may be needed for `--exe` and `--xfishtank`
 -  check for X extension `Security` with xdpyinfo
 -  `--clipboard` for `--hostdisplay`: enable `--trusted` and -ipc, show warning.
 -  xpra startup after xinitrc, not inside. for better error handling
 -  removed ps loop in dockerrc, not needed anymore due to "docker run" in subshell
 -  `waitforlogentry()`: Just return 0 or 1 instead of calling `error()`
 -  **new option** `--xfishtank` to run xfishtank on new X server
 -  changed logfile handling, move log from `/tmp` to $Sharefolder after `tail -F`

## [3.6.1.11](https://github.com/mviereck/x11docker/blob/27861a05fb0fd28f51a8358ae37ab877913aa146/x11docker) - 2017-08-28
 -  clean check for stdin, no more workaround

## [3.6.1.10](https://github.com/mviereck/x11docker/blob/cbb904ef2b2c94ccda76aec9f6a59b68dcb854c2/x11docker) - 2017-08-27
 -  `--nothing`: no check for successfull startup, avoids error message for short-timed cli commands
 -  `--showenv`: wait for output until X is ready

## [3.6.1.9](https://github.com/mviereck/x11docker/blob/d50ecb314b5d96110b59796493bc983a46a5c780/x11docker) - 2017-08-25
 - **bugfix**: `--home`: remove debugging error message

## [3.6.1.8](https://github.com/mviereck/x11docker/blob/e3a49cbe95522a79128e9af8feede4b04074a96b/x11docker) - 2017-08-25
 - **bugfix** `--orphaned`: did not find cache folder
 - provide stdin to host exe, too (`--exe`)
 - **bugfix** `--hostuser`: cache folder created with root ownership
 - `--silent`: supress error dialog box, too
 - more reliable exit code 1 on error

## [3.6.1.7](https://github.com/mviereck/x11docker/blob/427a937a53c81b3bf98621aeb668048d4a8e913a/x11docker) - 2017-08-22
 - removed color from verbose, looks strange in logfile
 - **bugfix** installer: check for installed unzip

## [3.6.1.6](https://github.com/mviereck/x11docker/blob/699392d7579e3962d099cf495dc254fde4e9bf97/x11docker) - 2017-08-22
 - code cleanup
 - changed window manager priority
 - SELinux: `--security-opt label=type:container_runtime_t` allows access to X unix socket
 - `--xorg`: avoid searching for native resolution if `--scale` is set.
 - `--xorg`: improved check for failed panning
 - Logfile created in `/tmp`, moved later to $Cacherootfolder, to catch early messages
 - **bugfix**: `trap -EXIT` avoids double finish. faster shutdown now.
 - code cleanup in variable definitions and option parsing

## [3.6.1.5](https://github.com/mviereck/x11docker/blob/34ac2a9bdc63b2d2bcaebc06bed3e3bdcc92845c/x11docker) - 2017-08-21
 - **bugfix**: broken stdin pipe if running as root
 - `mkdir -p` in installer for tmp folder: `-p` was missing, could cause error
 - declare `note()` in xinitrc
 - `--scale` support for `--xorg`
 - `--size` without `--scale` for `--xorg`: first try `--mode`, than panning

## [3.6.1.4](https://github.com/mviereck/x11docker/blob/de1b34d32b5a08b269ebab5c7695d17f59eb16b7/x11docker) - 2017-08-19
 - **bugfix**: wrong file descriptor for messages before part init()
 - **bugfix**: passwordless `sudo -n` on fedora did not work with x11docker-gui started from menu instead of cli, without `-n` is ok
 - `beesu`: new frontend for `--pw` available on fedora
 - do not test for passwordless docker if `--pw` is set
 - create non-existing shared home folder for user different from host user if running as root
 - more verbose cache folder names, now with image name and X server in use

## [3.6.1.3](https://github.com/mviereck/x11docker/blob/17dd6a39f5256be816cd22327a34f70e1845cf07/x11docker) - 2017-08-17
 - **bugfix** installer: did not find icon at new location

## [3.6.1.2](https://github.com/mviereck/x11docker/blob/53839badad3e440057cd5a2ef122b38616b50a95/x11docker) - 2017-08-15
 - **deprecated** `--resizeable`: Xephyr can crash if resized.
 - no `|tee` to $Xtermlogfile on `docker pull`: better interactive output

## [3.6.1.1](https://github.com/mviereck/x11docker/blob/133c26e737ac7936b894c30e01ee8f454374db97/x11docker) -2017-08-16
 - timeout 3600 for xauth cookie creation. Needed to avoid cookie timeout on `docker pull`

## [3.6.1](https://github.com/mviereck/x11docker/blob/cf56d6b5039c634934644051c6b75ea5218060ac/x11docker) - 2017-08-15
 - `--stdout` and `--stderr`: **new option**s showing stdout and stderr of imagecommand
 - forward stdin of x11docker to image command
 - **new option** `--silent`: supressing all x11docker terminal messages
 - x11docker-gui trys to use image `x11docker/kaptain` if `kaptain` is not installed

## [3.6.0.5](https://github.com/mviereck/x11docker/blob/1f309fa8970b972b58eaa22d03c43c958bc7d783/x11docker) - 2017-08-14
 - **bugfix** opensuse: cookie creation failed due to different xauth behaviour
 - **bugfix** sudo: do not prompt for password for `docker stop` in `finish()`, rather fail stopping
 - `note()` instead of `warning()` for less urgent messages

## [3.6.0.4](https://github.com/mviereck/x11docker/blob/ae2e6ec386c43d724c635484bdc3b005ed42fcdf/x11docker) - 2017-08-14
 - **bugfix**: do not complain about missing docker daemon on `--xonly`

## [3.6.0.3](https://github.com/mviereck/x11docker/blob/50b48ea0088c9f1742af0b4d97cac1e26db54699/x11docker) - 2017-08-13
 - xpra dpi warning only if `--dpi` or `--scale` is set
 - cookie failure warning for untrusted cookies only
 - **bugfix** installer: remove older installations in `/usr/local/bin`

## [3.6.0.2](https://github.com/mviereck/x11docker/blob/0f2c38b69a0645f3c7df1ccae0e02389a5199631/x11docker) - 2017-08-13
 - **bugfix** preventing `--xorg` from console if running in subshell
 - **bugfix** in `finish()`: check for still running container with ps, too. formerly root only could detect it
 - check for running docker daemon with $Dockerdaemon instead of ifconfig
 - do not disable SELinux if `--ipc` is set
 - **bugfix** fedora: `--xorg`: add -keeptty if running from tty

## [3.6.0.1](https://github.com/mviereck/x11docker/blob/01baffa250c048988f64beeb4ddf05660a766639/x11docker) - 2017-08-12
 - **bugfix** `--gpu`: :rw,z does not work for `--device`

## [3.6.0](https://github.com/mviereck/x11docker/blob/d580a477617fb7d32da263a5408a82c01756fef1/x11docker) - 2017-08-12
 - workaround: disabling SELinux for container until solution for sharing unix socket is found.
 - compare: http://www.projectatomic.io/blog/2015/06/using-volumes-with-docker-can-cause-problems-with-selinux/
 - install to `/usr/bin` instead of `/usr/local/bin` to support root
 - chmod 755 instead of +x in installation
 - check if docker is installed
 - check if docker daemon is running (with ifconfig)
 - use zenity or notify-send if xmessage is not available in error()
 - **bugfix**: cookie creation failed on X without extension Security. (fedora)
 - replaced sed in xauth cookie creation, sed fails in openSUSE (!?)
 - **new option** `--rw` to allow read/write access to container root file system
 - check for xpra `--dpi` bug in 2.1 series
 - xpra `--start-via-proxy=no` for xpra >= 2.1
 - `--nxagent`: temporary `xhost +SI:localuser:$Hostuser` workaround as it fails again to authenticate, not dividing between `XAUTHORITY` and `--auth`
 - **new option** `--pw` to choose password prompt frontend. default: `pkexec`
 - reduce dependency warnings for `--auto`
 - **bugfix**: repeating error message if `waitforlogentry()` failes
 - prefer $Hostenv instead of $Newxenv for password prompt -> better support for gksu
 - show `docker pull` output in a terminal window
 - allow `--hostdisplay` with `--xonly`. May at least be usefull to create an untrusted cookie.
 - **bugfixes** in part "check window manager"
 - slit docker startup from xinitrc
 - copy host cookie into $Cachefolder for compatibility with gksu
 - use gksu/gksudo if available
 - `--showenv` for `--xonly`
 - `finish()` : `docker stop $Containername`
 - dockerrc: no ps/sleep loop if running as root
 - **new option** `--no-entrypoint` to disable ENTRYPOINT in image
 - **deprecated**: `--root`: Can be achieved with `--hostuser=root`
 - **new option** `--hostuser` to set host user different from  $(logname)
 - check if docker can run without password to make `--no-password` needless
 - don't start docker in xinitrc as xinit runs unprivileged
 - `--ps` keeps cache files, too (formerly container only)
 - `--desktop`: **no longer deprecated**, easier to understand and remember than `--wm=none`
 - `-d`: used for `--desktop` again, no longer for `--dbus`. `--dbus` now has short opt `-b`
 - improved X server check due to new variable $Desktopmode
 - **bugfix**: &, &&, ;, <, >, | and the like possible in image command again
 - `--fullscreen`. Set fullscreen screen size for windowed options (xpra),too
 - allow root to start x11docker, use `$(logname)` for X server and as container user

## [3.5.11](https://github.com/mviereck/x11docker/blob/27f52c9edb28518568e8f6881a1300ca4aea4f2b/x11docker) - 2017-07-12
 - pull image if not available before calling `docker run`

## [3.5.10](https://github.com/mviereck/x11docker/blob/dbd85cfc9f26948ddf8e27075923ff673dc5a89b/x11docker) - 2017-07-12
 - regard `ENTRYPOINT` in dockerrc

## [3.5.9](https://github.com/mviereck/x11docker/blob/623c20b427b50fc16c127c760688cfbb556c0b8b/x11docker) - 2017-07-09
 - **bugfix** `--user`: parsing custom gid, gid was set to username
 - `--home` with `--user=`(unknown): only show warning (instead of error) not creating persistent home
 - do not set write permissions on `--home` or `--homedir` folder for different users than $USER or `--user`. (Not x11docker's job)
 - do not set `--read-only` if `--user=`0
 - **bugfix**: chown x11docker_CMD to host user to avoid permission issues in $Sharefolder

## [3.5.8](https://github.com/mviereck/x11docker/blob/fc88928119202eef80d6e3eba788fcd367dbc629/x11docker) - 2017-06-07
 - **bugfix** `--nxagent`: due to update? must set nxagent -ac (=xhost +) temporary to allow xinit
 - `--kwin-native`: always share Wayland (`--sharewayland` `--waylandenv` `--dbus`)
 - **bugfix**: allow `--wm` for `--kwin-xwayland`
 - docker run "`--read-only` `--volume=`/tmp" to restrict container filesystem as read-only (except for `--sudouser`)
 - `--xorg` supports `--rotate`. (Xephyr could, but crashes -> Xephyr bug. Nxagent, Xdummy, Xvfb and Xwayland refuse this.)
 - **new option**` --xhost` STR: to specify "xhost STR". Deprecated: `--xhost`+
 - **new option** `--xvfb` to explicitly use Xvfb and to clearly use Xdummy on `--xdummy`
 - Xdummy script in $Cachefolder forked from https://xpra.org/trac/browser/xpra/trunk/src/scripts/xpra_Xdummy
 - calculate VideoRam in xorg.xdummy.conf (instead of fat hardcoded 256000 kb)

## [3.5.7](https://github.com/mviereck/x11docker/blob/6d8a4cd471f31e7053a10390ab2ca3f90ae80239/x11docker) - 2017-06-28
 - usage info for HTML5 web application setup
 - redirect verbose output to &3 to show it in subshells, too, and to avoid possible collision with read < <()
 - `--env`: set custom environment variables in dockerrc instead of in docker run
 - removed `unix` in $Newxenv for DISPLAY to make xpra ssh setup easier
 - Xdummy-Xwayland: new X server to provide `--gpu` for `--xdummy` based on weston, xwayland and xdotool
 - always enable extension Xtest on `--xdummy` to allow xpra access
 - share X socket to /tmp, create .X11-unix in dockerrc and softlink socket. This avoids writeable X11-unix in $Cachedir.
 - `--setwaylandenv`: env now set in dockerrc instead of docker command

## [3.5.6](https://github.com/mviereck/x11docker/blob/1f6496421f958d5ebf4fcf9abbe6e5d51d19f212/x11docker) - 2017-06-21
 - `--sudouser`: reincarnated option to give sudo without password to container user.
 - docker command one-liner extended to dockerrc. dockerrc creates x11docker_CMD. Can always extract image command without additional password prompt and create some environment.
 - **bugfix** parsing option `--wm`
 - **bugfix**: export $Hostxenv in error() was empty if called in xtermrc
 - create `/tmp/XDG_RUNTIME_DIR` and softlink to wayland socket in container due to some KDE issues (`XDG_RUNTIME_DIR` must be owned by user). Fails with different `--user`
 - create `/tmp/.X11-unix` with 1777 in container to allow new X sockets (especially for startplasmacompositor). Drawback: container writeable folder in cache
 - **bugfix**: avoid pointless warning about `XTEST` if not using xpra
 - shorter sleep in finish()
 - don't search for deprecated `/tmp/x11docker` in checkorphaned()
 - **bugfix** typo preventing start of `--kwin` and `--kwin-native` (`-width` instead of `--width`)
 - warning with hint to use `--xpra-xwayland` if `--scale` is used with `--weston-xwayland`.

## [3.5.5.2](https://github.com/mviereck/x11docker/blob/547aea540aed165fc22def77724caccbd6424c63/x11docker) - 2017-06-10
 - update usage info for `--xpra` and `--xpra-xwayland`

## [3.5.5.1](https://github.com/mviereck/x11docker/blob/1867023c5913a09ed63f98c3d28e9b19f1b332b2/x11docker) - 2017-06-10
 - **bugfix** in `--auto` always choosing `--xorg`

## [3.5.5](https://github.com/mviereck/x11docker/blob/e6021187f59caef2a49b36e02417ec79591c7f1d/x11docker) - 2017-06-09
 - autochoose xpra-desktop if xephyr is missing
 - improved part: check virtual screen size
 - changed dpi calculation depending on xpra mode
 - desktop mode for xpra if `--wm` is given
 - always set `XDG_RUNTIME_DIR=/tmp` as some apps may expect it

## [3.5.4](https://github.com/mviereck/x11docker/blob/c09d6f3022ddf2c0ab6862e0f3db6ab6e9fa9c53/x11docker) - 2017-06-02
 - set rw access for `/dev/dri` ([#12](https://github.com/mviereck/x11docker/issues/12))
 - disable extension `XTEST` if using wm from host (to avoid abuse of context menu of openbox and the like)

## [3.5.3](https://github.com/mviereck/x11docker/blob/870a63b67480caedb7645011666a325dbdbb8ce7/x11docker) - 2017-05-29
 - `--pulseaudio`: get and use IP of container instead of docker0 IP range ([#11](https://github.com/mviereck/x11docker/issues/11)), disabling TCP module on exit
 - changed `--volume` to `--sharedir` to avoid confusion
 - update `usage()`
 - mount $Sharefolder and its content read-only
 - remove X11-unix from $Sharefolder
 - set read-only for `/dev/dri` on `--gpu`
 - `--security-opt=no-new-privileges` added to docker run

## [3.5.2](https://github.com/mviereck/x11docker/blob/d88d32605ece42324f14cf41e54482888ae539c4/x11docker) - 2017-05-22
 - **new option** `--volume` to share host folders

## [3.5.1](https://github.com/mviereck/x11docker/blob/4f1e4d14a904d499445fd479efb37b3c7cd46451/x11docker) - 2017-05-19
 - user creation with `--addgroup video` to support pre-systemd and kdeneon gpu support
 - create `/tmp/.X11-unix` with `1777`

## [3.5.0](https://github.com/mviereck/x11docker/blob/2f354525b3443250c3fe4c18ebfe4a3fc57f5ca0/x11docker) - 2017-05-17
 - avoid Terminal window with `--no-password`
 - `--env`: regard whitespaces, use \n to divide entrys
 - set `mode=preferred` for Weston on tty, ignore $Screensize
 - extension `XINERAMA` disabled as multiple Xephyr outputs cannot handle it well
 - create container home folder `/tmp/fakehome` in x11docker_CMD (avoids ownership problems with wine, and is less messy in /tmp)
 - more failure checks in `installer()`
 - check for `--userns-remap`, disabling it with `--userns=host` if `--home` or `--homedir` are set
 - minor exploit check for DISPLAY XAUTHORITY XDG_RUNTIME_DIR WAYLAND_DISPLAY HOME
 - **new option** `--output-count` to set amount if virtual screens/desktop windows for Weston, Kwin, Xephyr
 - **new option** `--westonini` to specify a custom weston.ini for `--weston` and `--weston-xwayland`
 - **bugfix**: `-s KILL` for weston on finish avoids zombies
 - **new option** `--cachedir`:  specify custom cache folder
 - **new option** `--homedir`: specify host folder to share as home
 - automatically choose trusted or untrusted cookies
 - **new option** `--trusted`: enforce trusted cookies for `--hostdisplay` and `--kwin-native`
 - **deprecated** `--cache`
 - `--cap-default`: Allow docker default capabilities
 - `--orphaned` cleans /tmp/x11docker
 - show docker log in xtermrc if pulling image
 - `docker run `--cap-drop=`ALL` as default
 - **new option**`--user` to set user to use (name or uid, non-existing uids possible. default: host user)
 - reduce `/etc/passwd` and `/etc/group` to container user and groups user and videp only (except root, keeps whole files).
 - creating container user similar to host user with docker run option `--user` and custom /etc/passwd instead of script createuser.
 - **removed** `--hostuser` `--sudouser`, effect of `--hostuser` is default now, `--sudouser` not possible due to `--cap-drop=`ALL
 - `--gpu`: only share `--device=`/dev/dri instead of listing all files in it

## [3.2.1](https://github.com/mviereck/x11docker/blob/7600e599e757398d2e7ca3f53d4567f9286e31bb/x11docker) - 2017-05-05
 - **bugfix**: `--scale` with `--xpra-xwayland` under X without Wayland failed

## [3.2.0](https://github.com/mviereck/x11docker/blob/32a9b75e0a7e6511b85dd2e01353adc77b76bfb9/x11docker) - 2017-05-04
 - **new option** `--scale`: for xpra and weston
 - **new option** `--rotate` for weston
 - **new option** `--dpi` for screen density
 - **bugfix**: checking screensize in Gnome-Wayland failed looking for primary display, window was not roughly maximized
 - **bugfix**: missing `error()` in xinitrc
 - allow MIT-SHM for `--exe`

## [3.1.16](https://github.com/mviereck/x11docker/blob/bab08db10c8b4d360c58ec7c7bb42a6fa6567b69/x11docker) - 2017-05-03
 - **bugfix** `--xpra-wayland` in check for `WAYLAND_DISPLAY`

## [3.1.15](https://github.com/mviereck/x11docker/blob/58536075aec99859ad212f7377724a5b60cb3dd6/x11docker) - 2017-05-02
 - **bugfix** in choosing terminal, replace $Waylandterminal with $Terminal in re-check
 - **bugfix** xtermrc and xinitrc: check if $Dockerpidfile is not empty
 - faster startup for `--xpra-xwayland`, `--weston-xwayland`, `--kwin` and `--kwin-xwayland`
 - code cleanup

## [3.1.14](https://github.com/mviereck/x11docker/blob/af37faddec2642e44a0c586ac9c84694c9989fad/x11docker) - 2017-05-01
 - checkorphaned() uses container names instead of numbers
 - **bugfix** `--exe`: reliable kill $Hostexe, even with `--weston`* and `--kwin`*
 - **bugfix**: remove `:` and `/` from image name in $Containername

## [3.1.13](https://github.com/mviereck/x11docker/blob/e8e428edbb259d1d317a52fb43ee7be25e5b2cf7/x11docker) - 2017-04-30
 - Improved multimonitor support (still missing: multihead)
 - **bugfix**: redirection of stderr wihout cat, avoids broken pipe on ctrl-c in ubuntu and opensuse
 - **bugfix**: removed custom socket in xpra (failed in opensuse)
 - removed $Cidfile at all, cleanup hint in finish() with $Containername
 - avoid root ownership for $Dockerlogfile and $Dockerpidfile

## [3.1.12](https://github.com/mviereck/x11docker/blob/06fc8fc7f4bf2945692c8b38476e76b760bd8877/x11docker) - 2017-04-29
 - clean up confusion with x11docker.log
 - **bugfix**: include `warning()` in xinitrc
 - **bugfix** in xinitrc for `--no-xhost`
 - don't share $Xclientcookie as $Sharefolder is already shared
 - don't use $Cacherootfolder for parsererror
 - hint to use `--sudo` on some systems
 - use `id -g` instead of $Benutzer for group name
 - add lsb-release -ds to verbose output

## [3.1.11](https://github.com/mviereck/x11docker/blob/0248fd878cdb1b1cacd42758f883ea4dc75d0c27/x11docker) - 2017-04-29
 - disabled $Cidfile as not important and due to [#10](https://github.com/mviereck/x11docker/issues/10)

## [3.1.10](https://github.com/mviereck/x11docker/blob/969494282073ef5098820325472ac02872c7c5f6/x11docker) - 2017-04-28
 - **bugfix**: check for xenial instead of 16.04/xvfb
 - **regression** fix: set XPRA_XSHM=0 on Shareipc=no
 - disable `--desktop-scaling` in xpra, not supported before xpra v1.x

## [3.1.9](https://github.com/mviereck/x11docker/blob/c1eb6a60fab62bc7a10cb97020e36bf9bdb8a8ed/x11docker) - 2017-04-27
 - don't create Cacherootfolder in variable definitions
 - check for Xvfb on Ubuntu 16.04

## [3.1.8](https://github.com/mviereck/x11docker/blob/3f4a54c01d340293a8c831b0a0757c2a97326aa2/x11docker) - 2017-04-25
 - Add advice for `--xorg` how to setup xserver-xorg-legacy

## [3.1.7](https://github.com/mviereck/x11docker/blob/85bb3e72ae449b2057f93390a2bbfdb86a89286a/x11docker) - 2017-04-25
 - `--xpra` and `--xdummy` now use Xvfb if installed. Compare #9, Xdummy cannot be used on Ubuntu 16.04 due to xorg.conf location
 - set $Windowmanager in auto choosing X server if switching to desktop windows

## [3.1.6](https://github.com/mviereck/x11docker/blob/2623286e141ddb4aec6a7b5162cafbb19b5c6e6c/x11docker) - 2017-04-21
 - **bugfix** 2 `--nxagent`: don't close nxagent on every call of nxclient

## [3.1.5](https://github.com/mviereck/x11docker/blob/a13bd270d1146ad6fedcfbb1c2ccf1583531e0d5/x11docker) - 2017-04-20
 - **bugfix** `--nxagent`: don't close nxagent on every call of nxclient

## [3.1.4](https://github.com/mviereck/x11docker/blob/b2641dbd874e8df51762a31c6a6d2e5344bd9efa/x11docker) - 2017-04-19
 - `--nxagent` supports untrusted cookies
 - **bugfix**: don't set dpi if xdpyinfo fails

## [3.1.3](https://github.com/mviereck/x11docker/blob/06e021a0dae63eef02661420942b8430f7dcca42/x11docker) - 2017-04-18
 - `--nxagent` cookie workaround as it ignores XAUTHORITY on option -auth
 - `--nxagent` workaround to terminate on pressing window close button -> fake nxclient
 - **bugfix** typo in finish() looking for docker pid

## [3.1.2](https://github.com/mviereck/x11docker/blob/289017045514d966a5f378b4649fbd2606a03c9a/x11docker) - 2017-04-18
 - `--nxagent` sets right keyboard layout, thanks to Ulrich!

## [3.1.1](https://github.com/mviereck/x11docker/blob/dbb3c60d525c372906e5f75fb464f8cd0f466a87/x11docker) - 2017-04-18
 - `--nxagent` now supports `--size`, `--fullscreen` and `--clipboard`, thanks to Ulrich Sibiller from Arctica!
 - check dpi from host and set this to new X server
 - xpra xmessage to be patient
 - disabled keyboard adjusting for `--nxagent`

## [3.1.0](https://github.com/mviereck/x11docker/blob/60b704f068fe99e64b873c8fe4fc0ae6da35ab87/x11docker) - 2017-04-16
 - **new option** `--nxagent` for X server `nxagent`

## [3.0.0](https://github.com/mviereck/x11docker/blob/a62b2f47472ab60b98d2a2471135e0e33fa46757/x11docker) - 2017-04-15
 - Wayland support.
 - code cleanup
 - second stderr `&3` to show warnings and errors also from within xinitrc and xtermrc
 - error messages on docker startup failure in xtermrc
 - `--xhost` changed to `--xhost+`, affects new X server only
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
 - use prefix `unix` for `DISPLAY` to disable `MIT_SHM` instead using other environment variables
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
