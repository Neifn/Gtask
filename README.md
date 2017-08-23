# test_task
## Prerequisites:
- Create ec2 ssh key in aws account and add them into `terraform/terraform.tfvars` replacing `<KEYS>`.
- Add s3 bucket name that will be used for tf states into `configs.yaml` replacing `<BUCKET>` (Notice: it is not required that bucket exists).
- Ubuntu 14.04 host instance.
## Install
For installing platform perform:
`. ./install.sh <VIRTUAL ENV NAME>` in the root of git project directory. Script will ask you for access and secret aws keys.
After that you can access your venv account just with alias `<VIRTUAL ENV NAME>`.
Script will initialize terraform in s3 bucket you provided in configs.yaml and create stack on your aws account.
## Additional functions:
- For initializing terraform backend perform: `python pycore/init.py` in the root of git project directory.
- For creating stack perform: `python pycore/apply.py` in the root of git project directory.
- For removing stack perform: `python pycore/destroy.py` in the root of git project directory.
