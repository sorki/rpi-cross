#export NIX_PATH=nixpkgs=some_path
export NIXOS_CONFIG=$( pwd )/configuration.nix

nixos-rebuild \
  --build-host localhost \
  --target-host root@10.0.0.123 \
  switch
