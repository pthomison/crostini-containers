
#!/usr/bin/env bash

VM_NAME=penguin
USERNAME=pthomison

lxc delete -f $VM_NAME

lxc launch images:debian/bullseye $VM_NAME

lxc exec penguin -- bash -c "apt-get update && apt-get upgrade -y && apt-get install curl -y"

lxc exec penguin -- bash -c 'curl https://raw.githubusercontent.com/pthomison/test-provisioning/master/debian-init.sh | bash'
