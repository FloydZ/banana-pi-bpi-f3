{ lib
, stdenv
, fetchFromGitHub
, python3
, ubootTools
, dtc
}:

# SpacemiT K1 vendor OpenSBI, packed as fw_dynamic.itb which the K1 SPL
# loads from sector 0x500 (640K) of the boot device.
stdenv.mkDerivation {
  pname = "opensbi-spacemit-k1";
  version = "k1-bl-v2.2.9";

  src = fetchFromGitHub {
    owner = "pyavitz";
    repo = "spacemit-opensbi";
    rev = "05479f5228f3fab2a4221fe0745f3703171ace58"; # k1-bl-v2.2.9-release
    hash = "sha256-Vd/a1gIP3bBqLpmz5HAU6HyrK5SuFDnI2m1T2DrtkwE=";
  };

  # GCC 15 defaults to C23 where bool is a keyword (fixed upstream the same way)
  postPatch = ''
    patchShebangs ./scripts
    substituteInPlace Makefile \
      --replace-fail "CFLAGS		=	-g -Wall -Werror" "CFLAGS		=	-std=gnu11 -g -Wall -Werror"
  '';

  nativeBuildInputs = [ python3 ubootTools dtc ];

  makeFlags = [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    "PLATFORM=generic"
    "PLATFORM_DEFCONFIG=k1_defconfig"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 -t $out build/platform/generic/firmware/fw_dynamic.{bin,itb}
    runHook postInstall
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    description = "OpenSBI for the SpacemiT K1 (Banana Pi BPI-F3)";
    homepage = "https://github.com/pyavitz/spacemit-opensbi";
    license = lib.licenses.bsd2;
    platforms = [ "riscv64-linux" ];
  };
}
