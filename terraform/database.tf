# Lauch configuration for DB
resource "aws_instance" "database" {
  ami                         = "${var.database_ami}"
  instance_type               = "${var.database_instance_type}"
  security_groups             = ["${aws_security_group.database_security.id}"]
  key_name                    = "${var.database_key_name}"
  private_ip                  = "${var.database_private_ip}"
  subnet_id                   = "${aws_subnet.eu-west-1a-private.id}"
#  user_data                   = "${data.template_file.userdata_database.rendered}"

  lifecycle {
    create_before_destroy = true
  }
  tags { 
    Name = "database"
  }
}
