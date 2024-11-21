{ opensbi }:

opensbi.overrideAttrs (attrs: {
  src = attrs.src ++ {
    owner = "BPI-SINOVOIP";
    repo = "pi-opensbi";
    rev = "v1.3-k1";
    hash = "";
  };
})
