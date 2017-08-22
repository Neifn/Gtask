# Lauch configuration for DB
resource "aws_instance" "database" {
  ami                         = "ami-1e749f67"
  instance_type               = "t2.micro"
  security_groups             = ["${aws_security_group.database_security.id}"]
  key_name                    = "test_terr"
  private_ip                  = "10.0.1.13"
  subnet_id                   = "${aws_subnet.eu-west-1a-private.id}"
#  user_data                   = "${data.template_file.userdata_database.rendered}"

  lifecycle {
    create_before_destroy = true
  }
  tags { 
    Name = "database"
  }
}
