{
  #inputs.nixpkgs.url = "nixpkgs/master";
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  # Some dependencies of this flake are not yet available on non linux systems
  inputs.flake-utils.url = "github:numtide/flake-utils";
  # inputs.flake-utils.inputs.systems.follows = "systems";

  outputs = { self, nixpkgs, flake-utils, ... }:
  let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "riscv64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSupportedSystems = nixpkgs.lib.genAttrs supportedSystems;
      # packageOverrides = pkgs: {
      #   samba = pkgs.samba.override {
      #     disallowedReferences = [];
      #   };
      # };

  in {
      packages = forAllSupportedSystems (system: rec {
        default = sd-image;
        sd-image = (import "${nixpkgs}/nixos" {
          configuration =
            { config, pkgs, ... }: {
              imports = [
                ./sd-image.nix
                # ./sd-image-installer.nix
              ];

              nixpkgs.overlays = [
                (final: prev: {
                  samba = prev.samba.overrideAttrs (old: {
                    disallowedReferences = [];
                  });
                })
              ];

              nixpkgs.crossSystem = {
                config = "riscv64-unknown-linux-gnu";
                system = "riscv64-linux";
              };
              # If you want to use ssh set a password
              users.users.duda = {
                isNormalUser = true;
                uid = 1000;

                extraGroups = [ 
                  "networkmanager" 
                  "wheel" 
                  "docker" 
                  "audio" 
                  "video" 
                  "docker" 
                  "plugdev"
                  "apex"
                ];
                packages = with pkgs; [
                  #neovim 
                ];
                openssh.authorizedKeys.keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNaQO7Tknfy/4OzICilC7eOvpL17pzysvpfOpemGS6y floyd.zweydinger@rub.de"
                ];
              };

              # AND configure networking
              #networking.interfaces.end0.useDHCP = true;
              #networking.interfaces.end1.useDHCP = true;

              # Additional configuration goes here
              sdImage.compressImage = false;
              system.stateVersion = "24.11";
            };
          inherit system;
        }).config.system.build.sdImage;
      });
    };
}
