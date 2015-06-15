resource "aws_instance" "varnish" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "${lookup(var.aws_zones, "zone0")}"
  instance_type = "m3.medium"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.app1.0.id}"
  security_groups = ["${aws_security_group.varnish-cache.id}"]
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "app-001"
    Role = "Cache"
    WordpressRole = "Varnish"
    Environment = "Production"
  }
}

resource "aws_instance" "app_001" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "${lookup(var.aws_zones, "zone1")}"
  instance_type = "m3.medium"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.app1.0.id}"
  security_groups = ["${aws_security_group.app1.id}"]
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "app-001"
    Role = "Wordpress"
    WordpressRole = "Client"
    Environment = "Production"
  }
}

resource "aws_instance" "app_002" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "${lookup(var.aws_zones, "zone2")}"
  instance_type = "m3.medium"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.app1.1.id}"
  security_groups = ["${aws_security_group.app1.id}"]
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "app-002"
    Role = "Wordpress"
    WordpressRole = "Client"
    Environment = "Production"
  }
}
