# windowrun

## [Warning] New update:
- Now there is a install.sh script
- Project is supposed to be rounder for all distros and terminals
- This project will be rewritten in Go later to have better binaries

## About and requirements

A fzf-based light app launcher written with shell and python.
I might start updating it so it fits for more people's uses

Only needs:
- Following needs to be installed:
  - python
  - bash
  - fzf
- $TERMINAL variable set up to your preferred terminal emulator

## Installation
You can either clone the repository or run the install script with the command below:
```
curl -fsSL https://raw.githubusercontent.com/lucas-farias07/windowrun/main/install.sh | bash
```
The script already symlinks to .local/bin for calling windowrun on shell.

## Configuration
You can create a config file in ~/.config/windowrun/config.jsonc

This file can set excluded .desktop entries or attach keywords in the name of the app in the launcher, so keyword usage is possible.

ex:

```
{
  "keywords": {
    "firefox.desktop": ["web browser"]
  },
  "excluded": [
    "thunar-bulk-rename.desktop",
    "thunar-settings.desktop",
    "panel-desktop-handler.desktop",
    "panel-preferences.desktop",
    "footclient.desktop",
    "foot-server.desktop"
  ]
}

```

