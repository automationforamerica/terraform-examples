#################################
#### BEGIN: Shared Resources ####
#################################

# VPC
# https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "prod1" {
    cidr_block = "10.0.0.0/16"

    tags {
        Name = "production-1"
    }
}

# Internet Gateway
# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.prod1.id}"
}

# Public Subnet
# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.prod1.id}"
    cidr_block = "${concat("10.0.0.0/24")}"
    availability_zone = "${lookup(var.aws_zones, "zone0")}"
    tags {
        Name = "Public DMZ"
    }
}

# Public (Default) Route Table
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.prod1.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
    Name = "Public Route"
  }
}

# Public Route Table associations
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# NAT Security Group
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "nat" {
  name = "nat"
  description = "Allow services from the private subnet through NAT"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group = [
        "${aws_security_group.app1.id}",
        "${aws_security_group.data1.id}"
    ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group = [
        "${aws_security_group.app1.id}",
        "${aws_security_group.data1.id}"
    ]
  }

  vpc_id = "${aws_vpc.prod1.id}"
  tags {
    Name = "${concat("NAT ", aws_vpc.prod1.id)}"
  }
}

# NAT Instance
# https://www.terraform.io/docs/providers/aws/r/instance.html
# TODO: we should create a nat on each AZ for HA
resource "aws_instance" "nat" {
    ami = "${var.aws_nat_ami}"
    availability_zone = "${lookup(var.aws_zones, "zone0")}"
    instance_type = "m1.small"
    # key_name = "${var.aws_key_name}" # TODO setup a key
    security_groups = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.public.0.id}"
    associate_public_ip_address = true
    source_dest_check = false
}

#### END: Shared Resources ####
###############################

