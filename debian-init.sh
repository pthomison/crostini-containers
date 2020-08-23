#!/bin/bash

# getting latest
apt-get update && apt-get upgrade -y

# docker
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
    
 curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
 
 add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io

apt-get install -y nmap
