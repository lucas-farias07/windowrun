# 🚀 windowrun

A light, fzf-based app launcher written in Go.

[Requirements](#-requirements) · [Installation](#-installation) · [Configuration](#-configuration)

> [!WARNING]
> First Release of the Go version! Expect improvements and features.

## 📖 About

windowrun is a lightweight app launcher built on top of [fzf](https://github.com/junegunn/fzf) and written in Go.

## 📋 Requirements

| Requirement | Details |
| --- | --- |
| **Go** | 1.26.0 or newer (only to build) |
| **fzf** | Fuzzy finder used for the launcher UI |
| **`$TERMINAL`** | Environment variable set to your preferred terminal emulator |

## 📦 Installation

### Nix / NixOS

Try it without installing:
```bash
nix run 'github:lucas-farias07/windowrun?dir=packaging'
```

Or add it to your `flake.nix`:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    windowrun = {
      url = "github:lucas-farias07/windowrun?dir=packaging";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, windowrun, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            windowrun.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        })
      ];
    };
  };
}
```
`fzf` is bundled by the package, so you don't need to install it separately. The same package works in Home Manager's `home.packages`.

### Other distros

You can either clone the repository and build it, or run the install script.

#### Install script
```bash
curl -fsSL https://raw.githubusercontent.com/lucas-farias07/windowrun/main/install.sh | bash
```

#### Clone & build
Remember to clone the repository to the desired folder location.

1. Clone the repository:
```bash
git clone https://github.com/lucas-farias07/windowrun.git
```

2. Run go build:
```bash
cd windowrun && go build -o bin/windowrun .
```

3. *(Optional)* Add to PATH. Make sure `~/.local/bin` is in your PATH:
```bash
mkdir -p ~/.local/bin
ln -sf "$(pwd)/bin/windowrun" ~/.local/bin/windowrun
```

All together:
```bash
git clone https://github.com/lucas-farias07/windowrun.git
cd windowrun && go build -o bin/windowrun .
mkdir -p ~/.local/bin
ln -sf "$(pwd)/bin/windowrun" ~/.local/bin/windowrun
```

## 🔧 Configuration

Create a config file at `$XDG_CONFIG_HOME/windowrun/config.jsonc` (defaults to `~/.config/windowrun/config.jsonc`).

It lets you:

- 🚫 **Exclude** `.desktop` entries so they don't show up in the launcher.
- 🔎 **Attach keywords** to an app's name in the launcher, so you can search by something other than the app's name.

| Key | Type | Description |
| --- | --- | --- |
| `base` | object | Holds the core settings below |
| `base.keywords` | object | Maps a `.desktop` file to a list of extra search keywords |
| `base.excluded` | array | `.desktop` files to hide from the launcher |
| `extensions` | array | Reserved for future use (currently unused) |

### 📝 Example

```jsonc
{
  "base": {
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
  },
  "extensions": []
}
```

##### Extensions:
I am planning on ading extensions to windowrun similar to how I did windowrun-extended for the old version. But I still need to learn more stuff about go (don't want to be Ai-assisted forever) before going in-depth in an extension system.
