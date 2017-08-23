apt-get update
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible -y
apt-get update
apt-get install -y ansible git
sed -i 's/#remote_tmp.*/remote_tmp = \$HOME\/\.ansible\/tmp/' /etc/ansible/ansible.cfg
ansible-pull -U https://github.com/Neifn/GtaskAnsible -d /opt/playbooks -i 'localhost,' ${playbook}
