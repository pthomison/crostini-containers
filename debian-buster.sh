#!/usr/bin/env bash

M_NAME=penguin
USERNAME=pthomison
LXC_IMAGE=images:debian/buster

lxc delete -f $VM_NAME || true

lxc launch $LXC_IMAGE $VM_NAME < /dev/null

lxc exec penguin -- bash -c "apt-get update && apt-get upgrade -y \
&& apt-get install curl -y \
&& curl http://192.168.1.50:8080/debian-init.sh | bash"
