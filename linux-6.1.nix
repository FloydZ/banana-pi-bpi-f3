{ buildLinux
, fetchgit
, kernelPatches
, lib, ... } @ args:

let
  modDirVersion = "6.6.36";
in
buildLinux (args // {
    #inherit kernelPatches modDirVersion;
  inherit modDirVersion;
  version = "${modDirVersion}";
  src = fetchgit {
    url = "https://github.com/BPI-SINOVOIP/pi-linux";
    rev = "7b25153f8744304c5212d1d4de4dbf51e9e2eb7e";
    hash = "sha256-dnB6Y+MfCBXmlSdnLPdAQOlLHYg9KmTIdV5MzgSk2YU=";
  };
  kernelPatches = kernelPatches ++ [
    {
      name = "fix_build";
      patch = ./kernel.patch;
    }
  ];

  defconfig = "k1_defconfig";
    #configFile = ./k1_defconfig;
  extraMeta.branch = "linux-6.6.36-k1";
  structuredExtraConfig = with lib.kernel; {
    CMDLINE = freeform "console=ttyS0,115200 console=tty1";
    CMDLINE_EXTEND = yes;
    DISTRO_GENERIC_KERNEL = no;
    COMPILE_TEST=no;

    WLAN_VENDOR_REALTEK = no;

    SOC_SPACEMIT_K1X = yes;
    MMC_SDHCI_OF_K1X = yes;
    RESET_K1X_SPACEMIT=yes;
    SPI_K1X=yes;
    SPI_K1X_QSPI=yes;
    GPIO_K1X=yes;

    SOC_SPACEMIT_K1PRO = no;
    MMC_SDHCI_OF_K1PRO = no;
    K1PRO_MAILBOX = no;
    K1PRO_REMOTEPROC = no;
    PWM_DWC_K1PRO = no;
      
    SPI_DESIGNWARE_EXT = no;
  };
} // (args.argsOverride or { }))
