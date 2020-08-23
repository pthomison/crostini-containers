
#!/usr/bin/env bash

VM_NAME=penguin
USERNAME=pthomison

lxc delete -f $VM_NAME

lxc launch images:debian/bullseye $VM_NAME < /dev/null
