#!/bin/bash -x

PKG=""

# Development tools
PKG="$PKG git make curl"

sudo apt-get install -y $PKG

curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
