#!/usr/bin/env python

import helpers
import sys


def main():
    # Replace {} with what was passed by helpers.py
    bashCommand = 'cd {}/terraform && /opt/terraform/terraform destroy '.format(helpers.cwd) \
            # Pass variables
            + '-var \'aws_profile={}\' '.format(helpers.aws_profile) \
            + '-var \'region={}\' '.format(helpers.region)
    helpers.run_bash(bashCommand)


(__name__ == '__main__') and main()
