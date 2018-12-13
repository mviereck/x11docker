---
title: 'x11docker: Run GUI applications in Docker containers'
tags:
  - docker
  - graphical user interface
  - software development
  - software deployment
  - sandbox
author:
  - name: Martin Viereck
    orcid: 0000-0002-4532-4020
date: 13 December 2018
---

# Summary
[x11docker](https://github.com/mviereck/x11docker) allows to run graphical applications in Docker Linux containers.
 - [Docker](https://en.wikipedia.org/wiki/Docker_(software)) allows to run applications in an isolated [container](https://en.wikipedia.org/wiki/Operating-system-level_virtualization) environment. 
   The result is similar to a [virtual machine](https://en.wikipedia.org/wiki/Virtual_machine), but needs less resources.
 - Docker does not provide a [display server](https://en.wikipedia.org/wiki/Display_server) that would allow to run applications with a [graphical user interface](https://en.wikipedia.org/wiki/Graphical_user_interface).
 - x11docker fills the gap. It runs an [X display server](https://en.wikipedia.org/wiki/X_Window_System) on the host system and provides it to Docker containers.
 - Additionally x11docker does some [security setup](https://github.com/mviereck/x11docker#security) to enhance container isolation and to avoid X security leaks. 
   This allows a [sandbox](https://en.wikipedia.org/wiki/Sandbox_(computer_security)) environment that fairly well protects the host system from possibly malicious or buggy software.

Software can be installed in a deployable Docker image with a rudimentary Linux system inside. 
This can help to run or deploy software that is difficult to install on several systems due to dependency issues. 
It is possible to run outdated versions or latest development versions side by side. 

x11docker runs on Linux and (with some setup) on MS Windows. x11docker is not adapted to run on macOS.
