#!/bin/bash

# getting latest
apt-get update && apt-get upgrade -y

# docker
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    less
    
 curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
 
 add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io

apt-get install -y nmap

echo "deb https://storage.googleapis.com/cros-packages stretch main" > /etc/apt/sources.list.d/cros.list
# if [ -f /dev/.cros_milestone ]; then sudo sed -i "s?packages?packages/$(cat /dev/.cros_milestone)?" /etc/apt/sources.list.d/cros.list; fi
apt install -y gnupg2 psmisc
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1397BC53640DB551
apt update
apt install -y binutils
apt download cros-ui-config
tar x cros-ui-config_0.12_all.deb data.tar.gz
gunzip data.tar.gz
tar f data.tar --delete ./etc/gtk-3.0/settings.ini
gzip data.tar
tar r cros-ui-config_0.12_all.deb data.tar.gz
rm -rf data.tar.gz

apt install -y cros-adapta cros-apt-config cros-garcon cros-guest-tools cros-sftp cros-sommelier cros-sommelier-config cros-sudo-config cros-systemd-overrides ./cros-ui-config_*.deb cros-wayland

groupmod -n pthomison debian
usermod -md /home/pthomison -l pthomison ubuntu
usermod -aG users pthomison
loginctl enable-linger pthomison
