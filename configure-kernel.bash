#!/usr/bin/env bash

if ! command -v nix >/dev/null 2>&1
then
    echo "Nix (package manager) could not be found. Please install Nix."
	echo "Install Nix from the website. Installing from a package manger is not recommended."
    exit 1
fi

make -L configure-kernel NLUKI_BYPASS_NIX_CHECK=yes "$@"