#!/usr/bin/env bash
set -xe
VM_NAME=penguin
USERNAME=pthomison
LXC_IMAGE=images:fedora/32

lxc delete -f $VM_NAME || true

lxc launch $LXC_IMAGE $VM_NAME < /dev/null

lxc exec penguin -- bash -c "sleep 5 && curl http://192.168.1.50:8080/fedora-init.sh | bash -s $USERNAME"
