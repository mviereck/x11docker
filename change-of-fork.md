1. now `--install` `--update*` `--remove` and `--launcher` can be use without detecting the backend
2. add a variable `Installermode_Disabled` to disable `--install` `--update*` `--remove` for packaging
3. add a man by `help2man`
4. add a script to auto-packaging `.deb` (I do not know if an auto rpm packager is possible, for openSUSE, Fedora... can have deference package name for dependency )
5. add a `.deb`. Depends is corrected as 'docker.io | podman', x11 dependency is in Recommends ,wayland dependency is in Suggest. 
