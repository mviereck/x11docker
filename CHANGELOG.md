# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html) since version 4.0.

Project website: https://github.com/mviereck/x11docker

## [Unreleased]
### Fixed
 - `--tty` failed with `--xc`. Fix: disable `--xc`.
   [(464)](https://github.com/mviereck/x11docker/issues/464)
 - `--xonly`: run socat unprivileged to make the unix socket accessible.
   [(466)](https://github.com/mviereck/x11docker/issues/466)

## [7.4.2](https://github.com/mviereck/x11docker/releases/tag/v7.4.2) - 2022-08-7
### Fixed
 - `--xpra*`: Fix for Wayland+X11 on host. Use Wayland for xpra client.
   Caused startup failure along with `--xc`.
   [(462)](https://github.com/mviereck/x11docker/issues/462)
 - `--hostwayland`: Do not use container of `x11docker/xserver` (option `--xc`).
 - `--fullscreen`: Enable desktop mode.
 - Do not set `--hostname` to avoid `--network` issues.
   [(463)](https://github.com/mviereck/x11docker/issues/463)
 - `--runtime=sysbox`: support `--gpu=virgl` again.
### Deprecated
 - `--runtime=kata-runtime`: recent kata v2.x does not provide `kata-runtime`.

## [7.4.1](https://github.com/mviereck/x11docker/releases/tag/v7.4.1) - 2022-08-03
### Changed
 - `--update`, `--update-master`: New optional argument `diff` to show
   the difference between installed and new version without installing it.
   [(460)](https://github.com/mviereck/x11docker/issues/460)
### Fixed
 - `--xpra*`: Fix check for `xinitrc is ready`.
   [(462)](https://github.com/mviereck/x11docker/issues/462)

## [7.4.0](https://github.com/mviereck/x11docker/releases/tag/v7.4.0) - 2022-07-28
### Added
 - `--xauth [=yes|trusted|untrusted|no]`: New option to configure X cookie.
 - `--printcheck`: New option to show X server dependency check messages.
### Changed
 - `--xoverip`: New optional arguments `yes|no|socat|listentcp`.
   `socat` allows X over TCP with `--hostdisplay` and `Xwayland` related options.
 - `--gpu`: changed X dependency checks.
 - `--hostdisplay --gpu --xc=no`: Do not enable `--ipc=host` automatically.
### Fixed
 - `--user`: Fix in setup of `/etc/gshadow`.
 - `--xc`: Provide X unix socket to host with `socat` instead of `ln`.
   GTK3 application failed to access X through a soft link.
 - `--shell --no-setup`: Set environment variable `SHELL`.
   [(457)](https://github.com/mviereck/x11docker/issues/457)
 - `--no-setup`: Share init binary from host instead of using `--init`.
   [(457)](https://github.com/mviereck/x11docker/issues/457)
### Deprecated
 - `--no-auth`: Use `--xauth=no` instead.
 - `--enforce-i`: Create group `weston-launch` instead and add your user to it.

## [7.3.2](https://github.com/mviereck/x11docker/releases/tag/v7.3.2) - 2022-07-08
### Added
 - `--clipboard=yes`: Limited support for Wayland clients.
   (Host X to container Wayland only.)
### Fixed
 - `--xc`: Don't add groups `video` or `render` if they do not exist.
   [(454)](https://github.com/mviereck/x11docker/issues/454)

## [7.3.1](https://github.com/mviereck/x11docker/releases/tag/v7.3.1) - 2022-07-01 
### Added
 - `--xc`: Support `--kwin`, nested and on console.
 - `--xc`: Support `--xpra-xwayland`.
### Fixed
 - `--xc`: Add missing code for `--xvfb`.
   [(452)](https://github.com/mviereck/x11docker/issues/452)
 - `--xc`: Provide `--hostdisplay` dependencies.

## [7.3.0](https://github.com/mviereck/x11docker/releases/tag/v7.3.0) - 2022-06-27 
### Added
 - `--clipboard`: New arguments `oneway`, `altv` and `superv`
   to restrict container access to host clipboard content.
   [(#440)](https://github.com/mviereck/x11docker/issues/440)
   [(#379)](https://github.com/mviereck/x11docker/issues/379)
   [(#152)](https://github.com/mviereck/x11docker/issues/152)
 - `--checkwindow [=ARG]`: New option to run container as long as X windows
   are open or to stop them as soon as keyword ARG disappears from xwininfo.
   [(#68)](https://github.com/mviereck/x11docker/issues/68)
### Fixed
 - `*-xwayland`: Startup fix for `--xc=no` / running on host.
 - `--xpra*-xwayland`: Use `xdotool` from X container if available.

## [7.2.0](https://github.com/mviereck/x11docker/releases/tag/v7.2.0) - 2022-06-21 
### Added
 - `--rootless [=yes|no]`: New option to enable rootless backend.
 - `--xc`: Support of Weston in container on console, too.
   [(#40)](https://github.com/mviereck/x11docker/issues/40)
   [(#444)](https://github.com/mviereck/x11docker/issues/444)
 - `--xc --xorg`: Support of Xorg in container.
   [(#7)](https://github.com/mviereck/x11docker/issues/7)
   [(#40)](https://github.com/mviereck/x11docker/issues/40)
   [(#221)](https://github.com/mviereck/x11docker/issues/221)
   [(#258)](https://github.com/mviereck/x11docker/issues/258)
   [(#444)](https://github.com/mviereck/x11docker/issues/444)
### Changed
 - `--clipboard`: Added support for basic graphics clips and
   middle mouse click selection for `--xephyr` and the like.
   [(#428)](https://github.com/mviereck/x11docker/issues/428)
 - `--vt`: enforces start on console.
 - `--xc`: No X tool dependencies on host.
### Fixed
 - `--gpu`: Support VA-API, VDPAU (video acceleration) and variable `DRI_PRIME`.
   [(#443)](https://github.com/mviereck/x11docker/issues/443)
 - `--xpra`: Fix for `--xoverip`.
   [(#428)](https://github.com/mviereck/x11docker/issues/428)
 - `--nxagent`: Fixes for `--keymap`.
   [(#208)](https://github.com/mviereck/x11docker/issues/208)
 - `--update*`, `--install`, `--cleanup`: Fix error messages, exit once done.
   [(#435)](https://github.com/mviereck/x11docker/issues/435)
 - `--hostuser`: Fixes for `--backend=host|proot`
   [(#437)](https://github.com/mviereck/x11docker/issues/437)
 - `--xc`: Lots of minor fixes.

## [7.1.4](https://github.com/mviereck/x11docker/releases/tag/v7.1.4) - 2022-03-27 
### Added
 - `--xc=BACKEND`: Optional argument to choose backend for X container.
### Fixed
 - `--build`, `--cleanup`: Fix backend check (regression).
   [(#423)](https://github.com/mviereck/x11docker/issues/423)
 - `--scale`: Fix for `--xpra*` (regression).
 - `--share`: MS Windows: fix parsing of partition pathes like `/mnt/c`.
   [(#424)](https://github.com/mviereck/x11docker/issues/424)
 - `--xc`: do not use on console (affected `--weston-*`).

## [7.1.3](https://github.com/mviereck/x11docker/releases/tag/v7.1.3) - 2022-03-02 
### Fixed
 - `-g, --gpu`: Fix parsing for `-g`(no optional argument).
   [(#419)](https://github.com/mviereck/x11docker/issues/419)
 - `--backend=proot`: fix `--interactive`.

## [7.1.2](https://github.com/mviereck/x11docker/releases/tag/v7.1.2) - 2022-03-01
### Fixed
 - `--share`: Mount Docker volumes (regression fix).
   [(#419)](https://github.com/mviereck/x11docker/issues/419)

## [7.1.1](https://github.com/mviereck/x11docker/releases/tag/v7.1.1) - 2022-02-28
### Added
 - `--gpu=virgl`: Experimental GPU access with `virgl_test_server`.
   Currently only along with option `--xc`.
   Allows acceleration for Xephyr, nxagent, Xvfb etc.
 - `--gpu=iglx`: Enable indirect rendering (`--xorg` only). Replaces `--iglx`.
 - `--pulseaudio=host`: New argument to share pulseaudio host unix socket.
   [(#418)](https://github.com/mviereck/x11docker/issues/418)
### Fixed
 - `--init=systemd`: Changed login and service setup to support arch containers.
   [(#417)](https://github.com/mviereck/x11docker/issues/417)
 - `--user=RETAIN`: Some fixes.
   [(#417)](https://github.com/mviereck/x11docker/issues/417)
 - `--clipboard`: Fix for `--xc`.
### Deprecated
 - `--iglx`: Use `--gpu=iglx` instead.

## [7.1.0](https://github.com/mviereck/x11docker/releases/tag/v7.1.0) - 2022-02-12
### Added
 - `--backend=proot`: Use a rootfs on host with `proot` instead of a container.
   [(#224)](https://github.com/mviereck/x11docker/issues/224)
 - `--backend=host`: Run application from host. Replaces `-e, --exe`.
 - `--ipc [=ARG]`: Replaces former `--hostipc`.
 - `--pulseaudio=host`: New argument to share host pulseaudio socket.
   [(#418)](https://github.com/mviereck/x11docker/issues/418)
### Changed
 - `--hostdisplay`: Use `XlibNoSHM.so` from `x11docker/xserver` if available.
   This avoids the need of `--ipc=host`.
 - `--backend`: Do not use fallbacks if backend is not found.
### Fixed
 - `--init=systemd`: support cgroupv2 unified hierarchy.
   [(#349)](https://github.com/mviereck/x11docker/issues/349)
 - `--backend=nerdctl`: Some fixes.
 - `--backend=host --xoverip`: No error without `--network`.
 - user/group setup fixes.
 - `xpra` pid check fix.
 - Container startup check fix.
 - Several minor fixes I forgot to note here.
### Deprecated
 - `-e, --exe`: Use `--backend=host` instead.
 - `--hostipc`: Use `--ipc [=ARG]` instead.

## [7.0.1](https://github.com/mviereck/x11docker/releases/tag/v7.0.1) - 2022-01-20
### Fixed
 - `--share=$HOME`: Fix container path.
 - Fix some X tool dependency checks.

## [7.0.0](https://github.com/mviereck/x11docker/releases/tag/v7.0.0) - 2022-01-20
### Added
 - `--xc`: New option to run X server in container of `x11docker/xserver`.
   Most X server and Wayland options are supported except those
   running on console (notable `--xorg`).
 - `--xpra2`: New X server option to run xpra server in container (`--xc`),
   but xpra client on host.
 - `--xpra2-xwayland`: New X server option to run accelerated xpra server
   in container (`--xc`), but xpra client on host.
 - Configuration of x11docker with `default` preset file. Compare `--preset`.
   Allows to specify options that will be applied in all x11docker sessions.
   Useful to declare a default `--backend` and/or `--runtime`.
 - `--runtime=sysbox-runc`: Experimental support of sysbox runtime.
 - `--printenv [=FILE]`: Replaces `--showenv`.
 - `--printid [=FILE]`: Replaces `--showid`.
 - `--printinfofile [=FILE]`: Replaces `--showinfofile`.
 - `--printpid1 [=FILE]`: Replaces `--showpid1`.
### Changed
 - `--network=none` is default now. Use `-I, --network` to allow internet access.
 - `--user=root`: Needs `--sudouser` or `--cap-default` for usual root privileges.
 - `--xorg`: Not used as fallback if not on tty.
 - `--xvfb`: `--printenv` is not set automatically.
 - `--xvfb`: No ugly GPU support anymore.
 - `--xpra`: No Xdummy support anymore. Needs `Xfvb`.
 - `--vt [=N]`: Argument N is optional now.
   [(#404)](https://github.com/mviereck/x11docker/issues/404)
 - `create_dockerrc()`: removed, components integrated in main script.
### Fixed
 - `--gpu`: Set environment variables of `prime-run`.
   [(#394)](https://github.com/mviereck/x11docker/issues/394)
 - NVIDIA: Wayland/Xwayland support since driver>=470.x and Xwayland>=21.1.2
   [(#394)](https://github.com/mviereck/x11docker/issues/394)
 - `--user=RETAIN`: Fix socket sharing bug caused by `convertpath()`. 
   [(#394)](https://github.com/mviereck/x11docker/issues/394)
### Deprecated
 - `--kwin-xwayland`: use `--weston-xwayland` instead.
 - `--showenv`: use `--printenv` instead.
 - `--showid`: use `--printid` instead.
 - `--showinfofile`: use `--printinfofile` instead.
 - `--showpid1`: use `--printpid1` instead.
### Removed
 - `x11docker-gui`: Removed due to outdated and unmaintained `kaptain`.
 - `--pull`: Please pull missing images yourself.
 - `--pw`: Run x11docker directly as root or with sudo if needed.
 - `--xdummy:` Use `--xvfb` instead.

## [6.10.0](https://github.com/mviereck/x11docker/releases/tag/v6.10.0) - 2021-10-06
### Added
 - `--build`: New option to build an image from x11docker repository.
 - `--snap`: New option to enable fallback mode to support Docker in snap.
   [(#375)](https://github.com/mviereck/x11docker/issues/375)
### Changed
 - `--backend=nerdctl`: Disallow `--home` in rootless mode.
 - `--backend`: Allow `--share` in all rootless modes.
 - Use `python` to parse json output of `inspect`.
 - `--update, --update-master, --remove`: detect and use current installation 
   directory.
   [(#371)](https://github.com/mviereck/x11docker/issues/371)
### Fixed
 - Return exit code of container command (regression fix).
   [(#383)](https://github.com/mviereck/x11docker/issues/383)
 - `--share` without `--home`: If path is in `HOME`, change container path and create softlink.
   Otherwise `HOME` might not be writeable.
 - `--fallback`: Add missing switch in option parsing.
   [(#372)](https://github.com/mviereck/x11docker/issues/372)
 - `--interactive`: Fix output redirection.
   [(#364)](https://github.com/mviereck/x11docker/issues/364)
### Removed
 - `--wm=container`: drop containerized window manager support. 

## [6.9.0](https://github.com/mviereck/x11docker/releases/tag/v6.9.0) - 2021-06-02
### Added
 - `--backend=BACKEND`: Experimental option to choose a container backend.
   Currently supported: `docker`, `podman` and `nerdctl`.
   [(#255)](https://github.com/mviereck/x11docker/issues/255)
   [(#357)](https://github.com/mviereck/x11docker/issues/357)
 - Support of rootless docker.
   [(#327)](https://github.com/mviereck/x11docker/issues/327)
 - `--composite`: New option to enable or disable X extension Composite.
   Can help to fix issues with `--nxagent`.
   [(#345)](https://github.com/mviereck/x11docker/issues/345)
 - `--no-setup`: Disable x11docker setup in container. (Formerly experimental.)
### Changed
 - `--pw [=FRONTEND]`: Argument `FRONTEND` is optional now to allow easy
   switch to rootful nerdctl or podman. Setting `FRONTEND` requires `=`.
 - `--xhost [=STR]`: Argument `STR` is optional now. If empty, set to
   `+SI:localuser:$USER`. Setting `STR` requires `=`.
### Fixed
 - `x11docker-gui`: Fixed `--share` bug. Add several missing options.
   [(#358)](https://github.com/mviereck/x11docker/issues/358)
 - `--init=s6-overlay`: Use `--tmpfs /run:exec`
   [(#340)](https://github.com/mviereck/x11docker/issues/340)
 - `containerrootrc`: Don't run `docker exec --privileged` for container root
   setup to avoid possible abuse by corrupted core utils.
 - `--limit`: Change free memory check.
   [(#360)](https://github.com/mviereck/x11docker/issues/360)
### Deprecated
 - `--podman`: Use `--backend=podman` instead. (Formerly experimental)

## [6.8.0](https://github.com/mviereck/x11docker/releases/tag/v6.8.0) - 2021-04-08
### Added
 - `--iglx`: Use indirect rendering for OpenGL.
 - `--password`: New option to set a container user password.
   [(#334)](https://github.com/mviereck/x11docker/issues/334)
### Changed
 - `--sudouser`: Allow optional argument `nopasswd` for sudo without password.
   [(#337)](https://github.com/mviereck/x11docker/issues/337)
### Fixed
 - `--size`: Regard if no monitor is connected.
   [(#336)](https://github.com/mviereck/x11docker/issues/336)

## [6.7.0](https://github.com/mviereck/x11docker/releases/tag/v6.7.0) - 2021-02-28
### Added
 - `-I, --network`: New option to set network mode.
   `-I` will be mandatory in future to allow internet access.
   Replaces `--no-internet` and `--hostnet`.
 - `--runasuser`: New option to add (background) commands in 
   `cmdrc`. Intended to run e.g. `fcitx` keyboard input daemon.
   [(#269)](https://github.com/mviereck/x11docker/issues/269)
   [(x11docker/deepin:#2)](https://github.com/mviereck/dockerfile-x11docker-deepin/issues/2)
 - `--fallback=no`: New option to deny fallbacks for failing options.
 - `--no-setup`: Experimental option to disable x11docker setup in container.
 - `--podman`: Experimental `podman` support.
   [(#255)](https://github.com/mviereck/x11docker/issues/255)
 - `--xopt`: Experimental option to add custom X server options.
   [(#296)](https://github.com/mviereck/x11docker/issues/296)
### Changed
 - `--lang`: Allow multiple times to generate more than one locale.
### Fixed
 - `--home=~/DIR`: Replace `~` with `$HOME`.
 - `--hostnet`: set host IP to 127.0.0.1 for options like `--pulseaudio=tcp`.
 - `--pulseaudio`: set to TCP if pulseaudio runs as system daemon.
   [(#266)](https://github.com/mviereck/x11docker/issues/266)
 - Allow `docker logs` to grab container output, too. 
   [(#254)](https://github.com/mviereck/x11docker/issues/254)
 - `--xpra`: version check failed in few circumstances.
   [(#287)](https://github.com/mviereck/x11docker/issues/287)
 - `--gpu`: share `/dev/nvmap` and `/dev/nvhost*` if present.
   [(#290)](https://github.com/mviereck/x11docker/issues/290)
 - `--preset`: Parse with `eval` to catch strings.
   [(x11docker/deepin:#20)](https://github.com/mviereck/dockerfile-x11docker-deepin/issues/20)
 - MS Windows: IP check / no dockerNAT interface anymore.
   [(runx:#6)](https://github.com/mviereck/runx/issues/6)
   [(#325)](https://github.com/mviereck/x11docker/issues/325)
### Deprecated
 - `--hostnet`: Use `--network=host` instead.
 - `--no-internet`: Use `--network=none` instead.

## [6.6.2](https://github.com/mviereck/x11docker/releases/tag/v6.6.2) - 2020-05-19
### Added
 - `--home=VOLUME`, `--share=VOLUME`: Support of docker volumes.
   [ehough/docker-kodi#33](https://github.com/ehough/docker-kodi/issues/33)
### Fixed
 - `--update`: Fix `sed` error in changelog excerpt.
   [(#236)](https://github.com/mviereck/x11docker/issues/236)
 - `--webcam`: Add container user to group video.
   [(#241)](https://github.com/mviereck/x11docker/issues/241)
### Deprecated
 - `--sharessh`: Please use (directly or with help of option `--preset`):
   `--share $(dirname $SSH_AUTH_SOCK) --env SSH_AUTH_SOCK="$SSH_AUTH_SOCK"`

## [6.6.1](https://github.com/mviereck/x11docker/releases/tag/v6.6.1) - 2020-03-19
### Fixed
 - `--runx`: Fix `XAUTHORITY` copy bug. 
   [(#219)](https://github.com/mviereck/x11docker/issues/219)

## [6.6.0](https://github.com/mviereck/x11docker/releases/tag/v6.6.0) - 2020-03-19
### Added
 - Experimental WSL2 support. See also new option `--mobyvm`.
   [(#214)](https://github.com/mviereck/x11docker/issues/214)
 - `--preset`: New option to read files with predefined option sets.
   [(#218)](https://github.com/mviereck/x11docker/issues/218)
 - `--mobyvm`: New option to use MobyVM in WSL2. 
   Default for WSL2 is native Linux docker.
 - `--shell`: New option to specify preferred user shell.
   [(#26)](https://github.com/mviereck/x11docker/issues/26)
   [(#211)](https://github.com/mviereck/x11docker/issues/211)
### Changed
 - `--nxagent --keymap=clone`: Clone xkb settings from host in nxagent.
   [(#208)](https://github.com/mviereck/x11docker/issues/208)
 - `--printer`: Share entire `run/cups`, not only socket `run/cups/cups.sock`.
   [(#222)](https://github.com/mviereck/x11docker/issues/222)
 - `--wm`: Improved checks and fallback handling. 
   Disabled context menu for host window manager `--wm=openbox`.
### Fixed
 - snap/snappy: More general detection.
   [(#223)](https://github.com/mviereck/x11docker/issues/223)
 - `--workdir`: Fixed parsing error. 
   [(#232)](https://github.com/mviereck/x11docker/issues/232)


## [6.5.0](https://github.com/mviereck/x11docker/releases/tag/v6.5.0) - 2019-12-22
### Added
 - `--xoverip`: New option to enforce X over TCP/IP. For special setups only.
   [(#201)](https://github.com/mviereck/x11docker/issues/201)
### Changed
 - Run `containerrootrc` with `--privileged`. Does not affect desired 
   container command in `containerrc`. Allows less privileges with NVIDIA
   driver installation and avoids issues like in
   [(#196)](https://github.com/mviereck/x11docker/issues/196)
 - `--xephyr`: Disabled Xephyr option `-glamor`.
   [(#196)](https://github.com/mviereck/x11docker/issues/196)
 - `--runtime`: Added `oci` to list of known runtimes.
   [(#205)](https://github.com/mviereck/x11docker/issues/205)
 - `TODO.md` outsourced from x11docker script.
### Fixed
 - Support `snap` installation of Docker.
   [(#191)](https://github.com/mviereck/x11docker/issues/191)
 - `--gpu`: NVIDIA driver installation failed with `--cap-default`.
   [(#198)](https://github.com/mviereck/x11docker/issues/198)

## [6.4.0](https://github.com/mviereck/x11docker/releases/tag/v6.4.0) - 2019-11-14
### Added
 - `--xtest [=yes|no]`: New option to enable or disable X extension XTEST.
   Can be needed for custom access with xpra.
   [(#190)](https://github.com/mviereck/x11docker/issues/190)
### Fixed
 - Do not set `tini` option `-s`. Avoids issue with `catatonit`.
   [(#189)](https://github.com/mviereck/x11docker/issues/189)
 - Exchange static file descriptor numbers with dynamic ones.
   Hopefully fixes an odd issue where bash eats up some lines of code on exit.
 - docker-for-win: Do not use cache path within WSL subsystem.
   [(#165)](https://github.com/mviereck/x11docker/issues/165)
 - `--xpra`: Check for validity of `--opengl=noprobe`.
 - `--xpra`: Drop support on MS Windows / WSL.
 - Use window manager in auto mode for `--xephyr` and similars.
 - Fix `waitforlogentry()` error if pulling image.
   [(#193)](https://github.com/mviereck/x11docker/issues/193)

## [6.3.0](https://github.com/mviereck/x11docker/releases/tag/v6.3.0) - 2019-10-04
### Added
 - `--showinfofile`: New option: Echo path to internal x11docker info storage
   file. Can be parsed for informations like container IP and name.
 - `--newprivileges [=yes|no]`: New option to set or unset docker run
   option `--security-opt=no-new-privileges`.
### Changed
 - Return exit code of container command. x11docker errors return code `64`.
 - `--dbus`: Optional argument `=system` to run a DBus system daemon.
   Similar to previous `--dbus-system`. For experimental setups only.
 - `--dbus-system`: Already deprecated in v6.2.0. 
   New fallback: `--dbus=system --cap-default`.
 - `--exe`: Run with `tini`/`docker-init` if available.
 - `--showenv`: Does not contain `X11DOCKER_CACHE` anymore.
   Have a look at `--showinfofile` instead.
 - `--weston`, `--kwin`, `--hostwayland`: Always set all Wayland environment
   variables and run with DBus user daemon. Previously needed `--wayland`.
 - `--xdummy --gpu`/`--xvfb --gpu`: Supported only in host X, 
   no longer on console or on Wayland.
 - `--xephyr`: enabled `-glamor`.
 - Wait before starting X until possible password prompt is ready.
 - Lots of code cleanup.
### Fixed
 - Enable X extension `X-Resource` to allow Gnome 3 in container.
   [(#16)](https://github.com/mviereck/x11docker/issues/16)
 - Avoid double IP address while checking `docker0` interface.
   [(#182)](https://github.com/mviereck/x11docker/issues/182)
 - Avoid possible race condition of display number on simultaneous starts.

## [6.2.0](https://github.com/mviereck/x11docker/releases/tag/v6.2.0) - 2019-08-17
### Added
 - `--enforce-i`: Run x11docker in interactive bash mode. Rather special option
   to provide a fix for special issues, e.g. running `weston-launch`
   on void linux that needs an interactive tty. Not recommended in general.
   [(#166)](https://github.com/mviereck/x11docker/issues/166)
   [(#176)](https://github.com/mviereck/x11docker/issues/176)
 - `-F`: Shortcut for `--xfishtank`.
 - `-l`: Shortcut for `--lang`.
 - `-P`: Shortcut for `--printer`.
 - `-V`: Same as `-v, --verbose`, but with colored output. 
   Useful e.g. with `--init=systemd`.
### Changed
 - Short options do not accept optional arguments. Affects `-l -m -p -P -w -v`.
 - `-m`: Does not accept optional argument `=PATH`. Use `--home=PATH` instead.
 - `-v, --verbose`: Does not accept argument `=c` anymore. Use `-V` instead.
 - `-w`: Does not accept argument anymore. Use `--wm=ARG` instead.
 - `--xpra`: Runs on Wayland since xpra v3.0-r23305.
### Deprecated
 - `--dbus-system`: Use one of `--init=systemd|openrc|runit|sysvinit` instead.
   Current fallback: `--init=systemd`.
### Fixed
 - `--workdir`: Has been overwritten / no effect.
 - Fixed `tty` check if not running in a terminal.
   [(#176)](https://github.com/mviereck/x11docker/issues/176)
   [(#177)](https://github.com/mviereck/x11docker/issues/177)
 
## [6.1.1](https://github.com/mviereck/x11docker/releases/tag/v6.1.1) - 2019-07-31
### Fixed
 - `--gpu`: Add user to group `render`.

## [6.1.0](https://github.com/mviereck/x11docker/releases/tag/v6.1.0) - 2019-07-30
### Added
 - `--clean-xhost`: Disable xhost access policies on host display.
 - `--no-xhost`: Reintroduced for backwards compatibility. Deprecated.
   Use `--clean-xhost`instead.
 - `--systemd`: Reintroduced for backwards compatibility. Deprecated.
   Use `--init=systemd` instead.
### Changed
 - `--home`: Allow optional host folder DIR with `--home=DIR`.
 - `--printer`: Allow optional argument `tcp|socket`.
   Allows CUPS printing for `--runtime=kata-runtime`.
 - `--share`: Don't share `--volume` along with `--device`.
   Has been a workaround for an old Docker bug setting wrong file ownerships.
   [#24](https://github.com/mviereck/x11docker/pull/24)
### Deprecated
 - `--homedir=DIR`: Use `--home=DIR` instead.
 - `--systemd`: Use `--init=systemd` instead.
 - `--no-xhost`: Use `--clean-xhost` instead.
### Fixed
 - `--xpra --clipboard`: Fix not using xpra option `--xsettings=no`.
   [xpra ticket #2342](https://xpra.org/trac/ticket/2342)
 - Copy `/etc/skel` into empty `HOME`.

## [6.0.0](https://github.com/mviereck/x11docker/releases/tag/v6.0.0) - 2019-07-08
### Changed
 - `--wm`: Use image `x11docker/openbox` to provide a window manager.
   Set `--wm=host` or `--wm=COMMAND`to use a host window manager.
   Set `--wm=IMAGE` to run local image IMAGE as window manager.
   [(#158)](https://github.com/mviereck/x11docker/issues/158)
### Removed
 - `--vcxsrv`: X server on Windows. Use `runx` on MS Windows instead
   to provide X for x11docker:  https://github.com/mviereck/runx
   [(#165)](https://github.com/mviereck/x11docker/issues/165)
 - `--pulseaudio` on MS Windows is no longer supported.
 - `--ps`, `--trusted`, `--untrusted`, `--no-xtest`, `--no-xhost`,
    `--silent`, `--stderr`, `--stdout`, `--nothing`, `--cachedir`, `--starter`,
   `--tini`, `--systemd`, `--openrc`, `--runit`, `--sysvinit`, `--no-init`,
   `--sys-admin`: Removed; search this changelog for possible replacements 
   noted in 'Deprecated' chapters.
### Fixed
 - `--gpu` with automated NVIDIA driver installation:
   Don't set `--security-opt=no-new-privileges`.
   [(#162)](https://github.com/mviereck/x11docker/issues/162)
 - `--hostwayland`: Fix socket name issue.
   [(ehough/kodi #26)](https://github.com/ehough/docker-kodi/issues/26)
 - WSL: Add Windows System32 path to `PATH`. Can miss with `sudo`.
   [(#153)](https://github.com/mviereck/x11docker/issues/153)
 - `--update`, `--update-master`: Support more common `tar` beside `unzip`.
   [(#115)](https://github.com/mviereck/x11docker/issues/115)
 - `--xwin`: Use random display number.
   [(#165)](https://github.com/mviereck/x11docker/issues/165)
 - `--xpra`: Check for option availability to support multiple versions.
   Significantly faster startup since xpra v3.0-r23066.
   [(#167)](https://github.com/mviereck/x11docker/issues/167)
   [(#165)](https://github.com/mviereck/x11docker/issues/167)
  

## [5.6.0](https://github.com/mviereck/x11docker/releases/tag/v5.6.0) - 2019-05-02
### Added
 - `--runtime=RUNTIME`: New option to specify container runtime. 
   Known runtimes: `runc` (docker default), `crun`, `nvidia` and `kata-runtime`.
   [(#138)](https://github.com/mviereck/x11docker/issues/138)
 - `--share=PATH`: Share file or folder. Replaces `--sharedir`. 
   Works for device files in `/dev`, too. Shares targets of symlinks, too.
### Deprecated
 - `--sharedir`: Use `--share` instead.
 - `--no-xhost`: No replacement.
 - `--sys-admin`: No replacement.
### Fixed
 - `--clipboard`: Bugfix for `--xephyr` and some other desktop mode X servers.
   [(#152)](https://github.com/mviereck/x11docker/issues/152)
 - `--dbus-system`: Fixed startup failure with user switching.
 - `--init=sysvinit|runit|openrc`: Always create service to start system DBus.
 - `elogind` support for debian buster containers. Partial support for Void.
 - `docker commit`: Throw error if running a recursive image command
   created with `docker commit` from an x11docker container.
   [(#146)](https://github.com/mviereck/x11docker/issues/146)

## [5.5.2](https://github.com/mviereck/x11docker/releases/tag/v5.5.2) - 2019-04-08
### Added
 - `--init=s6-overlay`: Support of init system `s6` as given by `s6-overlay`.
   [(#136)](https://github.com/mviereck/x11docker/issues/136)
### Changed
 - `x11docker` without an option: show `x11docker --help` instead of running
   an empty X server.
### Fixed
 - `--init=systemd|openrc|runit`: fixes for several container systems.
 - `--dbus-system`: Regression fix for service file check.
 - `--exe`: Regard possible `--` in command. Command before it has been
   dropped errately as invalid `DOCKER_RUN_OPTIONS` before.
 - `--tty`: Workaround: Set environment variables `LINES` and `COLUMNS` to 
   current terminal size. Only needed without `--interactive`.
   [Docker bug ticket #33794](https://github.com/moby/moby/issues/33794)
 - `--init=tini`: Support of native docker-init on docker-for-win.
 - Check for availability of `realpath`.
 - `--kwin`,`--kwin-xwayland`: Check for option `--windowed`.
   [(#144)](https://github.com/mviereck/x11docker/issues/144)

## [5.5.1](https://github.com/mviereck/x11docker/releases/tag/v5.5.1) - 2019-03-18
### Deprecated
 - `--ps`: Preserved cache and container. No replacement.
### Changed
 - `--lang[=LOCALE]`: Argument LOCALE is optional now. Note that `=` is 
   mandatory now. Use `--lang=ru` instead of `--lang ru`.
   `--lang` without an argument sets `$LANG` from host.
### Fixed
 - Fix for host user check after multiple `su`.
 - `--entrypoint env` instead of `--entrypoint /usr/bin/env`.
   Some systems have `/bin/env` instead.

## [5.5.0](https://github.com/mviereck/x11docker/releases/tag/v5.5.0) - 2019-03-06
### Added
 - `--init=tini|systemd|sysvinit|openrc|runit|none`: New option to specify
   or disable init system / PID 1 in container. Replaces singular options.
### Deprecated
 - `--tini`: Use `--init=tini` instead.
 - `--systemd`: Use `--init=systemd` instead.
 - `--sysvinit`: Use `--init=sysvinit` instead.
 - `--openrc`: Use `--init=openrc` instead.
 - `--runit`: Use `--init=runit` instead.
 - `--no-init`: Use `--init=none` instead.
### Changed
 - `--wm[=COMMAND]`: Argument `COMMAND` is optional now. Note that `=` is 
   mandatory now. Use `--wm=openbox` instead of `--wm openbox`.
   `--wm` without an argument autodetects a host window manager.
### Fixed
 - Execute `containerrootrc` in `/tmp` of container to circumvent possible
   issues with access `700` of `~/.cache` on host.
   [(#131)](https://github.com/mviereck/x11docker/issues/131)
 - Check repeatedly for PID1 of container to avoid race condition on slow systems.
   [(#133)](https://github.com/mviereck/x11docker/issues/133)

## [5.4.4](https://github.com/mviereck/x11docker/releases/tag/v5.4.4) - 2019-02-24
### Fixed
 - `--gpu`: NVIDIA driver installation: Avoid `--install-libglvnd` and
   `--no-nvidia-modprobe` for installer versions that do not support it.
   Fool dependency check for `binutils` for old installer versions.
   Skip installation if `--runtime=nvidia` is given in docker run options.
   [(#127)](https://github.com/mviereck/x11docker/issues/127)

## [5.4.3](https://github.com/mviereck/x11docker/releases/tag/v5.4.2) - 2019-02-19
### Changed
 - `--alsa[=CARDNAME]`: Accepts a sound card name as optional argument.
 - `--gpu`: NVIDIA driver installation: Avoid dependencies on `kmod` and `xz`.
### Fixed
 - `--gpu`: NVIDIA driver installation: Old versions need `--install-libglvnd`.

## [5.4.2](https://github.com/mviereck/x11docker/releases/tag/v5.4.2) - 2019-02-18
### Fixed
 - `--gpu`: Fixes for automated NVIDIA driver installation.
   [(#127)](https://github.com/mviereck/x11docker/issues/127)

## [5.4.1](https://github.com/mviereck/x11docker/releases/tag/v5.4.1) - 2019-02-08
### Fixed
 - `--update`: Remove debug output of `set -x`.

## [5.4.0](https://github.com/mviereck/x11docker/releases/tag/v5.4.0) - 2019-02-08
### Added
 - `--pull [=ask|yes|no|always]`: New option to allow/deny `docker pull`.
   [(#109)](https://github.com/mviereck/x11docker/issues/109)
 - `--limit[=FACTOR]`: New option to restrict RAM and CPU usage.
 - `--border`: New option to draw a colored border into `--xpra` windows.
   Helps to distinguish between host and container applications.
   [(#91)](https://github.com/mviereck/x11docker/issues/91)
 - `--xtest`, `--xcomposite`: Experimental options to enable X extensions
   `XTEST` and `COMPOSITE`. Might be removed in later releases.
   [(#117)](https://github.com/mviereck/x11docker/issues/117)
### Changed
 - Copy `/etc/skel/.` in container to `HOME` if `HOME` is empty.
 - Changed shebang `#! /bin/bash` to `#! /usr/bin/env bash` for portability.
   [(#83)](https://github.com/mviereck/x11docker/issues/83)
 - Allow interactive `docker pull` in terminal only. Do not start additional 
   X terminal. [(#109)](https://github.com/mviereck/x11docker/issues/109)
 - Prefer starting terminal to ask for root password. Use additional X terminal
   only as a fallback. 
   [(#109)](https://github.com/mviereck/x11docker/issues/109)
### Fixed
 - **API FIX**: Preserve quoting in image command correctly. 
   Image commands like `sh -c 'ls && pwd'` previously failed.
   Instead `'ls && pwd'` sort of worked although it is weird.
   Now `sh -c 'ls && pwd'` works as intended and `'ls && pwd'` fails.
   [(#112)](https://github.com/mviereck/x11docker/issues/112)
 - `-t, --tty`: Long option was not parsed.
 - docker-for-win: Fixed IP check
   [(#102)](https://github.com/mviereck/x11docker/issues/102)
 - docker-for-win: Make sure container is terminated.
   [(#106)](https://github.com/mviereck/x11docker/issues/106)
 - docker-for-win: `--interactive`: Use `winpty` wrapper.
   [(#87)](https://github.com/mviereck/x11docker/issues/87)
 - MSYS2/Cygwin: Always use X over IP to serve e.g. `Xvfb.exe`, too.
   [(#123)](https://github.com/mviereck/x11docker/issues/123)
 - `--update`: Fixed `sed` parsing error for excerpt of `CHANGELOG.md`.

## [5.3.3](https://github.com/mviereck/x11docker/releases/tag/v5.3.3) - 2018-11-17
### Added
 - `-i, --interactive`: New option to run with an interactive TTY.
   [(#87)](https://github.com/mviereck/x11docker/issues/87)
 - `-t, --tty`: Replaces `--nothing`. Runs no X server, uses terminal only.
   Allows `x11docker -ti` similar to often used `docker run -ti`. 
 - `-q, --quiet`: Replaces `--silent`. Suppress x11docker messages.
### Deprecated
 - `--silent`: Use `--quiet` instead.
 - `--nothing`: Use `--tty` instead.
 - `--stdout`: stdout is always displayed now.
 - `--stderr`: stderr is always displayed now.
 - `-Q`: stdout and stderr are always displayed now.
### Fixed
 - `--webcam`: Share `/run/udev/data` to provide device information for 
   `cheese` and `gnome-ring`.
   [(#86)](https://github.com/mviereck/x11docker/issues/86)
   [(#75)](https://github.com/mviereck/x11docker/issues/75)
 - `--sysvinit`: fixed startup failure due to missing container user name.

## [5.3.2](https://github.com/mviereck/x11docker/releases/tag/v5.3.2) - 2018-11-08
### Added
 - `--user=RETAIN`: Keep user settings of image instead of creating a new one.
   [(#85)](https://github.com/mviereck/x11docker/issues/85)
### Fixed
 - `gnome-terminal` did not appear for password prompt or `docker pull`.
   [(#84)](https://github.com/mviereck/x11docker/issues/84)
 - Watch container pid 1 instead of container pid itself. Avoids issue on NixOS
   where users cannot see processes of other users, root or docker in this case.
   Throw error if x11docker cannot watch container pid 1 due to `hidepid=2`.
   [(#83)](https://github.com/mviereck/x11docker/issues/83)

## [5.3.1](https://github.com/mviereck/x11docker/releases/tag/v5.3.1) - 2018-10-22
### Fixed
 - `--hostdisplay`: Fixed `XAUTHORITY` issue if running over `ssh -X`.
   [(#81)](https://github.com/mviereck/x11docker/issues/81)

## [5.3.0](https://github.com/mviereck/x11docker/releases/tag/v5.3.0) - 2018-10-11
### Added
 - `--launcher`: Replaces `--starter`, creates an application launcher.
### Changed
 - Major code cleanup and restructuring. New: commented `main()` routine.
 - `--dbus`: Always uses `dbus-run-session`, doesn't try `dbus-launch` anymore.
 - `--xpra`: Allow choice of virtual frame buffer with `--xdummy` or `--xvfb`. 
   If not specified: defaults to Xvfb, fallback to Xdummy.
### Deprecated
 - `--starter`: Use `--launcher` instead.
 - `--trusted`: Use `--clipboard` instead.
 - `--untrusted`: No replacement.
 - `--xtest`: No replacement.
 - `--no-xtest`: No replacement.
### Fixed
 - `--weston*`, `--kwin*`: Did not terminate due to DBus issue.
 - `--xdummy`, `--xvfb`: avoid X message boxes if there is no host X.
   Affects error messages and `docker pull`.
   [(#77)](https://github.com/mviereck/x11docker/issues/77)
 - `--pw`: regression fix, did not prompt for password in terminal window.
 - `/etc/pam.d/su`: allow additional default configs.
 - Export environment variables `DOCKER_*` in dockerrc if some exist.
   [(#79)](https://github.com/mviereck/x11docker/issues/79)   

## [5.2.0](https://github.com/mviereck/x11docker/releases/tag/v5.2.0) - 2018-09-17
### Added
 - `--webcam`: New option to share webcam devices `/dev/video*`.
   [(#75)](https://github.com/mviereck/x11docker/issues/75)
 - `--hostdbus`: New option to connect container to DBus session from host.
 - `-q`: New option, shortcut for `--stdout --stderr --silent`.
 - `-Q`: New option, shortcut for `--stdout --stderr`.
### Changed
 - `--wayland`: Does not run `--dbus-system` anymore to avoid complexity
   and issues on arch linux. Some old GTK3 applications may fail now.
   In that case, use `--weston` instead.
 - `--sharedir DIR`: Appending `:ro` to `DIR` restricts to read-only access.
### Fixed
 - `--systemd --verbose`: journalctl.log was not shown.
 - `--systemd`: fixed slow dbus startup.

## [5.1.0](https://github.com/mviereck/x11docker/releases/tag/v5.1.0) - 2018-09-02
### Added
 - `--printer`: New option to access CUPS printer server.
   [(#73)](https://github.com/mviereck/x11docker/issues/73)
### Fixed
 - `--hostdisplay`: Fixed wrong `DISPLAY` detection if `XAUTHORITY` is missing,
   happened e.g. in Gnome Wayland session.
   [(#74)](https://github.com/mviereck/x11docker/issues/74)
 - `--nxagent`: X authentication was set to `xhost +`. 
   Now restricted to cookie using clients again.

## [5.0.0](https://github.com/mviereck/x11docker/releases/tag/v5.0.0) - 2018-08-20
### Added
 - Support of MSYS2, Cygwin and WSL on MS Windows. 
   [(#55)](https://github.com/mviereck/x11docker/issues/55)
 - `--vcxsrv`: New option for [VcXsrv](https://sourceforge.net/projects/vcxsrv/) 
   X server on MS Windows. Similar to Xming.
   [(#55)](https://github.com/mviereck/x11docker/issues/55)
 - `--xwin`: New option for Xwin X server of Cygwin/X on MS Windows.
 - `--sharessh`: New option to share SSH agent authentication socket from host.
   [(#59)](https://github.com/mviereck/x11docker/issues/59)
 - `--name`: New option to set container name.
   [(#61)](https://github.com/mviereck/x11docker/issues/61)
 - `--cachebasedir`: Set custom cache base directory. Replaces `--cachedir`.
 - `--homebasedir`: Set base directory where to store folders for `--home`.
### Changed
 - **API CHANGE**: Syntax changed for custom `DOCKER_RUN_OPTIONS` 
   [(#58)](https://github.com/mviereck/x11docker/issues/58). New:
```
   x11docker [OPTIONS] --  DOCKER_RUN_OPTIONS -- IMAGE [COMMAND [ARG1 ARG2 ...]]
```
   Previous syntax, still valid, but deprecated:
```
   x11docker [OPTIONS] -- "DOCKER_RUN_OPTIONS"   IMAGE [COMMAND [ARG1 ARG2 ...]]
   x11docker [OPTIONS] -- IMAGE COMMAND ARG1 -- ARG2
```
   **BREAKS** due to wrongly parsed ` -- ` :
```
   x11docker [OPTIONS] -- "DOCKER_RUN_OPTIONS"   IMAGE COMMAND ARG1 -- ARG2
```
   Valid:
```
   x11docker [OPTIONS] --  DOCKER_RUN_OPTIONS -- IMAGE COMMAND ARG1 -- ARG2
```
 - `--pulseaudio` allows optional argument `=tcp` or `=socket`.
   Defaults to connection over shared socket on Linux and to TCP connection
   on MS Windows. On Linux both modes are possible, on MS Windows TCP only.
 - `--verbose`: takes optional argument `c` for colored output, eg `-vc`.
### Deprecated
 - `--cachedir`: Use `--cachebasedir` instead.
### Removed
 - `--ipc`: Use `--hostipc` instead.
 - `--net`: Use `--hostnet` instead.
 - `--sharewayland`: Use `--wayland` instead.
 - `--setwaylandenv`: Use `--wayland` instead.
 - `--dbus-daemon`, `--dbusdaemon`: Use `--dbus-system` instead.
 - `--add`: Use `--runfromhost` instead.
### Fixed
 - `--xpra`: Support of outdated xpra version v0.17.6 that is still
   distributed in debian stretch and buster.
 - `--xpra`: Set x11docker cache folder as xpra socket folder.
   [(#69)](https://github.com/mviereck/x11docker/issues/69)
 - `--xpra`: Check if `xhost` is available if xpra version 2.3.1 has cookie 
   issue. [(#57)](https://github.com/mviereck/x11docker/issues/57)
 - `--xpra-xwayland`: Set Weston `--fullscreen` to get Xwayland resolution
   matching host display. Weston v4.0.0 seems to interpret screen size 
   settings in `weston.ini` different than before.
 - `--pulseaudio`: create socket to share instead of using existing one.
   [(#71)](https://github.com/mviereck/x11docker/issues/71)
 - `--pw gksu`, `--pw gksudo`: Disable keyboard grabbing to avoid issues
   with Gnome 3 Wayland session.
 - Don't fail on missing password prompt frontend if no password is needed.

## [4.3.6](https://github.com/mviereck/x11docker/releases/tag/v4.3.6) - 2018-07-03
### Changed
 - `--auto`: Prefer `--xpra` and `--xephyr` over `--nxagent` again.
   `--nxagent` too often has issues with extension Composite.
 - `--xorg`: Allow running Xorg as root from within X 
   if `/etc/X11/Xwrapper.config` is not configured to allow it.
 - `--xpra`, `--xpra-xwayland`: Set maximal `--quality 100`.

### Fixed
 - `--xpra`: Check for tty timeout had a bug that caused all clients 
   of same server to terminate if one client was closed.
 - `--xorg`: Secure check for free tty instead of guessing it.
 - `--xorg`: Error messages appear on new display instead of host display.
 - `--sysvinit`, `--runit`, `--openrc`: Clean shutdown on CTRL-C / SIGINT.
 - `x11docker-gui`: Fixed issue with self-terminating on cleanup.
 - errors within subshells did not reliably terminate x11docker.
 - `--tini`: Check for `docker-init` in snap installs of docker.
   [(#51)](https://github.com/mviereck/x11docker/issues/51)
 - `--dbus-system`: Disable services `org.freedesktop.hostname1` and 
   `org.freedesktop.locale1` if not running with `--systemd`. Can cause
   container shutdown after some time.
 - `--hostdisplay`: Fixed possible `xhost -SI:localuser:$USER`. 
   [(#53)](https://github.com/mviereck/x11docker/issues/53)
 - `/etc/shadow`: Fixed fedora issue with `000` file access.
   [(#53)](https://github.com/mviereck/x11docker/issues/53)


## [4.3.5](https://github.com/mviereck/x11docker/releases/tag/v4.3.5) - 2018-06-21
### Changed
 - `x11docker-gui` runs from console, too.
### Fixed
 - `--xorg` and others on TTY failed due to xinit in subshell.
   (regression in v4.3.4).
 - `--weston --size` failed on tty, have to specify drm backend for check.
 - timezone syncing: If setting `TZ`, positive offsets have been set wrong.
 - timezone syncing: Regard `TZ` from host, not only `/etc/localtime`.
 - `--xpra`: catch timeout disconnection that happens if using another tty
   longer than 60s. Restart xpra client in that case.

## [4.3.4](https://github.com/mviereck/x11docker/releases/tag/v4.3.4) - 2018-06-15
### Changed
 - `--dbus-system --sharecgroup`: support of `elogind` in container.
 - Timezone syncing: Do not mount-bind `/etc/localtime`. 
   If tzdata is missing in image, but host and image have same libc,
   provide current timezone file only. Create symlink `/etc/localtime` within
   container. If all that fails, set `TZ` with offset to UTC.
   [(#50)](https://github.com/mviereck/x11docker/issues/50)
 - Improved `message.fifo` handling from within dockerrc and container.
 - Disentangled final code sequence of xinit and docker run.
### Fixed
 - Check for running docker daemon in dockerrc instead of using `pidof`.
   [(#49)](https://github.com/mviereck/x11docker/issues/49)
 - Show error message if X server fails to start. Suppress warning if needless.
 - `--xpra`: Do not exit on `failed` in xpra server log. (seen on Ubuntu 18.04).
 - `--xorg`: Show `Xwrapper.config` warning if `needs_root_rights=yes` is 
   missing. (Seen on Ubuntu 18.04).
 - `--xorg`: Password prompt did not appear on new display.
 - `--nothing`: Bugfix password prompt on console.
 - `--nothing`: Avoid startup error message.
 - `--nothing`: Don't start X if running within X / dependency check issue.
 - `--nothing`: Pull request for non-local images was invisible.
   
## [4.3.3](https://github.com/mviereck/x11docker/releases/tag/v4.3.3) - 2018-06-05
### Changed
 - `--no-init` or missing `tini` resp. `docker-init`: use `sh` as PID 1
   for desktop environments (`--desktop`) to allow logout.
### Fixed
 - fedora 28: Check for docker daemon with name `dockerd-current` 
   [(#49)](https://github.com/mviereck/x11docker/issues/49)
 - `--auto`: Prefer `--hostdisplay` for seamless apps if nothing else is 
   available.
 - `--wayland`, `--weston`, `--kwin`, `--hostwayland`: 
   Show error and exit if no wayland environment can be provided.
 - dockerrc messages forwarded to logfile fifo. (fixes "unknown file descriptor").

## [4.3.2](https://github.com/mviereck/x11docker/releases/tag/v4.3.2) - 2018-06-03
### Changed
 - `x11docker-gui` is interactive now. Live preview of generated command. 
   Starting multiple x11docker instances possible. Copy-to-clipboard button.
 - `x11docker-gui`: create list of installed images every time x11docker 
   or x11docker-gui runs and has enough permissions. Image list is used in
   x11docker-gui in image combo.
 - `--cleanup`: Running as root not mandatory.
 - `--clipboard`: support `xsel` additional to `xclip`.
### Fixed
 - Starting in pure Wayland environments failed (regression in v4.3.0).
 - `--wayland`, `--weston`, `--kwin` in pure Wayland: detect screen size.
 
## [4.3.1](https://github.com/mviereck/x11docker/releases/tag/v4.3.1) - 2018-05-29
### Changed
 - `--auto`: prefer `--nxagent` over `--xpra` and `--xephyr`. Reasons:
   Faster startup than `--xpra`. Flexible display size opposed to `--xephyr`.
   Since Ubuntu 18.04 available to broader range of users than before.
 - `--runfromhost` can be specified multiple times now.
 - `--runasroot` can be specified multiple times now.
 - `--dbus-system` and init systems: remove useless or failing dbus services.
 - `--systemd`: mask some useless or failing units.
 - set `DISPLAY`, `XAUTHORITY`, `WAYLAND_DISPLAY` and `XDG_RUNTIME_DIR`
   in `docker run` command for easier custom use of `docker exec`.
### Fixed
 - `--xpra`: Deny to start xpra >2.2.5 and <r19519 due to MIT-SHM bug.
   Show message that startup is only possible with `--hostipc`.
   xpra bugticket: https://xpra.org/trac/ticket/1858
 - `--xpra`: Warning and workaround for cookie bug in xpra >=v2.3.
   xpra bugticket: https://www.xpra.org/trac/ticket/1859
 - `--xpra` in desktop mode: Allow closing client window, don't restart.

## [4.3.0](https://github.com/mviereck/x11docker/releases/tag/v4.3.0) - 2018-05-26
### Added
 - `--stdin`: Forward stdin of x11docker to image command.
 - `--showpid1`: Echo host PID of container PID 1 on stdout.
### Changed
 - `--security-opt=no-new-privileges` for init systems and `--dbus-system`.
   Now default for all options except `--sudouser` and `--cap-default`.
 - `--dbus-system` and `init` system options: Run all except a few dbus
   system services manually and show security warning message. Manual
   start needed due to `no-new-privileges`, polkit setuid helper fails.
 - Minimize or delete `/etc/pam.d/su` and delete `/etc/pam.d/sudo`.
   Avoids security leak that would allow switching to root in container
   if `PAM` configuration allows it and capabilities for `su` are given.
 - Remove `/bin/sh -c` from extracted CMD image command.
 - Regard `WORKDIR` in image, use it instead of `HOME`. 
   [(#45)](https://github.com/mviereck/x11docker/issues/45)
 - Logfile handling with fifo/named pipe.
 - `--auto`: Tightened dependency check.
 - Improved process watching using less resources. Faster shutdown.
 - `x11docker-gui`: New structure using tabs.
 - Some code cleanup.
### Fixed
 - Don't set `-title` in `Xephyr` command. Xephyr bug: Releasing keyboard
   and mouse after grab (ctrl+shift) does not work with `-title`. 
   [(#44)](https://github.com/mviereck/x11docker/issues/44)
 - `--nxagent`: Fixed keyboard layout issue, don't use setxkbmap.
 - `--nxagent`:  Regard `--keymap`.
 - `--nxagent`: Removed extension Composite, caused some issues.
 - `--exe`: Don't pass file descriptors to host executable.
 - `--wayland` Works with prissy GTK3 applications (e.g. xfce4-terminal) again,
   needed user switching in `--dbus-system` for unknown reasons.
 - `--showid` failed with sudo due to missing file descriptors. Using mkfifo now.
 - Don't forward stdin as default, can cause trouble if empty. use `--stdin` instead.
 - `--xorg`: disable screen saver [(#46)](https://github.com/mviereck/x11docker/issues/46)
   
## [4.2.1](https://github.com/mviereck/x11docker/releases/tag/v4.2.1) - 2018-05-10
### Added
 - Forward `stdin` of x11docker to container command with a named pipe/fifo.
### Changed
 - `x11docker-gui`: Use stdin for kaptain grammar transmission. Don't use cache.
 - `--dbus-system`: Don't create `--tmpf /tmp --tmpfs /run --tmpfs /var/run --tmpfs /run/lock`.
   [(#43)](https://github.com/mviereck/x11docker/issues/43)
 - Some internal improvements for faster startup and shutdown.
### Fixed
 - `x11docker-gui`: fixed x11docker startup failure due to changed stdout output.

## [4.2.0](https://github.com/mviereck/x11docker/releases/tag/v4.2.0) - 2018-05-04
### Added
 - `--group-add`: New option to add groups to container user. 
   Needed instead of ` -- --group-add` to cover user switching setups, too.
 - `--showid`: New option to show container ID on stdout.
 - `--runfromhost`: Replaces deprecated `--add` to have a meaningful option name.
   Similar to already existing `--exe`, but integrates with container.
 - `--runasroot`: New option to run command as root in container on startup.
### Changed
 - `--gpu`: Support for automatic installation of NVIDIA drivers in container.
   Limited to `glibc` based image systems.
   [(#41)](https://github.com/mviereck/x11docker/issues/41)
 - `elogind` support for `--sysvinit`, `--openrc` and `--runit`.
   See also [elogind in container: elogind#52](https://github.com/elogind/elogind/issues/52)
 - `--systemd`: If host does not run `systemd`, create `/sys/fs/cgroup/systemd`.
 - `--dbus-system`: wait for bus socket to be ready before continuing.
 - `--tini`: Use `tini-static` from `~/.local/share/x11docker` or 
   `/usr/local/share/x11docker` if available. Show message for this possibility
   if `/usr/bin/docker-init` is missing. (Widespread docker packaging issue).
   [(#23)](https://github.com/mviereck/x11docker/issues/23)
 - Avoid user switching except for `--systemd`, `--sysvinit`, `--openrc` and 
   `--runit`. [(#42)](https://github.com/mviereck/x11docker/issues/42)
 - Outsourced `x11docker.png` from `x11docker-gui`.
 - No default output of container ID on stdout anymore. Use `--showid` instead.
 - `--silent`: Do not show error messages except in logfile.
 - `--weston[-xwayland] --fullscreen`: Use X backend if possible to prevent
   possible crash with nested fullscreen weston in host drm weston.
 - Disabled forwarding of `stdin` to container, has not been reliable.
### Deprecated
 - `--add` changed its option name to `--runfromhost`.
### Fixed
 - Don't share or link `/tmp/.Xn-lock` as usefulness is in doubt. 
   Avoids issues with `x11docker/xwayland`.
 - `--stdout --showid:` Make sure container ID is shown first.

## [4.1.1](https://github.com/mviereck/x11docker/releases/tag/v4.1.1) - 2018-04-12
### Changed
 - Mount nothing into `/tmp` as init cleanups may try (and fail) to delete it. 
 - Write or link into `/tmp` only _after_ possible init cleanup.
 - Mount X socket r/w again as there is no longer a risk due to `/tmp` cleanups.
 - `--debug`: Some changes for more useful debugging output. 
   Drop `set -x` in main code, instead `set -Eu` with `trap ERR`.
 - `--update`/`--update-master`: Show excerpt of `CHANGELOG.md`.
 - Check `ENTRYPOINT` for init entries `/tini|/init|/systemd` and disable it 
   if x11docker already runs an init. (Default: `--tini`.)
### Fixed
 - `x11docker-gui` regards new output of container ID now that confused output
   of `x11docker/kaptain` and prevented start of `x11docker`.
 - Mount `WAYLAND_DISPLAY` and `DISPLAY` at `/` instead of `/x11docker/` 
   in container. 
   Avoids a docker bug that only sometimes causes startup failure 
   `stat /run/user/1000/wayland-600: no such file or directory`.
   Occasionally docker is confused about a mount point inside of a mount point.
   Avoiding that now. 
   However, issue only seen with shared Wayland sockets and never with X 
   sockets, maybe due to different option positions in `docker run` command.
 - `--workdir`: Avoid double setting of `--workdir` in docker command 
   if x11docker option `--workdir` is set. Caused no trouble, though.

## [4.1.0](https://github.com/mviereck/x11docker/releases/tag/v4.1.0) - 2018-04-08
### Added
 - `--update-master` updates to latest x11docker master version.
   (Formerly job of `--update`).
### Changed
 - `--update` updates to latest x11docker release on github. 
   (Formerly: latest master version).

## [4.0.0](https://github.com/mviereck/x11docker/releases/tag/v4.0.0) - 2018-04-07
### Changed
 - Outsourced changelog from x11docker source code to `CHANGELOG.md`. [(#38)](https://github.com/mviereck/x11docker/issues/38)
 - Follow guidelines of [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).
 - Stricter compliance to [Semantic Versioning](https://semver.org/) rules.
### Notes
 - Previous version links in changelog lead to history tree leafs with 
   corresponding `x11docker` script.
 - Upcoming version links in changelog will lead to corresponding [releases](https://github.com/mviereck/x11docker/releases).

## [3.9.9](https://github.com/mviereck/x11docker/blob/8abded01de9482ef70195550f936c9f07668b486/x11docker) - 2018-04-06
### Changed
 - Removed `--security-opt=no-new-privileges` for 
   `--systemd`/`--sysvinit`/`--runit`/`--openrc`.  (Undoes some changes 
   from V3.9.8.1). Will be reintroduced after further checks, caused issues 
   with `x11docker/deepin` and `x11docker/cinnamon`.
 - `--env`: set environment variables in `docker run`, too. 
   Makes them available within `docker exec`.

## [3.9.8.5](https://github.com/mviereck/x11docker/blob/6227a1eebc5b63df305822896d7360a14440caf4/x11docker) - 2018-04-05
### Changed
 - `finish()`: run `docker stop` before creating `timetosaygoodbye` for 
   more graceful shutdown [(#37)](https://github.com/mviereck/x11docker/issues/37)
### Fixed
 - Set correct `XAUTHORITY` in setup script.
 - Disable `User` in systemd journal service, can fail in restricted setups.

## [3.9.8.4](https://github.com/mviereck/x11docker/blob/d74fa2defceb538d8c9e90932d48f23cae0f102b/x11docker) - 2018-04-04
### Added
 - `--workdir` to set working directory different from `HOME`. ([#36](https://github.com/mviereck/x11docker/issues/36))
### Changed
 - `--systemd`/`--dbus-system`: changed `su` command to remove `sh` from pstree.
### Fixed
 - User group entry in `/etc/group` had wrong syntax.

## [3.9.8.3](https://github.com/mviereck/x11docker/blob/6ce5d2cbd7a14556723a3c8e1163988f2ddda8ce/x11docker) - 2018-04-04
### Fixed
 - `--dbus-system`: must not set `--security-opt=no-new-privileges`, 
   important services like `polkitd` fail.

## [3.9.8.2](https://github.com/mviereck/x11docker/blob/a58e6808254ce78eb528010584ff9d7ef9b8aa26/x11docker) - 2018-04-03
### Changed
 - disable entrypoint `tini` if x11docker already runs an init system 
   (default: `--tini`/`docker-init` from docker). ([#34](https://github.com/mviereck/x11docker/issues/34))

## [3.9.8.1](https://github.com/mviereck/x11docker/blob/75f79c9888beee08ca08c42c5f70feaa0f02cd30/x11docker) - 2018-04-03
### Changed
 - `--security-opt=no-new-privileges` now always set except for `--sudouser`.
   It does not harm switching from root to less privileged users. 
   _(Note: is undone in v3.9.9)_
 - setup script with user switching: `exec su` instead of `su` to avoid 
   root shell in parent tree. `su` is now immediate child of `init`.
### Added
 - show container ID on stdout ([#36](https://github.com/mviereck/x11docker/issues/36)). 
   Can be catched e.g. with `read containerID < <(x11docker [...] )`.

## [3.9.8.0](https://github.com/mviereck/x11docker/blob/a4067993a91f39bce145b48406453f786d1707eb/x11docker) - 2018-04-02
### Changed
 - Removed `Xtermlogfile`, using `Dockerlogfile` instead. 
   Strange: solved missing output with `--pw=su` or `--pw=sudo`, too.
### Fixed
 - Escape special characters in `--env`, `ENV` and image command.
   (Addresses [#34](https://github.com/mviereck/x11docker/issues/34), too, now solved better). _(Note: still have to escape some other optional arguments)_

## [3.9.7.9](https://github.com/mviereck/x11docker/blob/7776de0f3128a679239037567626cca09f472ee5/x11docker) - 2018-03-31
### Changed
 - Store parsed parts of `Imagecommand` in `''` to allow constructs like
   `sh -c "cd /etc ; xterm"`
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
 - mount X socket and lockfile read-only to protect from `/tmp` init cleanups.
 - minor improvements of init system initialization
### Fixed
 - remove checks for `--userns-remap` and `--selinux-enabled`. [(#33)](https://github.com/mviereck/x11docker/issues/33)

## [3.9.7.5](https://github.com/mviereck/x11docker/blob/0f0b138db7c2f3093511fae7583b34bc44db3423/x11docker) - 2018-03-30
### Changed
 - `--dbus-system`: drop explicit consolekit support
 - `--sysvinit`,`--openrc`: disable getty in inittab instead of overwriting 
   inittab with shared volume
 - `--sysvinit`: change `rc.local` in setupscript instead of overwriting it
   with shared volume
 - `--openrc`, `--runit`: create service in setupscript. 
   Drop some more capabilities

## [3.9.7.4](https://github.com/mviereck/x11docker/blob/85f1f29855090d2dba9328e9184f23365f4f1a6f/x11docker) - 2018-03-26
### Added
 - `--sysvinit` for init system SysVinit in container. Tested with devuan.
### Fixed
 - `--pulseaudio`: need to set environment variable `PULSE_SERVER`. 
   (Was missing after switch from tcp to socket connection).
 - `--runit`: add softlink for X socket in `x11docker.CMD.sh` for 
   compatibility with `runit` on debian.

## [3.9.7.3](https://github.com/mviereck/x11docker/blob/57e34236dca42e05434a304c77f61202d678398a/x11docker) - 2018-03-21
### Changed
 - `--pulseaudio`: share socket `XDG_RUNTIME_DIR/pulse` 
   instead of connecting over tcp.

## [3.9.7.2](https://github.com/mviereck/x11docker/blob/25201b916159b2f77d6c6188ea875d80004733d1/x11docker) - 2018-03-20
### Added
 - `--add` to add a host command in `xinitrc`.
 - `--debug` to set `-x` in all scripts showing code lines while executed.
### Changed
 - `--wm`: fall back to autodetection if specified window manager not found.
 - `--dbus`: enable automatically for `--runit`, `--openrc`
 - consolekit: use automatically with `--dbus-system`, `--openrc`, `--runit`
 - `mywatch()`: use `watch` again, now without `sh -c`
 - `--help`: `usage()` cleanup
### Deprecated
 - `--sharewayland`, `--waylandenv`: not needed for anything anymore. 
   `--wayland` does the job.
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
 - `finish()`: wrong warning although terminating bgpid was successful.

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
 - `/etc/sudoers[.d/]`: replace completely to avoid possible evil image setups.
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
### Changed
 - show error messages regardless of `--silent`
 - change `sudo` to `sudo -E`, needed for OpenSUSE
 - code cleanup, some improved messages

## [3.6.3.8](https://github.com/mviereck/x11docker/blob/2e027c2b9bab8af2244fe65218276f0ad7a84736/x11docker) - 2017-10-25
### Changed
 - fedora: set `--ipc` and `--trusted` for `--hostdisplay` only

## [3.6.3.7](https://github.com/mviereck/x11docker/blob/6034608f9d49c138d3f58b647257114b9c66052e/x11docker) - 2017-10-25
### Fixed
 - `--hostdisplay` on fedora: use host cookie, custom cookie is rejected

## [3.6.3.6](https://github.com/mviereck/x11docker/blob/84881c51788eecc754f36288fbb8699c5dbc327f/x11docker) - 2017-10-24
### Added
 - `--wmlist` to retrieve list of window managers, used by x11docker-gui, not documented in `--help`
### Changed
 - `--gpu`: improved support in autochoosing mode
 - disabled note of xpra keyboard shortcuts, takes too long
 - hardcoded xpra environment variables, parsing `xpra showconfig` takes too long
### Fixed
 - `--pw=sudo`: issue with setsid

## [3.6.3.5](https://github.com/mviereck/x11docker/blob/12bb570b2c03157d4062391288f770e520307c0f/x11docker) - 2017-10-24
### Fixed
 - xpra with host user root: set environment variables
 - `dbus-launch` for `konsole` and `terminator`, needed in dockerrc

## [3.6.3.4](https://github.com/mviereck/x11docker/blob/836d4f50e44cccc587819f002faa8d18e62ecbb3/x11docker) - 2017-10-23
### Fixed
 - add `/usr/sbin` to `PATH`, needed on mageia for ip
 - `--pw=sudo`: `setsid sudo` fails, must use `sudo setsid`

## [3.6.3.3](https://github.com/mviereck/x11docker/blob/4256438ff948dd97a0887410e866121736a1893b/x11docker) - 2017-10-23
### Changed
 - removed experimental Code
### Fixed
 - `--wm` issue as root in xinitrc

## [3.6.3.2](https://github.com/mviereck/x11docker/blob/58ea47a22270ad0a7f81196cb8c69bf300e87dff/x11docker) - 2017-10-23
### Changed
 - remove debugging `set -x` in xinitrc

## [3.6.3.1](https://github.com/mviereck/x11docker/blob/ed80f32c115066203b88b9681655c30bc2c42f13/x11docker) - 2017-10-23
### Changed
 - split X server command with \backslash in multiple lines
### Fixed
 - don't use `su $USER` in xinitrc

## [3.6.3](https://github.com/mviereck/x11docker/blob/63410b85f617b3449c48212dda9d0e74ec6327bf/x11docker) - 2017-10-20
### Added
 - `--no-internet`
### Changed
 - minor adjustments for compatibility with CentOS/RHEL, Arch and Manjaro
 - allow gnome-terminal / self-forking terminals in general
 - split docker command with \backslash in multiple lines

## [3.6.2.12](https://github.com/mviereck/x11docker/blob/e907bd364ed591fc1087fa64005f4f890345d43f/x11docker) - 2017-10-18
### Fixed
 - `dbus-launch` disturbed `gksu`

## [3.6.2.11](https://github.com/mviereck/x11docker/blob/a21a9d8cca6483b8c29b50e0a77b348867325e04/x11docker) - 2017-10-18
### Changed
 - CentOS/RHEL workaround: insist on root or gksu; terminal password prompt causes docker to terminate regardless of nohup

## [3.6.2.10](https://github.com/mviereck/x11docker/blob/18506dee00b987b0acaca9ed84531e3aadb07f8f/x11docker) - 2017-10-17
### Fixed
 -  Fixes in terminal emulator setup for password prompt and pull question (2)

## [3.6.2.9](https://github.com/mviereck/x11docker/blob/c4fcfac53be978322831fcad4a6b671598faa19f/x11docker) - 2017-10-17
### Changed
 - xpra: set `--file-transfer=off` (stores files in `Downloads` from host, useless here)
### Fixed
 - Fixes in terminal emulator setup for password prompt and pull question

## [3.6.2.8](https://github.com/mviereck/x11docker/blob/dc36c1d29958cdf48a8c45ec791220f869026cd1/x11docker) - 2017-10-12
### Changed
 -  `--xdummy`/`--xpra`: add multiple modelines for virtual display sizes to allow flexible changes of xpra client desktop window
 -  `--xpra`: virtual display size always equal with physical display, create smaller mode in xinitrc -> allow fullscreen
 -  xpra: disable some unused, but possibly leaking features (forwarding of webcam, notifications, printer)
 -  xpra: set xpra specific environment variables in dockerrc
 -  xpra: show keyboard shortcuts

## [3.6.2.7](https://github.com/mviereck/x11docker/blob/51c5dab789c335d87c4d11c5ad91ebe7477766f1/x11docker) - 2017-10-08
### Changed
 -  `--xephyr`: title for Xephyr windows
 -  `--xephyr`: Xnest as fallback for missing Xephyr
 -  `--xpra` `--desktop` hint: screensize bug fixed since xpra v2.2-r17117

## [3.6.2.6](https://github.com/mviereck/x11docker/blob/4d94c7eb5dc690e8a22135394cb2e9d4dd3ba9ab/x11docker) - 2017-10-07
### Fixed
 -  `--xpra` `--desktop`: use `start-desktop` instead of `shadow`

## [3.6.2.5](https://github.com/mviereck/x11docker/blob/72e8afc59750310ac621c10c5ddcaf826bc167f2/x11docker) - 2017-10-05
### Changed
 -  `no_xhost()?` after cookie creation avoids xhost warning on Xwayland
 -  `--output-count` in `--auto` mode: choose `--weston-xwayland`
 -  `--display`: allow `:` before display number
 -  `sh` instead of `bash` to run x11docker_CMD

## [3.6.2.4](https://github.com/mviereck/x11docker/blob/8ab3d12af1c14b437870788b72615eb89d0bfa0a/x11docker) - 2017-09-27
### Changed
 -  `--starter`: missing `xdg-user-dir` is no longer an error
 -  `--silent`: redirect stderr already while parsing
 -  `--user=root`: disable `--cap-drop=ALL`
 -  `--help`: update usage info
 -  `weston.ini`: background color and zoom-in effect
 -  use Kwin/Kwin-Xwayland as fallback for Weston/Weston-Xwayland
 -  catch closing xpra client in every case, not only in desktop mode
 -  parsing cli options: check for remaining arguments `$#` instead of empty `$1`
### Fixed
 -  `--xonly`: do not fail if docker daemon is not running

## [3.6.2.3](https://github.com/mviereck/x11docker/blob/a24de4ad106ffa1c2c671a53c3c16582efe1ad14/x11docker) - 2017-09-19
### Changed
 -  `--xorg`: only run setxkbmap in xinitrc if $Hostdisplay is set

## [3.6.2.2](https://github.com/mviereck/x11docker/blob/e137d771026424dcf4d0bbfc83bfec94195448c5/x11docker) - 2017-09-18
### Changed
 -  `--xpra` `--scale` in desktop mode: regard different `--dpi` behaviour since xpra v2.2
 -  `--help`: update usage info
 -  `setxkbmap` for Xorg like for Xephyr, too
 -  `weston.ini`: added `panel-position=none`, different syntax for different weston versions (seen in Arch Linux).
 -  x11docker_CMD: replace shell with `exec $Imagecommand` (only if stdin is empty)

## [3.6.2.1](https://github.com/mviereck/x11docker/blob/3bffa70a029722a3aeeb6137720f0270bd359e3d/x11docker) - 2017-09-15
### Changed
 -  removed `z` flag in docker command, not needed with current SELinux solution
 -  `--weston[-xwayland]`: no output section on tty without `--scale`, `--size` or `--rotate`
 -  `--weston[-xwayland]`: allow `--size` on tty, though only "real" resolutions will take effect
 -  `--xorg`: `--scale`, `--size`: change primary monitor only, will do better on multi monitor setup
 -  `--xdummy --gpu` now possible on tty, too
### Fixed
 -  `--home`: avoid creating `$Adduserhomefolder` with wrong restrictions if `$Hostuser` is different from `$Benutzer`
 -  Fixes in part: check screensize
 -  watch for closing xpra client in desktop mode to avoid invisible remaining x11docker
 -  `--xorg` on tty: do not set screen size without `--size`.

## [3.6.2](https://github.com/mviereck/x11docker/blob/d223b1b97d3c98b6dcf4769152122ee5e2e9dbc8/x11docker) - 2017-10-10
### Added
 - `--xfishtank` to run `xfishtank` on new X server. Shows a fish tank.
### Changed
 -  `--westonini`: regard for `--xpra-xwayland` and `--xdummy-xwayland`, too.
 -  `PATH`: adding `/usr/games:/usr/local/bin`. Can miss for root, but may be needed for `--exe` and `--xfishtank`
 -  check for X extension `Security` with xdpyinfo
 -  `--clipboard` for `--hostdisplay`: enable `--trusted` and `--ipc`, show warning.
 -  xpra startup after xinitrc, not inside. For better error handling
 -  removed ps loop in dockerrc, not needed anymore due to "docker run" in subshell
 -  `waitforlogentry()`: Just return 0 or 1 instead of calling `error()`
 -  changed logfile handling, move log from `/tmp` to $Sharefolder after `tail -F`
### Fixed
 -  `--sharedir`, `--homedir`: allow whitespaces in path
 -  `--cachedir`: path must not contain whitespaces -> error()
 -  `--westonini`: allow whitespaces in path
 -  `--pulseaudio`: remove tcp module, store id in file to not loose it in subshell
 -  `--exe`: support of `--stdout` and `--stderr`
 -  `error()`/`finish()`: reliable error code before cache folder creation
 -  weston on tty: clean logfile & pidfile to allow second weston instance

## [3.6.1.11](https://github.com/mviereck/x11docker/blob/27861a05fb0fd28f51a8358ae37ab877913aa146/x11docker) - 2017-08-28
### Changed
 -  clean check for stdin, no more workaround

## [3.6.1.10](https://github.com/mviereck/x11docker/blob/cbb904ef2b2c94ccda76aec9f6a59b68dcb854c2/x11docker) - 2017-08-27
### Changed
 -  `--nothing`: no check for successful startup, avoids error message for short-timed cli commands
 -  `--showenv`: wait with output until X is ready and accessible

## [3.6.1.9](https://github.com/mviereck/x11docker/blob/d50ecb314b5d96110b59796493bc983a46a5c780/x11docker) - 2017-08-25
### Fixed
 - `--home`: remove debugging error message

## [3.6.1.8](https://github.com/mviereck/x11docker/blob/e3a49cbe95522a79128e9af8feede4b04074a96b/x11docker) - 2017-08-25
### Changed
 - provide stdin to host exe, too (`--exe`)
 - `--silent`: suppress error dialog box, too
 - more reliable exit code 1 on error
### Fixed
 - `--orphaned`: did not find cache folder
 - `--hostuser`: cache folder created with root ownership

## [3.6.1.7](https://github.com/mviereck/x11docker/blob/427a937a53c81b3bf98621aeb668048d4a8e913a/x11docker) - 2017-08-22
### Changed
 - removed color from `verbose()`, looks strange in logfile
### Fixed
 - installer: check for installed unzip

## [3.6.1.6](https://github.com/mviereck/x11docker/blob/699392d7579e3962d099cf495dc254fde4e9bf97/x11docker) - 2017-08-22
### Changed
 - code cleanup
 - changed window manager priority
 - SELinux: `--security-opt label=type:container_runtime_t` allows access to X unix socket
 - `--xorg`: avoid searching for native resolution if `--scale` is set.
 - `--xorg`: improved check for failed panning
 - Logfile created in `/tmp`, moved later to $Cacherootfolder, to catch early messages
 - code cleanup in variable definitions and option parsing
### Fixed
 - `trap -EXIT` avoids double call of `finish()`. faster shutdown now.

## [3.6.1.5](https://github.com/mviereck/x11docker/blob/34ac2a9bdc63b2d2bcaebc06bed3e3bdcc92845c/x11docker) - 2017-08-21
### Changed
 - `mkdir -p` in installer for tmp folder: `-p` was missing, could cause error
 - declare `note()` in xinitrc
 - `--scale` support for `--xorg`
 - `--size` without `--scale` for `--xorg`: first try `--mode`, than `--panning`
### Fixed
 - broken stdin pipe if running as root

## [3.6.1.4](https://github.com/mviereck/x11docker/blob/de1b34d32b5a08b269ebab5c7695d17f59eb16b7/x11docker) - 2017-08-19
### Changed
 - `beesu`: new frontend for `--pw` available on fedora
 - do not test for passwordless docker if `--pw` is set
 - create non-existing shared home folder for user different from host user if running as root
 - more verbose cache folder names, now with image name and X server in use
### Fixed
 - wrong file descriptor for messages before part init()
 - passwordless `sudo -n` on fedora did not work with x11docker-gui started from menu instead of cli, without `-n` is ok

## [3.6.1.3](https://github.com/mviereck/x11docker/blob/17dd6a39f5256be816cd22327a34f70e1845cf07/x11docker) - 2017-08-17
### Fixed
 - installer: did not find icon at new location

## [3.6.1.2](https://github.com/mviereck/x11docker/blob/53839badad3e440057cd5a2ef122b38616b50a95/x11docker) - 2017-08-15
### Changed
 - no `|tee` to $Xtermlogfile on `docker pull`: better interactive output
### Deprecated
 - `--resizeable`: Xephyr can crash if resized.

## [3.6.1.1](https://github.com/mviereck/x11docker/blob/133c26e737ac7936b894c30e01ee8f454374db97/x11docker) -2017-08-16
### Fixed
 - timeout 3600 for xauth cookie creation. Needed to avoid cookie timeout on `docker pull`

## [3.6.1](https://github.com/mviereck/x11docker/blob/cf56d6b5039c634934644051c6b75ea5218060ac/x11docker) - 2017-08-15
### Added
 - `--stdout`: show stdout of image command on stdout
 - `--stderr`: show stderr of image command on stderr
 - forward stdin of x11docker to image command
 - `--silent`: suppress all x11docker terminal messages
### Changed
 - x11docker-gui trys to use image `x11docker/kaptain` if `kaptain` is not installed

## [3.6.0.5](https://github.com/mviereck/x11docker/blob/1f309fa8970b972b58eaa22d03c43c958bc7d783/x11docker) - 2017-08-14
### Changed
 - `note()` instead of `warning()` for less urgent messages
### Fixed
 - opensuse: cookie creation failed due to different xauth behaviour
 - sudo: do not prompt for password for `docker stop` in `finish()`, rather fail stopping

## [3.6.0.4](https://github.com/mviereck/x11docker/blob/ae2e6ec386c43d724c635484bdc3b005ed42fcdf/x11docker) - 2017-08-14
### Fixed
 - do not complain about missing docker daemon on `--xonly`

## [3.6.0.3](https://github.com/mviereck/x11docker/blob/50b48ea0088c9f1742af0b4d97cac1e26db54699/x11docker) - 2017-08-13
### Changed
 - xpra dpi warning only if `--dpi` or `--scale` is set
 - cookie failure warning for untrusted cookies only
### Fixed
 - installer: remove older installations in `/usr/local/bin`

## [3.6.0.2](https://github.com/mviereck/x11docker/blob/0f2c38b69a0645f3c7df1ccae0e02389a5199631/x11docker) - 2017-08-13
### Changed
 - check for running docker daemon with $Dockerdaemon instead of ifconfig
 - do not disable SELinux if `--ipc` is set
### Fixed
 - fedora: `--xorg`: add `-keeptty` if running from tty
 - issue prevented `--xorg` from console if running in subshell
 - `finish()`: check for still running container with ps, too. formerly root only could detect it

## [3.6.0.1](https://github.com/mviereck/x11docker/blob/01baffa250c048988f64beeb4ddf05660a766639/x11docker) - 2017-08-12
### Fixed
 - `--gpu`: `:rw,z` does not work for `--device`

## [3.6.0](https://github.com/mviereck/x11docker/blob/d580a477617fb7d32da263a5408a82c01756fef1/x11docker) - 2017-08-12
### Added
 - `--rw` to allow read/write access to container root file system
 - `--pw` to choose password prompt frontend. default: `pkexec`
 - `--no-entrypoint` to disable ENTRYPOINT in image
 - `--hostuser` to set host user different from  $(logname)
 - `--desktop`: no longer deprecated, easier to understand and remember than `--wm=none`
### Changed
 - `-d`: used for `--desktop` again, no longer for `--dbus`. `--dbus` now has short opt `-b`
 - workaround: disabling SELinux for container until solution for sharing unix socket is found.
   Compare: http://www.projectatomic.io/blog/2015/06/using-volumes-with-docker-can-cause-problems-with-selinux/
 - install to `/usr/bin` instead of `/usr/local/bin` to support root
 - `chmod 755` instead of `+x` in installation
 - check if docker is installed
 - check if docker daemon is running (with ifconfig)
 - use zenity or notify-send if xmessage is not available in error()
 - replaced sed in xauth cookie creation, sed fails in openSUSE (!?)
 - check for xpra `--dpi` bug in 2.1 series
 - xpra `--start-via-proxy=no` for xpra >= 2.1
 - `--nxagent`: temporary `xhost +SI:localuser:$Hostuser` workaround as it fails again to authenticate, nxagent does not divide between `XAUTHORITY` and `--auth`
 - reduce dependency warnings for `--auto`
 - prefer $Hostenv instead of $Newxenv for password prompt -> better support for gksu
 - show `docker pull` output in a terminal window
 - allow `--hostdisplay` with `--xonly`. May at least be useful to create an untrusted cookie.
 - outsourced docker startup from xinitrc
 - copy host cookie into $Cachefolder for compatibility with gksu
 - use gksu/gksudo if available
 - `--showenv` for `--xonly`
 - `finish()`: try `docker stop $Containername`
 - dockerrc: no ps/sleep loop if running as root
 - don't start docker in xinitrc as xinit runs unprivileged
 - `--ps` keeps cache files, too (formerly container only)
 - improved X server check due to new variable $Desktopmode
 - `--fullscreen`. Set fullscreen screen size for windowed options (xpra),too
 - allow root to start x11docker, use `$(logname)` for X server and as container user
### Deprecated
 - `--root`: Can be achieved with `--hostuser=root`
 - `--no-password`: check if docker can run without password makes `--no-password` needless. Still possible with `--pw none`
### Fixed
 - `&, &&, ;, <, >, |` and the like possible in image command again
 - bugfixes in part "check window manager"
 - repeating error message if `waitforlogentry()` failed
 - cookie creation failed on X without extension Security. (fedora)

## [3.5.11](https://github.com/mviereck/x11docker/blob/27f52c9edb28518568e8f6881a1300ca4aea4f2b/x11docker) - 2017-07-12
### Changed
 - pull image if not available before calling `docker run`

## [3.5.10](https://github.com/mviereck/x11docker/blob/dbd85cfc9f26948ddf8e27075923ff673dc5a89b/x11docker) - 2017-07-12
### Fixed
 - regard `ENTRYPOINT` in dockerrc

## [3.5.9](https://github.com/mviereck/x11docker/blob/623c20b427b50fc16c127c760688cfbb556c0b8b/x11docker) - 2017-07-09
### Changed
 - `--home` with `--user=(unknown)`: only show warning (instead of error) not creating persistent home
 - do not set write permissions on `--home` or `--homedir` folder for different users than `$USER` or `--user`. (Not x11docker's job)
 - do not set `--read-only` if `--user=0`
### Fixed
 - chown x11docker_CMD to host user to avoid permission issues in $Sharefolder
 - `--user`: use matching gid, gid was set to same as uid

## [3.5.8](https://github.com/mviereck/x11docker/blob/fc88928119202eef80d6e3eba788fcd367dbc629/x11docker) - 2017-06-07
### Added
 - `--xhost STR`: to set `xhost STR` in xinitrc. 
 - `--xvfb` to explicitly use Xvfb and to clearly use Xdummy on `--xdummy`
### Changed
 - `--kwin-native`: always share Wayland (`--sharewayland` `--waylandenv` `--dbus`)
 - docker run `--read-only --volume=/tmp` to restrict container filesystem as read-only (except for `--sudouser`)
 - `--xorg` supports `--rotate`. (Xephyr could, but crashes -> Xephyr bug. Nxagent, Xdummy, Xvfb and Xwayland refuse this.)
 - Xdummy script in $Cachefolder forked from https://xpra.org/trac/browser/xpra/trunk/src/scripts/xpra_Xdummy
 - calculate VideoRam in xorg.xdummy.conf (instead of fat hardcoded 256000 kb)
### Deprecated
 - `--xhost+`: use `--xhost STR` instead.
### Fixed
 - `--nxagent`: due to update? must set nxagent -ac (=xhost +) temporary to allow xinit
 - allow `--wm` for `--kwin-xwayland`

## [3.5.7](https://github.com/mviereck/x11docker/blob/6d8a4cd471f31e7053a10390ab2ca3f90ae80239/x11docker) - 2017-06-28
### Changed
 - usage info for HTML5 web application setup
 - redirect verbose output to &3 to show it in subshells, too, and to avoid possible collision with read < <()
 - `--env`: set custom environment variables in dockerrc instead of in docker run
 - removed `unix` in $Newxenv for DISPLAY to make xpra ssh setup easier
 - Xdummy-Xwayland: new X server to provide `--gpu` for `--xdummy` based on weston, xwayland and xdotool
 - always enable extension Xtest on `--xdummy` to allow xpra access
 - share X socket to /tmp, create .X11-unix in dockerrc and softlink socket. This avoids writeable X11-unix in $Cachedir.
 - `--setwaylandenv`: env now set in dockerrc instead of docker command

## [3.5.6](https://github.com/mviereck/x11docker/blob/1f6496421f958d5ebf4fcf9abbe6e5d51d19f212/x11docker) - 2017-06-21
### Added
 - `--sudouser`: reincarnated option to give sudo without password to container user.
### Changed
 - docker command one-liner extended to dockerrc. dockerrc creates x11docker_CMD. Can always extract image command without additional password prompt and create some environment.
 - create `/tmp/XDG_RUNTIME_DIR` and softlink to wayland socket in container due to some KDE issues (`XDG_RUNTIME_DIR` must be owned by user). Fails with different `--user`
 - create `/tmp/.X11-unix` with 1777 in container to allow new X sockets (especially for startplasmacompositor). Drawback: container writeable folder in cache
 - warning with hint to use `--xpra-xwayland` if `--scale` is used with `--weston-xwayland`.
 - shorter sleep in finish()
 - don't search for deprecated `/tmp/x11docker` in checkorphaned()
### Fixed
 - avoid pointless warning about `XTEST` if not using xpra
 - typo preventing start of `--kwin` and `--kwin-native` (`-width` instead of `--width`)
 - bugfix parsing option `--wm`
 - `export $Hostxenv` in error() was empty if called in xtermrc

## [3.5.5.2](https://github.com/mviereck/x11docker/blob/547aea540aed165fc22def77724caccbd6424c63/x11docker) - 2017-06-10
### Changed
 - update usage info for `--xpra` and `--xpra-xwayland`

## [3.5.5.1](https://github.com/mviereck/x11docker/blob/1867023c5913a09ed63f98c3d28e9b19f1b332b2/x11docker) - 2017-06-10
### Fixed
 - bugfix in `--auto` always choosing `--xorg`

## [3.5.5](https://github.com/mviereck/x11docker/blob/e6021187f59caef2a49b36e02417ec79591c7f1d/x11docker) - 2017-06-09
### Changed
 - autochoose xpra-desktop if xephyr is missing
 - improved part: check virtual screen size
 - changed dpi calculation depending on xpra mode
 - desktop mode for xpra if `--wm` is given
 - always set `XDG_RUNTIME_DIR=/tmp` as some apps may expect it

## [3.5.4](https://github.com/mviereck/x11docker/blob/c09d6f3022ddf2c0ab6862e0f3db6ab6e9fa9c53/x11docker) - 2017-06-02
### Changed
 - disable extension `XTEST` if using wm from host (to avoid abuse of context menu of openbox and the like)
### Fixed
 - set rw access for `/dev/dri` ([#12](https://github.com/mviereck/x11docker/issues/12))

## [3.5.3](https://github.com/mviereck/x11docker/blob/870a63b67480caedb7645011666a325dbdbb8ce7/x11docker) - 2017-05-29
### Added
 - `--sharedir` replaces `--volume` to avoid confusion
### Changed
 - update `usage()`
 - mount $Sharefolder and its content read-only
 - remove X11-unix from $Sharefolder
 - set read-only for `/dev/dri` on `--gpu`
 - `--security-opt=no-new-privileges` added to docker run
### Deprecated
 - `--volume` is now called `--sharedir` due to different syntax than docker option `--volume`
### Fixed
 - `--pulseaudio`: get and use IP of container instead of docker0 IP range ([#11](https://github.com/mviereck/x11docker/issues/11)), disabling TCP module on exit

## [3.5.2](https://github.com/mviereck/x11docker/blob/d88d32605ece42324f14cf41e54482888ae539c4/x11docker) - 2017-05-22
### Added
 - `--volume` to share host folders

## [3.5.1](https://github.com/mviereck/x11docker/blob/4f1e4d14a904d499445fd479efb37b3c7cd46451/x11docker) - 2017-05-19
### Changed
 - user creation with `--addgroup video` to support non-systemd and kde-neon gpu support
 - create `/tmp/.X11-unix` with `1777`

## [3.5.0](https://github.com/mviereck/x11docker/blob/2f354525b3443250c3fe4c18ebfe4a3fc57f5ca0/x11docker) - 2017-05-17
### Added
 - `--output-count` to set amount if virtual screens/desktop windows for Weston, Kwin, Xephyr
 - `--westonini` to specify a custom weston.ini for `--weston` and `--weston-xwayland`
 - `--cachedir`:  specify custom cache folder
 - `--homedir`: specify host folder to share as home
 - `--trusted`: enforce trusted cookies for `--hostdisplay` and `--kwin-native`
 - `--user` to set user to use (name or uid, non-existing uids possible. default: host user)
 - `--cap-default`: Allow docker default capabilities
### Changed
 - avoid Terminal window with `--no-password`
 - `--orphaned` cleans /tmp/x11docker
 - `--env`: regard whitespaces, use \n to divide entrys
 - set `mode=preferred` for Weston on tty, ignore $Screensize
 - extension `XINERAMA` disabled as multiple Xephyr outputs cannot handle it well
 - create container home folder `/tmp/fakehome` in x11docker_CMD (avoids ownership problems with wine, and is less messy in /tmp)
 - more failure checks in `installer()`
 - check for `--userns-remap`, disabling it with `--userns=host` if `--home` or `--homedir` are set
 - minor exploit check for DISPLAY XAUTHORITY XDG_RUNTIME_DIR WAYLAND_DISPLAY HOME
 - automatically choose trusted or untrusted cookies
 - show docker log in xtermrc if pulling image
 - `docker run `--cap-drop=`ALL` as default
 - reduce `/etc/passwd` and `/etc/group` to container user and groups user and videp only (except root, keeps whole files).
 - creating container user similar to host user with docker run option `--user` and custom /etc/passwd instead of script createuser.
 - `--gpu`: only share `--device=/dev/dri` instead of listing all files in it
### Deprecated
 - `--cache`
### Removed
 - `--hostuser`: effect of `--hostuser` is default now
 - `--sudouser`: not possible anymore due to `--cap-drop=ALL`
### Fixed
 - `-s KILL` for weston on finish() avoids zombie weston window

## [3.2.1](https://github.com/mviereck/x11docker/blob/7600e599e757398d2e7ca3f53d4567f9286e31bb/x11docker) - 2017-05-05
### Fixed
 - `--scale` with `--xpra-xwayland` under X without Wayland failed

## [3.2.0](https://github.com/mviereck/x11docker/blob/32a9b75e0a7e6511b85dd2e01353adc77b76bfb9/x11docker) - 2017-05-04
### Added
 - `--scale`: for xpra and weston
 - `--rotate` for weston
 - `--dpi` for screen density
### Changed
 - allow MIT-SHM for `--exe`
### Fixed
 - checking screensize in Gnome-Wayland failed looking for primary display, window was not roughly maximized
 - missing `error()` in xinitrc

## [3.1.16](https://github.com/mviereck/x11docker/blob/bab08db10c8b4d360c58ec7c7bb42a6fa6567b69/x11docker) - 2017-05-03
### Fixed
 - bugfix for `--xpra-wayland` in check for `WAYLAND_DISPLAY`

## [3.1.15](https://github.com/mviereck/x11docker/blob/58536075aec99859ad212f7377724a5b60cb3dd6/x11docker) - 2017-05-02
### Changed
 - faster startup for `--xpra-xwayland`, `--weston-xwayland`, `--kwin` and `--kwin-xwayland`
 - code cleanup
### Fixed
 - bugfix in choosing terminal, replace $Waylandterminal with $Terminal in re-check
 - bugfix xtermrc and xinitrc: check if $Dockerpidfile is not empty

## [3.1.14](https://github.com/mviereck/x11docker/blob/af37faddec2642e44a0c586ac9c84694c9989fad/x11docker) - 2017-05-01
### Changed
 - checkorphaned() uses container names instead of numbers
### Fixed
 - `--exe`: reliable kill $Hostexe, even with `--weston`* and `--kwin`*
 - remove `:` and `/` from image name in $Containername

## [3.1.13](https://github.com/mviereck/x11docker/blob/e8e428edbb259d1d317a52fb43ee7be25e5b2cf7/x11docker) - 2017-04-30
### Changed
 - Improved multimonitor support (still missing: multihead)
 - removed $Cidfile at all, cleanup hint in finish() with $Containername
### Fixed
 - redirection of stderr without cat, avoids broken pipe on ctrl-c in ubuntu and opensuse
 - removed custom socket in xpra (failed in opensuse)
 - avoid root ownership for $Dockerlogfile and $Dockerpidfile

## [3.1.12](https://github.com/mviereck/x11docker/blob/06fc8fc7f4bf2945692c8b38476e76b760bd8877/x11docker) - 2017-04-29
### Changed
 - clean up confusion with x11docker.log
 - don't share $Xclientcookie as $Sharefolder is already shared
 - don't use $Cacherootfolder for parsererror
 - hint to use `--sudo` on some systems
 - use `id -g` instead of $Benutzer for group name
 - add `lsb-release -ds` to verbose output
### Fixed
 - include `warning()` in xinitrc
 - bugfix in xinitrc for `--no-xhost`

## [3.1.11](https://github.com/mviereck/x11docker/blob/0248fd878cdb1b1cacd42758f883ea4dc75d0c27/x11docker) - 2017-04-29
### Changed
 - disabled $Cidfile as not important and due to [#10](https://github.com/mviereck/x11docker/issues/10)

## [3.1.10](https://github.com/mviereck/x11docker/blob/969494282073ef5098820325472ac02872c7c5f6/x11docker) - 2017-04-28
### Fixed
 - check for xenial instead of 16.04/xvfb
 - set XPRA_XSHM=0 on Shareipc=no
 - disable `--desktop-scaling` in xpra, not supported before xpra v1.x

## [3.1.9](https://github.com/mviereck/x11docker/blob/c1eb6a60fab62bc7a10cb97020e36bf9bdb8a8ed/x11docker) - 2017-04-27
### Changed
 - don't create Cacherootfolder in variable definitions
 - check for Xvfb on Ubuntu 16.04

## [3.1.8](https://github.com/mviereck/x11docker/blob/3f4a54c01d340293a8c831b0a0757c2a97326aa2/x11docker) - 2017-04-25
### Changed
 - Add advice for `--xorg` how to setup xserver-xorg-legacy

## [3.1.7](https://github.com/mviereck/x11docker/blob/85bb3e72ae449b2057f93390a2bbfdb86a89286a/x11docker) - 2017-04-25
### Changed
 - `--xpra` and `--xdummy` now use Xvfb if installed. Compare #9, Xdummy cannot be used on Ubuntu 16.04 due to xorg.conf location
 - set $Windowmanager in auto choosing X server if switching to desktop windows

## [3.1.6](https://github.com/mviereck/x11docker/blob/2623286e141ddb4aec6a7b5162cafbb19b5c6e6c/x11docker) - 2017-04-21
### Fixed
 - `--nxagent`: don't close nxagent on every call of nxclient (2)

## [3.1.5](https://github.com/mviereck/x11docker/blob/a13bd270d1146ad6fedcfbb1c2ccf1583531e0d5/x11docker) - 2017-04-20
### Fixed
 - `--nxagent`: don't close nxagent on every call of nxclient

## [3.1.4](https://github.com/mviereck/x11docker/blob/b2641dbd874e8df51762a31c6a6d2e5344bd9efa/x11docker) - 2017-04-19
### Changed
 - `--nxagent` supports untrusted cookies
### Fixed
 - don't set dpi if xdpyinfo fails

## [3.1.3](https://github.com/mviereck/x11docker/blob/06e021a0dae63eef02661420942b8430f7dcca42/x11docker) - 2017-04-18
### Changed
 - `--nxagent` cookie workaround as it ignores XAUTHORITY on option -auth
 - `--nxagent` workaround to terminate on pressing window close button -> fake nxclient
### Fixed
 - typo in finish() looking for docker pid

## [3.1.2](https://github.com/mviereck/x11docker/blob/289017045514d966a5f378b4649fbd2606a03c9a/x11docker) - 2017-04-18
### Changed
 - `--nxagent` sets right keyboard layout, thanks to Ulrich!

## [3.1.1](https://github.com/mviereck/x11docker/blob/dbb3c60d525c372906e5f75fb464f8cd0f466a87/x11docker) - 2017-04-18
### Changed
 - `--nxagent` now supports `--size`, `--fullscreen` and `--clipboard`, thanks to Ulrich Sibiller from Arctica!
 - check dpi from host and set this to new X server
 - xpra xmessage to be patient
 - disabled keyboard adjusting for `--nxagent`

## [3.1.0](https://github.com/mviereck/x11docker/blob/60b704f068fe99e64b873c8fe4fc0ae6da35ab87/x11docker) - 2017-04-16
### Added
 - `--nxagent` for X server `nxagent`

## [3.0.0](https://github.com/mviereck/x11docker/blob/a62b2f47472ab60b98d2a2471135e0e33fa46757/x11docker) - 2017-04-15
### Added
 - Wayland support.
 - `--wayland`: auto setup for pure Wayland applications
 - `--weston` for pure Wayland applications
 - `--kwin` for pure Wayland applications
 - `--xpra-xwayland`: new X server option to run xpra with GPU acceleration
 - `--kwin-xwayland`: new X server option
 - `--weston-xwayland`: new X server option, allows GPU acceleration
 - `--xwayland`: new X server option
 - `--nothing`: Provide no X or Wayland server
 - `--sharewayland`: Share host wayland socket and set WAYLAND_DISPLAY
 - `--setwaylandenv`: setting environment variables for toolkits like QT and GTK to use wayland
 - `--env`: set custom environment variables (formerly `--env` had role of new `--showenv`)
 - `--dbus`: run image command with `dbus-launch`
 - `--xhost+`: set `xhost +` on new X server
 - `--showenv`: formerly `--env`, show environment variables to access new X server
### Changed
 - second stderr `&3` to show warnings and errors also from within xinitrc and xtermrc
 - error messages on docker startup failure in xtermrc
 - `xdummy.conf` or `--xpra`: custom modeline setting fitting to actual resolution
 - `--xdummy` regards `--size`
 - x11docker_CMD checks if ps is available
 - `--wm` changed, autochoosing no longer default
 - `chmod 1777 /tmp/X11-unix` to allow creation of X sockets in container (needed e.g. for `startplasmacompositor`)
 - `--verbose` output much more reliebale now, tail improved
 - use prefix `unix` for `DISPLAY` to disable `MIT_SHM` instead using other environment variables
 - create dektop starter with basename instead of $0
 - createuser: start with `--user=0` to allow `useradd` and `su`
 - reverse order of killing of bgpids in finish(),last one first, to catch possible further output with tail -F
 - Newdisplaynumber for xorg starts with `8`
 - xinitrc: `XPRA_OPENGL_DOUBLE_BUFFERED=1` to avoid xpra bug 1469
 - check and set `XDG_RUNTIME_DIR` for weston and Xwayland
### Removed
 - `--virtualgl`, `--dockerenv`, `--xpra-image`, `--xorg-image`, `--xdummy-image`, `--tcp` `--tcpxsocket` `--xsocket`, `--glamor`, `--sharegpu`, `--desktop`, `--xhost`
