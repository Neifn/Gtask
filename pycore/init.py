#!/usr/bin/env python

import boto3
import helpers
import sys


def main():
    init_bucket()
    bashCommand = 'cd {}/terraform && /opt/terraform/terraform init '.format(helpers.cwd) \
            + '-backend-config \'region={}\' '.format(helpers.region) \
            + '-backend-config \'bucket={}\' '.format(helpers.states_bucket) \
            + '-backend-config \'key={}\' '.format('terraform.tfstate') \
            + '-backend-config \'profile={}\''.format(helpers.aws_profile)
    helpers.run_bash(bashCommand)


# Creating bucke for tf state
def init_bucket():
    buckets=[]
    session = boto3.Session(profile_name=helpers.aws_profile)
    s3 = session.resource('s3')
    # Creating list of all existing buckets
    for bucket in s3.buckets.all():
        buckets.append(bucket.name)
    # If bucket not in the list - creating it
    if helpers.states_bucket not in buckets:
        bucket = s3.create_bucket(
            Bucket=helpers.states_bucket,
            CreateBucketConfiguration={
                'LocationConstraint': helpers.region
            })


(__name__ == '__main__') and main()
