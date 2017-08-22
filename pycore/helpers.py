#!/usr/bin/env python2

import yaml
import os
import subprocess


# Open file in the directory from which script was executed
with open('configs.yaml', 'r') as f:
    configs_yaml = yaml.load(f)

region = configs_yaml['region']
states_bucket = configs_yaml['states_bucket']
terraform_url = configs_yaml['terraform_url']
aws_profile = configs_yaml['aws_profile']
cwd = os.getcwd()


def run_bash(bashCommand):
    # Run bash command
    p = subprocess.Popen(bashCommand, shell=True, stderr=subprocess.PIPE)

    # But do not wait till netstat finish, start displaying output immediately
    while True:
        out = p.stderr.read(1)
        if out == '' and p.poll() != None:
            break
        if out != '':
            sys.stdout.write(out)
            sys.stdout.flush()
