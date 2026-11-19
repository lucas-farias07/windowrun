{
  description = "windowrun - a light, fzf-based app launcher written in Go";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in {
      packages = forAllSystems (pkgs: rec {
        windowrun = pkgs.buildGoModule {
          pname = "windowrun";
          version = "0-unstable";
          src = ../.;
          vendorHash = "sha256-BPpDRic8qmm0RCyvwOkVE6E06HTu1gR4z3aUBkutgc8=";

          nativeBuildInputs = [ pkgs.makeWrapper ];
          postInstall = ''
            wrapProgram $out/bin/windowrun --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.fzf ]}
          '';

          meta = {
            description = "Light, fzf-based app launcher";
            homepage = "https://github.com/lucas-farias07/windowrun";
            license = pkgs.lib.licenses.mit;
            mainProgram = "windowrun";
          };
        };
        default = windowrun;
      });

      overlays.default = final: _prev: {
        windowrun = self.packages.${final.stdenv.hostPlatform.system}.windowrun;
      };

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell { packages = [ pkgs.go pkgs.fzf ]; };
      });
    };
}
