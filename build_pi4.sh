nix-build --cores 0 '<nixpkgs/nixos>' \
  -I nixos-config=configuration_pi4.nix \
  -A config.system.build.sdImage \
  -o result-cross-pi4 \
  --keep-going
