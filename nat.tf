
# NAT Security Group
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "nat" {
  name = "nat"
  description = "Allow services from the private subnet through NAT"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [
        "${aws_security_group.app1_admin.id}",
        "${aws_security_group.app1.id}",
        "${aws_security_group.data1.id}",
        "${aws_security_group.varnish-cache.id}"
    ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [
        "${aws_security_group.app1_admin.id}",
        "${aws_security_group.app1.id}",
        "${aws_security_group.data1.id}",
        "${aws_security_group.varnish-cache.id}"
    ]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
  instance_type = "m3.medium"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.nat.id}"]
  subnet_id = "${aws_subnet.public.0.id}"
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "NAT"
  }
}
