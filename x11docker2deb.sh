#!/bin/bash
VERSION=${VERSION:-0}
echo $VERSION
mkdir -p x11docker-deb/usr/bin
cp ./x11docker ./x11docker-deb/usr/bin
mkdir -p x11docker-deb/DEBIAN
cat > ./x11docker-deb/DEBIAN/copyright << EOF
MIT License

Copyright (c) 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022 Martin Viereck

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
cat > ./x11docker-deb/DEBIAN/control << EOF
Package: x11docker
Version: $VERSION
Architecture: all
Priority: optional
Depends: bash
Recommends: nxagent, xserver-xephyr, xdotool, xauth, xinit, xclip, xutils
Suggests: docker, podman, weston, xwayland
Maintainer: CicadaSeventeen <https://github.com/CicadaSeventeen>
Description: Run GUI applications and desktops in Linux containers
EOF
dpkg -b ./x11docker-deb x11docker.deb
