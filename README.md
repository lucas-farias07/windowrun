# windowrun
A fzf-based app launcher. Written with shell and python.


Only needs:
- Python installed

Warning: it was made to work with foot terminal in mangowm+Fedora, it does not cover edge cases depending on your Distro/OS or anything.

## Config

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

