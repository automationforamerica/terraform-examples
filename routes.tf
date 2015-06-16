#################################
#### BEGIN: PUBLIC RESOURCES ####
#################################

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


###################################
#### BEGIN: ELB TIER RESOURCES ####
###################################

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
    count = 2
}


###################################
#### BEGIN: APP TIER RESOURCES ####
###################################

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
    count = 2
}


####################################
#### BEGIN: DATA TIER RESOURCES ####
####################################

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
    count = 2
}

