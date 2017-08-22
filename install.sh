#!/bin/bash

if [ $# -ne 1 ]
  then
  echo "Not enough arguments provided."
  exit 1
fi

VENV_NAME=$1
WORKON_HOME=$HOME/.virtualenvs
# Virtual env manipulations
VENV_BLOCK="export WORKON_HOME=\$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
alias $VENV_NAME='workon $VENV_NAME'"

sudo apt-get update
sudo apt-get install -y python-dev python-pip unzip

sudo wget $( grep -A0 'terraform_url:' configs.yaml | awk '{ print $2}' ) -O /tmp/terraform.zip
sudo unzip /tmp/terraform.zip -d /opt/terraform

pip install virtualenv
pip install virtualenvwrapper

# Search for ${VENV_BLOCK} in .bashrc
grep -q -F "${VENV_BLOCK}" ~/.bashrc || echo "${VENV_BLOCK}" >> ~/.bashrc
source ~/.bashrc
mkvirtualenv ${VENV_NAME}
export PATH=$PATH:/opt/terraform
echo -n "Please, enter your AWS_ACCESS_KEY: " 
read -s access_key
echo -e "\n"
echo -n "Please, enter your AWS_SECRET_KEY: "
read -s secret_key
echo -e "\n"
mkdir -p ~/.aws
aws_profile=$( grep -A0 'aws_profile:' configs.yaml | awk '{ print $2}' )
echo "[${aws_profile}]
aws_access_key_id = ${access_key}
aws_secret_access_key = ${secret_key}" > ~/.aws/credentials
pip install -r requirements.txt
python pycore/init.py 
python pycore/apply.py
