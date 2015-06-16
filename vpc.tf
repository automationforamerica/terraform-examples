#################################
#### BEGIN: Shared Resources ####
#################################

# VPC
# https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "prod1" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true

    tags {
        Name = "production-1"
    }
}

# Internet Gateway
# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.prod1.id}"
}
