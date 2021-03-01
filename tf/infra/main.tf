provider "aws" {
  profile = var.profile
  region  = var.region
}

terraform {
  backend "s3" {}
}

module "vpc" {
  source = "../modules/vpc"  
}

output "kops_vpc_id" {
    value = "${module.vpc.vpc_id}"
}

module "public_subnet" {
  source = "../modules/public-subnet"

  vpc_id = module.vpc.vpc_id
}

output "kops_subnet_id" {
    value = "${module.public_subnet.public_subnet_id}"
}


module "internet_gateway" {
  source = "../modules/internet-gateway"

  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source = "../modules/route-table"

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  public_subnet_id    = module.public_subnet.public_subnet_id
}

module "ec2" {
  source = "../modules/ec2"

  vpc_id                    = module.vpc.vpc_id
  public_subnet_id          = module.public_subnet.public_subnet_id

  ec2_ssh_key_name          = var.ec2_ssh_key_name
  ec2_ssh_public_key_path   = var.ec2_ssh_public_key_path
  ec2_ssh_private_key_path  = var.ec2_ssh_private_key_path
}

