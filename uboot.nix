{ buildUBoot
, fetchFromGitHub
}:

# SpacemiT K1 vendor U-Boot. The patches 0xx are taken from
# https://github.com/BPI-SINOVOIP/armbian-build (patch/u-boot/legacy/u-boot-spacemit-k1),
# they add MBR support to the SPL and switch the environment to extlinux booting.
buildUBoot {
  version = "2022.10-k1-bl-v2.2.9";
  src = fetchFromGitHub {
    owner = "pyavitz";
    repo = "spacemit-u-boot";
    rev = "d61c8c77e241314438dce31d9ff1b1cbd9d53688"; # k1-bl-v2.2.9-release
    hash = "sha256-hYrA0lwZGn0IfzWp6CGghtPK7c85WG69Upd25ie+vbQ=";
  };

  extraPatches = [
    ./patches/u-boot/001-MBR-support.patch
    ./patches/u-boot/002-SpacemiT-K1X-Fixups.patch
    ./patches/u-boot/003-SpacemiT-K1X-Defconfig-Fixups.patch
    ./patches/u-boot/004-Update-SpacemiT-K1-U-Boot-Environment.patch
    ./patches/u-boot/007-efi_loader-suppress-error-print-message.patch
    ./patches/u-boot/008-Quiet-MBR-support.patch
    ./patches/u-boot/009-Fixup-circular-deps.patch
    ./patches/u-boot/100-nixos-scan-root-partition.patch
  ];

  defconfig = "k1_defconfig";
  # same as armbian's bananapif3.conf
  extraConfig = ''
    CONFIG_SD_BOOT=y
    CONFIG_EXT4_WRITE=y
    CONFIG_FS_BTRFS=y
    CONFIG_CMD_BTRFS=y
    CONFIG_SPI_FLASH_USE_4K_SECTORS=y
  '';

  filesToInstall = [
    "bootinfo_emmc.bin"
    "bootinfo_sd.bin"
    "bootinfo_spinor.bin"
    "FSBL.bin"
    "u-boot.itb"
    "u-boot-env-default.bin"
  ];
}
