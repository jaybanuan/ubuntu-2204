#!/bin/bash -xe

##############################################################################
# add entry to sudoers

echo "$(id -un) ALL=(ALL:ALL) NOPASSWD:ALL" > "$(id -un)"
sudo install -o root -g root -m 440 "$(id -un)" /etc/sudoers.d/
sudo visudo --check --file="/etc/sudoers.d/$(id -un)"


##############################################################################
# update packages

sudo apt-get update
sudo apt-get dist-upgrade -y


##############################################################################
# install general packages

sudo apt-get install -y git make curl wget meld gdebi mozc-utils-gui


##############################################################################
# PS1 for git

cat << 'EOS' >> ~/.bashrc

get_git_info_for_ps1() {
    local GIT_INFO=$(__git_ps1 "%s")
    if [ -n "$GIT_INFO" ]; then
        local GIT_USER_NAME=$(git config --get user.name)
        if [ -z "$GIT_USER_NAME" ]; then
            GIT_USER_NAME="NO-USER-NAME"
        fi
        echo " ($GIT_USER_NAME@$GIT_INFO)"
    fi
}

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[36m\]$(get_git_info_for_ps1)\[\033[00m\]\$ '
EOS


##############################################################################
# install Visual Studio Code
#   see https://code.visualstudio.com/docs/setup/linux

sudo apt-get install -y wget gpg

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y code


##############################################################################
# install Docker
#   see https://docs.docker.com/engine/install/ubuntu/

sudo apt-get install -y ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER


##############################################################################
# install Docker Compose
#   see 

CLI_PLUGINS_DIR=/usr/local/lib/docker/cli-plugins
sudo mkdir -p $CLI_PLUGINS_DIR
sudo curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o $CLI_PLUGINS_DIR/docker-compose

sudo chmod +x $CLI_PLUGINS_DIR/docker-compose


##############################################################################
# install Kubernetes

# install kubectl
#   see https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
sudo snap install kubectl --classic

# install MiniKube
#   see https://minikube.sigs.k8s.io/docs/start/
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo gdebi -n minikube_latest_amd64.deb

# install helm
#   see https://helm.sh/docs/intro/install/
sudo snap install heml --classic


##############################################################################
# install KVM

sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm


##############################################################################
# Desktop settings

# Settings > Power > Power Saving Options > Screen Blank == Never
gsettings set org.gnome.desktop.session idle-delay 0

# favorites on dock
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'slack_slack.desktop', 'virt-manager.desktop', 'meld.desktop', 'vlc.desktop', 'org.gnome.gedit.desktop']"


##############################################################################
# install desktop apps

# install Google Chrome
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi -n ./google-chrome-stable_current_amd64.deb

# install Brasero
sudo apt-get install -y brasero

# install VLC
sudo snap install vlc

# install GIMP
sudo snap install gimp

# install Slack
sudo snap install slack

# install LibreOffice
sudo snap install libreoffice


##############################################################################
# remove entry to sudoers

sudo rm -f "/etc/sudoers.d/$(id -un)"
