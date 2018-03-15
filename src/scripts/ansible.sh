# ansible installation manual
# http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-apt-ubuntu
apt-get -y install software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get -y update
apt-get -y install ansible

ansible-galaxy install geerlingguy.jenkins

sleep 20

# for role in ${1:+"$@"}
# do
#     echo "$role"
#     ansible-galaxy install "$role"
# done