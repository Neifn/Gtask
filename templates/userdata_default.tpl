apt-get update
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible -y
apt-get update
apt-get install -y ansible git
ansible-pull -U https://github.com/Neifn/GtaskAnsible -d /opt/playbooks -i 'localhost,' ${playbook}
