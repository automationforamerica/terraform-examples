# Import an existing pub key

# https://www.terraform.io/docs/providers/aws/r/key_pair.html
resource "aws_key_pair" "deployer" {
  key_name = "${var.ssh_key.key_name}"
  public_key = "${var.ssh_key.public_key}"
}

# Varnish server 001
resource "aws_instance" "varnish_001" {
  ami = "${var.aws_ubuntu_ami}"
  #availability_zone = "${lookup(var.aws_zones, "zone0")}"
  instance_type = "m3.medium"
  key_name = "${aws_key_pair.deployer.key_name}"
  subnet_id = "${aws_subnet.app1.0.id}"
  security_groups = ["${aws_security_group.varnish-cache.id}"]
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "wordpress-varnish-001"
    Role = "Cache"
    WordpressRole = "Varnish"
    Environment = "Production"
  }
}

# Wordpress server 001
resource "aws_instance" "wordpress_001" {
  ami = "${var.aws_ubuntu_ami}"
  #availability_zone = "${lookup(var.aws_zones, "zone1")}"
  instance_type = "m3.medium"
  key_name = "${aws_key_pair.deployer.key_name}"
  subnet_id = "${aws_subnet.app1.0.id}"
  security_groups = ["${aws_security_group.app1.id}"]
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "wordpress-001"
    Role = "Wordpress"
    WordpressRole = "Client"
    Environment = "Production"
  }
}

# Wordpress server 002
resource "aws_instance" "wordpress_002" {
  ami = "${var.aws_ubuntu_ami}"
  #availability_zone = "${lookup(var.aws_zones, "zone1")}"
  instance_type = "m3.medium"
  key_name = "${aws_key_pair.deployer.key_name}"
  subnet_id = "${aws_subnet.app1.0.id}"
  security_groups = ["${aws_security_group.app1.id}"]
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "wordpress-002"
    Role = "Wordpress"
    WordpressRole = "Client"
    Environment = "Production"
  }
}

# Wordpress admin server
resource "aws_instance" "wordpress_admin_001" {
  ami = "${var.aws_ubuntu_ami}"
  #availability_zone = "${lookup(var.aws_zones, "zone1")}"
  instance_type = "m3.medium"
  key_name = "${aws_key_pair.deployer.key_name}"
  subnet_id = "${aws_subnet.app1.1.id}"
  security_groups = ["${aws_security_group.app1.id}"]
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "wordpress-admin-001"
    Role = "Wordpress"
    WordpressRole = "Admin"
    Environment = "Production"
  }
}
