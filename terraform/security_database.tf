resource "aws_security_group" "database_security" {
  name              = "database_security"
  description       = "Allows ssh trafic"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web_server_security.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  vpc_id            = "${aws_vpc.custom_vpc.id}"
}
