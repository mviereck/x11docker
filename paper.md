---
title: 'x11docker: Run GUI applications in Docker containers'
tags:
  - docker
  - graphical user interface
  - software development
  - software deployment
  - sandbox
  - reproducibility
  - reproducible research
  - prototyping
author:
  - name: Martin Viereck
    orcid: 0000-0002-4532-4020
date: 13 December 2018
bibliography: paper.bib
---

# Summary

[`x11docker`](https://github.com/mviereck/x11docker) allows to run graphical applications in a [Linux container](https://en.wikipedia.org/wiki/Operating-system-level_virtualization) using [Docker](https://en.wikipedia.org/wiki/Docker_(software)).

Containerisation in general has proven as a useful technology for packaging applications and their dependencies for deployment in cloud-based infrastructures.
A container is similar in usage to a [virtual machine](https://en.wikipedia.org/wiki/Virtual_machine), but needs less resources. The technical concept, however, is completly different.
The properties of containers such as portability, dependency packaging, reduced requirements of system environment (i.e. only the container runtime), isolation, and version management of complete application stacks make it a promising candidate to increase computational reproducibility and reusability of research analyses [@boettiger_introduction_2015].
Their use has been demonstrated in various disciplines, such as software engineering research [@cito_using_2016], bioinformatics [@hosny_algorun_2016], and archeology [@marwick_computational_2017], and their preservation is an active field of research [@Kratzke_Heuveline_2017,@emsley_framework_2018].
Software and required libraries can be installed in a Docker image to run software that is difficult to install otherwise. It is possible to run outdated versions, specific versions, or latest development code side by side.

The most popular Linux container frontend, Docker, does not provide a [display server](https://en.wikipedia.org/wiki/Display_server) that would allow to run applications with a [graphical user interface](https://en.wikipedia.org/wiki/Graphical_user_interface) (GUI), because Docker is originally built for server software.
`x11docker` fills this gap.
It allows to execute [Desktop](https://en.wikipedia.org/wiki/Desktop_environment) GUI applications in an isolated environment by running an [X display server](https://en.wikipedia.org/wiki/X_Window_System) on the host system and providing it to applications in Docker containers.
Additionally, x11docker has a specific [security setup](https://github.com/mviereck/x11docker#security) to enhance container isolation from host system and to avoid [X security leaks](http://tutorials.section6.net/home/basics-of-securing-x11).
`x11docker` thereby facilitates quick creation, distribution, and evaluation of research prototypes without compromising on a researcher's preferences (e.g. for a specific operating system), skills (not imposing browser-based GUI nor requiring command-line proficiency), domain (having e.g. established and widely-acknowledged GUI-based tools), security, computational reproducibility, or a scholarly review process.

Alternatives to x11docker:
A common way to allow GUI applications in containers is by providing a web server within the container and rendering an HTML-based GUI in a common web browser, e.g. as notebooks [@jupyter2018binder]. Further possibilities are a VNC server, SSH server or xpra server within the container.
These solutions require some specific setup and provide a rather slow interaction due to a lot of network data transfer. 
x11docker provides a unified setup and a fast interaction due to direct access of GUI applications to the X display server.

`x11docker` runs on Linux and with few limitations on MS Windows. Support for macOS is scheduled.
It has its own graphical frontend, `x11docker-gui`, and can be configured to access the host machine's GPU, webcam, or audio system. It also allows access to files created by container applications.

# References
