# Creating virtual private cloud
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "gtest_vpc"
  }
}

# Adding internet gateway
resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.custom_vpc.id}"
}




# Creating public subnet for custom_vpc
resource "aws_subnet" "eu-west-1a-public" {
    vpc_id = "${aws_vpc.custom_vpc.id}"

    cidr_block = "10.0.0.0/24"
    availability_zone = "eu-west-1a"
}

# Creating route table for public subnet
resource "aws_route_table" "eu-west-1a-public" {
    vpc_id = "${aws_vpc.custom_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gateway.id}"
    }
}

# Associating route table to subnet
resource "aws_route_table_association" "eu-west-1a-public" {
    subnet_id = "${aws_subnet.eu-west-1a-public.id}"
    route_table_id = "${aws_route_table.eu-west-1a-public.id}"
}




# Creating private subnet for custom_vpc
resource "aws_subnet" "eu-west-1a-private" {
    vpc_id = "${aws_vpc.custom_vpc.id}"

    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1a"
}

# Creating route table for private subnet and associating it to nat
resource "aws_route_table" "eu-west-1a-private" {
    vpc_id = "${aws_vpc.custom_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.gw.id}"
    }
}

# Associating route table to subnet
resource "aws_route_table_association" "eu-west-1a-private" {
    subnet_id = "${aws_subnet.eu-west-1a-private.id}"
    route_table_id = "${aws_route_table.eu-west-1a-private.id}"
}




resource "aws_eip" "nat_ip" {
  vpc      = true
}

# Creating aws nat server
resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat_ip.id}"
  subnet_id     = "${aws_subnet.eu-west-1a-public.id}"
}

