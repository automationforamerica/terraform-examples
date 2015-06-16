#################################
#### BEGIN: Public RESOURCES ####
#################################

# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.prod1.id}"
    cidr_block = "${concat("10.0.0.0/24")}"
    availability_zone = "${lookup(var.aws_zones, "zone0")}"
    tags {
        Name = "Public DMZ"
    }
}


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
    count = 2
    tags {
       Name = "${concat("elb1 - zone ", count.index)}"
    }
}


###################################
#### BEGIN: APP TIER RESOURCES ####
###################################

/* The app tier is where applications like Wordpress or Drupal live */

# App Tier Subnets
# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "app1" {
    vpc_id = "${aws_vpc.prod1.id}"
    cidr_block = "${concat("10.0.", (count.index + 1), ".0/24")}"
    availability_zone = "${lookup(var.aws_zones, concat("zone", count.index))}"
    count = 2
    tags {
       Name = "${concat("app1 - zone ", count.index)}"
    }
}


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
    count = 2
    tags {
       Name = "${concat("data1 - zone ", count.index)}"
    }
}

resource "aws_db_subnet_group" "app" {
    name = "app"
    description = "Subnets used for running the data tier"
    subnet_ids = ["${aws_subnet.data1.0.id}", "${aws_subnet.data1.1.id}"]
}
