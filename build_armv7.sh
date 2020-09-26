nix-build --cores 0 '<nixpkgs/nixos>' \
  -I nixos-config=configuration.nix \
  -A config.system.build.sdImage \
  -o result-cross-armv7 \
  --keep-going
