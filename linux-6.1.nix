{ lib
, callPackage
, linuxPackagesFor
, ... }:

let
  modDirVersion = "6.6.36";
  linuxPkg = { lib, fetchgit, fetchFromGitHub, buildLinux, ... } @args:
    buildLinux (args // {
      version = "${modDirVersion}-k1";

      # modDirVersion = "6.1.15";
      # branch linux-6.1.15-k1-dev
      # src = fetchgit {
      #   url = "https://github.com/BPI-SINOVOIP/pi-linux/";
      #   rev = "c75937bf433f946d0466fdf86730de3d79faa3d9";
      #   hash = "sha256-/jbEUT1G8HrfrZnv1kRfj4JlurBqbLtfltADTxy662Q=";
      # };
      #src = fetchgit {
      #  url = "https://github.com/cyyself/bpi-linux/";
      #  rev = "7d6cbadbfb0210533a31c1089d74598b0550357a";
      #  hash = "sha256-oQQNULAN0+wtL471TYYnwBMuSWgJJH8d5cFHx55PrMo=";
      #};
      # branch linux-6.1.15-k1
      #src = fetchgit {
      #  url = "https://github.com/BPI-SINOVOIP/pi-linux/";
      #  rev = "eb4e73284582351b02517a157f39d8366ccb57c5";
      #  hash = "sha256-FhQjJs9PGE0TwP+ci/WUL0ySC5r45afvXPxOdNTh+ZQ=";
      #};
      src = fetchgit {
        url = "https://github.com/BPI-SINOVOIP/pi-linux";
        rev = "7b25153f8744304c5212d1d4de4dbf51e9e2eb7e";
        hash = "sha256-dnB6Y+MfCBXmlSdnLPdAQOlLHYg9KmTIdV5MzgSk2YU=";
      };

      inherit modDirVersion;
      defconfig = "k1_defconfig";
      extraMeta.branch = "linux-6.6.36-k1";
    } // (args.argsOverride or { }));

in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))
