#!/bin/sh

# Temp script
# Will be ported to nix
# creates hardware config and moves it to host dir
sudo nixos-generate-config
cp /etc/nixos/hardware-configuration.nix ./host
