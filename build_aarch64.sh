nix-build --cores 0 '<nixpkgs/nixos>' \
  -I nixos-config=configuration_aarch64.nix \
  -A config.system.build.sdImage \
  -o result-cross-aarch64 \
  --keep-going
