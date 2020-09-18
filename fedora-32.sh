#!/usr/bin/env bash
set -xe
VM_NAME=penguin
USERNAME=pthomison
LXC_IMAGE=images:fedora/32

lxc delete -f $VM_NAME || true

lxc launch $LXC_IMAGE $VM_NAME < /dev/null

cat << 'EOF' > /tmp/init.sh
#!/usr/bin/env bash
set -xe

USERNAME="pthomison"

echo "max_parallel_downloads=20" >> /etc/dnf/dnf.conf

dnf update -y
dnf -y install \
sudo \
git \
cros-guest-tools \
docker \
python3 \
zsh \
bind-utils \
wget \
curl \
util-linux-user \
htop \
awscli \
dnf-plugins-core \
NetworkManager \
jq

useradd $USERNAME

groupadd wheel | true
groupadd docker | true

usermod -aG wheel $USERNAME
usermod -aG docker $USERNAME

sed -i 's/--storage-driver=.*/--storage-driver=btrfs/' /etc/sysconfig/docker
systemctl enable --now docker

# passwordless sudo
sed -i 's|%wheel.*ALL=(ALL).*ALL.*$|%wheel ALL=(ALL) NOPASSWD: ALL|g' /etc/sudoers

# inject a password
#echo "r3dh4t1!" | passwd --stdin $USERNAME

systemctl unmask systemd-logind
loginctl enable-linger $USERNAME
systemctl enable cros-sftp

# disable selinux
setenforce 0 | true
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
echo "Set disable_coredump false" >> /etc/sudo.conf

rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
dnf -y install sublime-text

K9S_DIR="/opt/k9s"
mkdir -p $K9S_DIR
pushd $K9S_DIR
wget https://github.com/derailed/k9s/releases/download/0.9.3/k9s_0.9.3_Linux_x86_64.tar.gz
tar -xf k9s_0.9.3_Linux_x86_64.tar.gz
ln -s /opt/k9s/k9s /usr/bin/k9s
popd


mkdir -p /home/pthomison/.ssh
mkdir -p /home/pthomison/.aws

rm /home/pthomison/.zshrc /home/pthomison/.gitconfig /home/pthomison/.ssh/config || true

ln -s /mnt/chromeos/MyFiles/Configs/zsh/zshrc /home/pthomison/.zshrc
ln -s /mnt/chromeos/MyFiles/Configs/git/gitconfig /home/pthomison/.gitconfig
ln -s /mnt/chromeos/MyFiles/Configs/ssh/config /home/pthomison/.ssh/config
ln -s /mnt/chromeos/MyFiles/Configs/aws/config /home/pthomison/.aws/config
ln -s /mnt/chromeos/MyFiles/Configs/aws/credentials /home/pthomison/.aws/credentials

su $USERNAME -c "systemctl --user enable --now sommelier@0"
su $USERNAME -c "systemctl --user enable --now sommelier-x@0"
su $USERNAME -c "systemctl --user enable --now sommelier@1"
su $USERNAME -c "systemctl --user enable --now sommelier-x@1"
su $USERNAME -c "systemctl --user enable --now cros-garcon"

su $USERNAME -c 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

chsh $USERNAME -s $(which zsh)

poweroff

EOF

sleep 2

lxc file push /tmp/init.sh penguin/tmp/init.sh

sleep 2

lxc exec penguin -- bash -c "bash /tmp/init.sh"
