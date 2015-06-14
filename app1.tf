###################################
#### BEGIN: ELB TIER RESOURCES ####
###################################

/* The ELB tier is where load balancers like HA proxy and ELBs live */
/* The app tier is where applications like Wordpress or Drupal live */

# App Tier Subnets
# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "elb1" {
    vpc_id = "${aws_vpc.prod1.id}"
    cidr_block = "${concat("10.0.", 90 + count.index, ".0/24")}"
    availability_zone = "${lookup(var.aws_zones, concat("zone", count.index))}"
    count = 3
    tags {
       Name = "${concat("elb1 - zone ", count.index)}"
    }
}

# elb1 Route Table
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "elb1" {
    vpc_id = "${aws_vpc.prod1.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
    tags {
        Name = "elb1 group"
    }
}

# elb1 Route Table associations
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "elb1" {
    subnet_id = "${element(aws_subnet.elb1.*.id, count.index)}"
    route_table_id = "${aws_route_table.elb1.id}"
    count = 3
}

# elb1 Security Group
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "elb1" {
  name = "elb1"
  description = "Allow services from the interwebs to the ELB subnet"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.prod1.id}"
}

#### END: ELB TIER RESOURCES ####
#################################



###################################
#### BEGIN: APP TIER RESOURCES ####
###################################

/* The app tier is where applications like Wordpress or Drupal live */

# App Tier Subnets
# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "app1" {
    vpc_id = "${aws_vpc.prod1.id}"
    cidr_block = "${concat("10.0.", count.index, ".0/24")}"
    availability_zone = "${lookup(var.aws_zones, concat("zone", count.index))}"
    count = 3
    tags {
       Name = "${concat("app1 - zone ", count.index)}"
    }
}

# app1 Route Table
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "app1" {
    vpc_id = "${aws_vpc.prod1.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }
    tags {
        Name = "app1 group"
    }
}

# app1 Route Table associations
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "app1" {
    subnet_id = "${element(aws_subnet.app1.*.id, count.index)}"
    route_table_id = "${aws_route_table.app1.id}"
    count = 3
}

# app1 Security Group
# TODO: Update to include access from Mgmt Subnet (or SG) on port 22 (SSH)
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "app1" {
  name = "app1"
  description = "Allow services from the ELB subnet to the App1 subnet"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.elb1.id}"]
  }
  vpc_id = "${aws_vpc.prod1.id}"
}
#### END: APP TIER RESOURCES ####
#################################



####################################
#### BEGIN: DATA TIER RESOURCES ####
####################################

/* The data tier is where DBs live (MySQL, Mongo, Redis, etc) */

# App Tier Subnets
# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "data1" {
    vpc_id = "${aws_vpc.prod1.id}"
    cidr_block = "${concat("10.0.", 60 + count.index, ".0/24")}"
    availability_zone = "${lookup(var.aws_zones, concat("zone", count.index))}"
    count = 3
    tags {
       Name = "${concat("data1 - zone ", count.index)}"
    }
}

# data1 Route Table
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "data1" {
    vpc_id = "${aws_vpc.prod1.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }
    tags {
        Name = "data1 group"
    }
}

# data1 Route Table associations
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "data1" {
    subnet_id = "${element(aws_subnet.data1.*.id, count.index)}"
    route_table_id = "${aws_route_table.data1.id}"
    count = 3
}

# data1 Security Group
# https://www.terraform.io/docs/providers/aws/r/security_group.html
# TODO: Update to include access from Mgmt Subnet (or SG) on port 22 (SSH)
resource "aws_security_group" "data1" {
  name = "data1"
  description = "Allow services from the ELB subnet to the data1 subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = ["${aws_security_group.app1.id}"]
  }

  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_groups = ["${aws_security_group.app1.id}"]
  }

  vpc_id = "${aws_vpc.prod1.id}"
}
#### END: DATA TIER RESOURCES ####
##################################

