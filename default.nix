{
  pkgs,
  config,
  lib,
  ...
}:
{
  boot = {
    # consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault (pkgs.callPackage ./linux-6.1.nix {
      inherit (config.boot);
    });
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
