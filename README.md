# Cross build images for Raspberry Pi from x86

Example of cross compiling complete SD card images from scratch, using
custom NixOS configuration.

## Usage

Clone this repository and clone my fork of `nixpkgs` containing two patches with pending PRs

* libgpiod cross fix - https://github.com/NixOS/nixpkgs/pull/86645
* raspberrypi-builder cross fix - https://github.com/NixOS/nixpkgs/pull/98858

```bash
git clone https://github.com/sorki/rpi-cross
git clone --branch integration/rpi https://github.com/sorki/nixpkgs

cd nixpkgs
# point NIX_PATH to fork
export NIX_PATH=nixpkgs=$( pwd )

cd ../rpi-cross
```

Before building, customize one of the sample `configuration.nix` files
and `ssh-keys.nix`.

For `Pi2` and `Pi3` you can use `armv7l` builds (`configuration.nix` and `build_armv7.nix`).

`Pi3` can also run `aarch64` build (`configuration_aarch64.nix` and `build_aarch64.nix`).

`Pi4` is `aarch64` but requires rPi foundation kernel (`configuration_pi4.nix` and `build_pi4.nix`).

Proceed with build using one of the following scripts:

```bash
./build_armv7.sh
# or
./build_aarch64.sh
# or
./build_pi4.sh
```

## Deployment

Check out `./deploy_example.sh` for an example of using `nixos-rebuild --target-host ... --build-host` to deploy
new configuration over SSH.
