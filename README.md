# terraform-examples
A group of opinionated terraform examples for AWS that create a VPC and supporting resources.

## VPC
vpc.tf creates a VPC, NAT subnet, NAT EC2 instance

## Application
app1.tf creates the network resources needed to run an application. This will spin up a x number of subnets for separate ELB, application, and data tiers. This number is determined by the number of subnets defined in the variables.tf file.


## Variables
Rename variables.tf.example to variables.tf in order to configure the region and other variables.

# Getting Off the Ground

1. Run `terraform apply` and specify the requested arguments
2. SSH into the IP of the deployed `nat` server with your keypair under the username `openvpnas`.
3. Follow the instructions. Of note, OpenVPN should listen on `0.0.0.0`.
