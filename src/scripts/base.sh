# Apt-install various things necessary for Ruby, guest additions,
# etc., and remove optional things to trim down the machine.
apt-get -y update
apt-get -y upgrade
apt-get -y install gcc build-essential linux-headers-$(uname -r)
apt-get -y install zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev
apt-get -y install vim curl
apt-get clean

# Set up base box 
# https://www.vagrantup.com/docs/boxes/base.html

# Set up sudo
( cat <<'EOP'
%vagrant ALL=NOPASSWD:ALL
EOP
) > /tmp/vagrant
chmod 0440 /tmp/vagrant
mv /tmp/vagrant /etc/sudoers.d/

# Install NFS client
apt-get -y install nfs-common

# Set up ssh key
# Vagrant Insecure Keypair, https://github.com/hashicorp/vagrant/tree/master/keys

mkdir /home/vagrant/.ssh
curl -k https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub > /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 0700 /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys

# Reduce box image size
# https://blog.asamaru.net/2015/10/14/creating-a-vagrant-base-box/
# dd if=/dev/zero of=/EMPTY bs=1M
# rm -f /EMPTY