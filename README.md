# windowrun
A fzf-based app launcher. Written with shell and python.
I might start updating it so it fits for more people's uses

Only needs:
- Python installed
- fzf tool installed

Warning: it was made to work with foot terminal in mangowm+Fedora, it does not cover edge cases depending on your Distro/OS or anything.

## Config
I usually leave the windowrun.sh and the finder.py inside ~/.scripts/, if you don't, you might need to update the scripts (I've wrote them a year ago and don't remember how it is configured)

you can create a config file in ~/.config/windowrun/config.jsonc

this file can set excluded .desktop entries or attach keywords in the name of the app in the launcher, so keyword usage is possible.

ex:

```
{
  "keywords": {
    "helium.desktop": ["web browser"]
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

