terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "waypoint"

  cidr = "10.1.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]

  enable_nat_gateway = false

  # needed otherwise the EFS volumes for the server will not mount for the Waypoint server task
  enable_dns_hostnames = true

  tags = {
    Environment = "Development"
    Owner       = "Nic Jackson"
    Project     = "Waypoint ECS Test"
  }
}

module "ecr" {
  source               = "cloudposse/ecr/aws"
  namespace            = "hashicorp"
  stage                = "dev"
  name                 = "hello-world"
  image_tag_mutability = "MUTABLE"

  tags = {
    Environment = "Development"
    Owner       = "Nic Jackson"
    Project     = "Waypoint ECS Test"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecs_subnet_1" {
  value = module.vpc.public_subnets[0]
}

output "ecs_subnet_2" {
  value = module.vpc.public_subnets[1]
}

output "ecs_subnet_3" {
  value = module.vpc.public_subnets[2]
}

output "ecr_repository" {
  value = module.ecr.repository_url
}