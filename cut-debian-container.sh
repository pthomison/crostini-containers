
#!/usr/bin/env bash

VM_NAME=penguin
USERNAME=pthomison

lxc delete -f $VM_NAME || true

lxc launch images:debian/bullseye $VM_NAME < /dev/null

lxc exec penguin -- bash -c "apt-get update && apt-get upgrade -y && apt-get install curl -y && curl https://raw.githubusercontent.com/pthomison/test-provisioning/master/debian-init.sh | bash"

# lxc exec penguin -- bash -c ''
