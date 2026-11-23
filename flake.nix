{
  description = "storenode-messages-counter dev environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            go_1_26
            gopls
            govulncheck
            golangci-lint
            gnumake
          ];

          shellHook = ''
            # Use the Nix-provided Go, never auto-download a toolchain
            export GOTOOLCHAIN=local
          '';
        };
      });
    };
}