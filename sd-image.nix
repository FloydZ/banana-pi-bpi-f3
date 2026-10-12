{ config, lib, pkgs, modulesPath, ... }:

let firmware = pkgs.callPackage ./firmware.nix { };
in {
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/installer/sd-card/sd-image.nix"
    ./default.nix
  ];

  image.baseName =
    "nixos-image-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}-banana-pi-bpi-f3";

  # ZFS does not build against the vendor kernel and is not needed here
  boot.supportedFilesystems.zfs = lib.mkForce false;

  # all-hardware.nix requests initrd modules the vendor kernel does not provide
  nixpkgs.overlays = [
    (final: prev: {
      makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  # U-Boot's fdtfile points at its own SPL device tree, so name the kernel one
  # explicitly in extlinux.conf. The BPI-F3 is SpacemiT's "deb1" reference board.
  hardware.deviceTree.name = "spacemit/k1-x_deb1.dtb";

  sdImage = {
    populateFirmwareCommands = "";

    firmwarePartitionOffset = 4;
    firmwareSize = 4;

    # Boot chain in the gap before the first partition (4 MiB), same layout as
    # armbian: bootinfo in sector 0 (80 bytes, the MBR partition table at 446
    # stays intact), FSBL (U-Boot SPL) at sector 1, OpenSBI at 640K, U-Boot at 1M.
    postBuildCommands = ''
      check_fits() { # file, first sector, end sector
        size=$(stat -c %s "$1")
        if [ $(( $2 * 512 + size )) -gt $(( $3 * 512 )) ]; then
          echo "$1 ($size bytes) does not fit between sector $2 and $3" >&2
          exit 1
        fi
      }
      # must not reach the MBR disk signature/partition table at byte 440
      if [ $(stat -c %s ${firmware.uboot}/bootinfo_emmc.bin) -gt 440 ]; then
        echo "bootinfo_emmc.bin would overwrite the MBR" >&2
        exit 1
      fi
      check_fits ${firmware.uboot}/FSBL.bin 1 1280
      check_fits ${firmware.opensbi}/fw_dynamic.itb 1280 2048
      check_fits ${firmware.uboot}/u-boot.itb 2048 $(( ${toString config.sdImage.firmwarePartitionOffset} * 2048 ))

      dd conv=notrunc if=${firmware.uboot}/bootinfo_emmc.bin of=$img bs=512
      dd conv=notrunc if=${firmware.uboot}/FSBL.bin of=$img bs=512 seek=1
      dd conv=notrunc if=${firmware.opensbi}/fw_dynamic.itb of=$img bs=512 seek=1280
      dd conv=notrunc if=${firmware.uboot}/u-boot.itb of=$img bs=512 seek=2048
    '';

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };

  # environment.systemPackages = [ firmware.updater-flash ];
}
