nix-build --cores 0 '<nixpkgs/nixos>' \
  -I nixos-config=configuration_armv6.nix \
  -A config.system.build.sdImage \
  -o result-cross-armv6 \
  --keep-going
