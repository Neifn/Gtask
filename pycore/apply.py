#!/usr/bin/env python

import helpers
import sys


def main():
    bashCommand = 'cd {}/terraform && /opt/terraform/terraform apply '.format(helpers.cwd) \
            + '-var \'aws_profile={}\' '.format(helpers.aws_profile) \
            + '-var \'region={}\' '.format(helpers.region)
    helpers.run_bash(bashCommand)


(__name__ == '__main__') and main()
