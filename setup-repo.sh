#!/bin/bash
set -e

echo "Setting up Antergos NeXT PKGS..."

if [[ $EUID -ne 0 ]]; then
   echo "Run with sudo!"
   exit 1
fi

cp /etc/pacman.conf /etc/pacman.conf.backup

if ! grep -q "\[antergos-pkgs\]" /etc/pacman.conf; then
    cat >> /etc/pacman.conf << 'CONF'

[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages/
CONF
    echo "Added antergos-pkgs to pacman.conf"
else
    echo "antergos-pkgs already in pacman.conf"
fi

pacman -Sy

echo "Antergos NeXT PKGS ready!"
