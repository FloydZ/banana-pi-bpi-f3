{ pkgs,
  config,
  lib,
  ...
}:
{
  boot = {
    # consoleLogLevel = lib.mkDefault 7;
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./linux-6.1.nix {
      #kernelPackages = lib.mkDefault (pkgs.callPackage ./linux-6.1.nix {
      inherit (config.boot) kernelPatches;
    });
    # same as armbian's bananapif3 extraargs
    kernelParams = [
      "console=tty1"
      "console=ttyS0,115200n8"
      "earlycon=sbi"
      "clk_ignore_unused"
      "pcie_aspm=off"
    ];
    #initrd.availableKe3rnelModules = [ "dw_mmc_starfive" ];

    # Support booting SD-image from NVME SSD
    #initrd.kernelModules = [
    #  "clk-starfive-jh7110-aon"
    #  "clk-starfive-jh7110-stg"
    #  "phy-jh7110-pcie"
    #  "pcie-starfive"
    #  "nvme"
    #];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };
}
