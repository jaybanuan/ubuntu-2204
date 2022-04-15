#!/bin/bash -x

apt-get update

PKG=""

# Development tools
PKG="$PKG git make curl meld"

# install packages
apt-get install -y $PKG

# install Google Chrome
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install -y ./google-chrome-stable_current_amd64.deb

# install Visual Studio Code

# install docker
apt-get install -y ca-certificates curl gnupg lsb-release


# install kubectl
snap install kubectl --classic

# install MiniKube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
dpkg -i minikube_latest_amd64.deb
