{ buildUBoot
, opensbi
}:

buildUBoot {
  src = {
    owner = "BPI-SINOVOIP";
    repo = "pi-u-boot.git";
    rev = "v2022.10-k1";
    hash = "";
  };
  # extraMakeFlags = [
  #   "OPENSBI=${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin"
  # ];
  # defconfig = "starfive_visionfive2_defconfig";

  filesToInstall = [
    "spl/u-boot-spl.bin.normal.out"
    "u-boot.itb"
  ];
}
