# 🚀 windowrun

A light, fzf-based app launcher written in Go.

[Requirements](#-requirements) · [Installation](#-installation) · [Configuration](#-configuration)

> [!WARNING]
> This project is completely **W.I.P.** and the Go version is **NOT** ready.

## 📖 About

windowrun is a lightweight app launcher built on top of [fzf](https://github.com/junegunn/fzf) and written in Go.

## 📋 Requirements

| Requirement | Details |
| --- | --- |
| **Go** | 1.27.3 or newer |
| **fzf** | Fuzzy finder used for the launcher UI |
| **`$TERMINAL`** | Environment variable set to your preferred terminal emulator |

## 📦 Installation

You can either clone the repository and build it, or run the install script:

```bash
curl -fsSL https://raw.githubusercontent.com/lucas-farias07/windowrun/windowrun-go/install.sh | bash
```

The script already symlinks the binary into `~/.local/bin`, so you can call `windowrun` straight from your shell.

## 🔧 Configuration

Create a config file at `~/.config/windowrun/config.jsonc`.

It lets you:

- 🚫 **Exclude** `.desktop` entries so they don't show up in the launcher.
- 🔎 **Attach keywords** to an app's name in the launcher, so you can search by something other than the app's name.

| Key | Type | Description |
| --- | --- | --- |
| `keywords` | object | Maps a `.desktop` file to a list of extra search keywords |
| `excluded` | array | `.desktop` files to hide from the launcher |

### 📝 Example

```jsonc
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
