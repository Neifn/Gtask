variable "region" {}
variable "aws_profile" {}

variable "database_ami" {}
variable "database_instance_type" {}
variable "database_key_name" {}
variable "database_private_ip" {}

variable "web_server_ami" {}
variable "web_server_instance_type" {}
variable "web_server_key_name" {}
variable "web_server_scaling_min_capacity" {}
variable "web_server_scaling_max_capacity" {}

terraform {
  backend "s3" {}
}

provider "aws" {
  region                  = "${var.region}"
  profile                 = "${var.aws_profile}"
}
