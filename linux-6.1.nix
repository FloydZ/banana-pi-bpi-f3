{ buildLinux
, fetchgit
, kernelPatches
, lib, ... } @ args:

let
  modDirVersion = "6.6.36";
in
buildLinux (args // {
  inherit kernelPatches modDirVersion;
  version = "${modDirVersion}-k1";
  src = fetchgit {
    url = "https://github.com/BPI-SINOVOIP/pi-linux";
    rev = "7b25153f8744304c5212d1d4de4dbf51e9e2eb7e";
    hash = "sha256-dnB6Y+MfCBXmlSdnLPdAQOlLHYg9KmTIdV5MzgSk2YU=";
  };

  defconfig = "k1_defconfig";
  extraMeta.branch = "linux-6.6.36-k1";
  structuredExtraConfig = with lib.kernel; {
    CMDLINE = freeform "console=ttyS0,115200 console=tty1";
    CMDLINE_EXTEND = yes;
    DISTRO_GENERIC_KERNEL = no;
  };
} // (args.argsOverride or { }))


#{ lib
#, callPackage
#, linuxPackagesFor
#, ... }:
#
#let
#  modDirVersion = "6.6.36";
#  linuxPkg = { lib, fetchgit, fetchFromGitHub, buildLinux, kernelPatches, ... } @args:
#    buildLinux (args // {
#      inherit modDirVersion kernelPatches;
#      version = "${modDirVersion}-k1";
#      # modDirVersion = "6.1.15";
#      # branch linux-6.1.15-k1-dev
#      #src = fetchgit {
#      #  url = "https://github.com/BPI-SINOVOIP/pi-linux/";
#      #  rev = "b1d74b54298af0c475972d106704195cdd0ad9dc";
#      #  hash = "sha256-6jS+nUzcfs5+Z5IqX4L7JUq+GgL+1oycaMYu/qblCaM=";
#      #};
#      #src = fetchgit {
#      #  url = "https://github.com/cyyself/bpi-linux/";
#      #  rev = "7d6cbadbfb0210533a31c1089d74598b0550357a";
#      #  hash = "sha256-oQQNULAN0+wtL471TYYnwBMuSWgJJH8d5cFHx55PrMo=";
#      #};
#      # branch linux-6.1.15-k1
#      #src = fetchgit {
#      #  url = "https://github.com/BPI-SINOVOIP/pi-linux/";
#      #  rev = "eb4e73284582351b02517a157f39d8366ccb57c5";
#      #  hash = "sha256-FhQjJs9PGE0TwP+ci/WUL0ySC5r45afvXPxOdNTh+ZQ=";
#      #};
#      # branch 6.6.36-k1
#      src = fetchgit {
#        url = "https://github.com/BPI-SINOVOIP/pi-linux";
#        rev = "7b25153f8744304c5212d1d4de4dbf51e9e2eb7e";
#        hash = "sha256-dnB6Y+MfCBXmlSdnLPdAQOlLHYg9KmTIdV5MzgSk2YU=";
#      };
#      # branch 6.6.36-k1-dev
#      #src = fetchgit {
#      #  url = "https://github.com/BPI-SINOVOIP/pi-linux";
#      #  rev = "f136d91b4911fc01c6b58e1406569df9bde784ed";
#      #  hash = "sha256-UpoKWgad8CNm7/Ve6Uiv+jrAW7auChoUudXX6zKs3sM=";
#      #};
#      defconfig = "k1_defconfig";
#      extraMeta.branch = "linux-6.6.36-k1";
#
#      #configFile = ./linux-k1-current.config;
#      structuredExtraConfig = with lib.kernel; {
#        CMDLINE = freeform "console=ttyS0,115200 console=tty1";
#        CMDLINE_EXTEND = yes;
#        DISTRO_GENERIC_KERNEL = no;
#      };
#    } // (args.argsOverride or { }));
#
#in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))



#{ lib
#, callPackage
#, linuxPackagesFor
#, ... }:
#
#let
#  modDirVersion = "6.6.36";
#  linuxPkg = { lib, fetchgit, fetchFromGitHub, buildLinux, kernelPatches, ... } @args:
#    buildLinux (args // {
#      inherit modDirVersion kernelPatches;
#      version = "${modDirVersion}-k1";
#      # modDirVersion = "6.1.15";
#      # branch linux-6.1.15-k1-dev
#      #src = fetchgit {
#      #  url = "https://github.com/BPI-SINOVOIP/pi-linux/";
#      #  rev = "b1d74b54298af0c475972d106704195cdd0ad9dc";
#      #  hash = "sha256-6jS+nUzcfs5+Z5IqX4L7JUq+GgL+1oycaMYu/qblCaM=";
#      #};
#      #src = fetchgit {
#      #  url = "https://github.com/cyyself/bpi-linux/";
#      #  rev = "7d6cbadbfb0210533a31c1089d74598b0550357a";
#      #  hash = "sha256-oQQNULAN0+wtL471TYYnwBMuSWgJJH8d5cFHx55PrMo=";
#      #};
#      # branch linux-6.1.15-k1
#      #src = fetchgit {
#      #  url = "https://github.com/BPI-SINOVOIP/pi-linux/";
#      #  rev = "eb4e73284582351b02517a157f39d8366ccb57c5";
#      #  hash = "sha256-FhQjJs9PGE0TwP+ci/WUL0ySC5r45afvXPxOdNTh+ZQ=";
#      #};
#      # branch 6.6.36-k1
#      src = fetchgit {
#        url = "https://github.com/BPI-SINOVOIP/pi-linux";
#        rev = "7b25153f8744304c5212d1d4de4dbf51e9e2eb7e";
#        hash = "sha256-dnB6Y+MfCBXmlSdnLPdAQOlLHYg9KmTIdV5MzgSk2YU=";
#      };
#      # branch 6.6.36-k1-dev
#      #src = fetchgit {
#      #  url = "https://github.com/BPI-SINOVOIP/pi-linux";
#      #  rev = "f136d91b4911fc01c6b58e1406569df9bde784ed";
#      #  hash = "sha256-UpoKWgad8CNm7/Ve6Uiv+jrAW7auChoUudXX6zKs3sM=";
#      #};
#      defconfig = "k1_defconfig";
#      extraMeta.branch = "linux-6.6.36-k1";
#
#      #configFile = ./linux-k1-current.config;
#      structuredExtraConfig = with lib.kernel; {
#        CMDLINE = freeform "console=ttyS0,115200 console=tty1";
#        CMDLINE_EXTEND = yes;
#        DISTRO_GENERIC_KERNEL = no;
#      };
#    } // (args.argsOverride or { }));
#
#in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))



