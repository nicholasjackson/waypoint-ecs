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

//data "aws_iam_role" "waypoint" {
//  name = "waypoint-server-execution-role"
//}
//
module "ecr" {
  source    = "cloudposse/ecr/aws"
  namespace = "hashicorp"
  stage     = "dev"
  name      = "hello-world"
  //principals_full_access = ["arn:aws:iam::938765688536:role/waypoint-runner", "arn:aws:iam::938765688536:role/waypoint-server-execution-role"]

  tags = {
    Environment = "Development"
    Owner       = "Nic Jackson"
    Project     = "Waypoint ECS Test"
  }
}

//resource "aws_iam_role" "waypoint_server_execution_role" {
//  name = "waypoint-server-execution-role"
//
//  assume_role_policy = <<EOF
//{
//	"Version": "2012-10-17",
//	"Statement": [
//		{
//			"Sid": "",
//			"Effect": "Allow",
//			"Principal": {
//				"Service": "ecs-tasks.amazonaws.com"
//			},
//			"Action": "sts:AssumeRole"
//		}
//	]
//}
//EOF
//
//  tags = {
//    Environment = "Development"
//    Owner       = "Nic Jackson"
//    Project     = "Waypoint ECS Test"
//  }
//}
//
//resource "aws_iam_role_policy_attachment" "waypoint_server" {
//  role       = aws_iam_role.waypoint_server_execution_role.name
//  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
//  
//  tags = {
//    Environment = "Development"
//    Owner = "Nic Jackson"
//    Project = "Waypoint ECS Test"
//  }
//}

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