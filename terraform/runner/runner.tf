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

data "aws_ami" "amazon-linux-2" {
 most_recent = true

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }

 owners = ["amazon"]
}

data "aws_iam_policy" "ecs_admin" {
  arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role" "runner_role" {
  name = "waypoint-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "runner_policy" {
  name        = "runner-policy"
  description = "A EC2 policy for Waypoint runners"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:*",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:PassRole",
        "iam:DetachRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:DeleteRole",
        "iam:CreateRole",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy",
        "elasticloadbalancing:ModifyListener"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "runner_attach" {
  role       = aws_iam_role.runner_role.name
  policy_arn = aws_iam_policy.runner_policy.arn
}

resource "aws_iam_role_policy_attachment" "runner_attach_ecs" {
  role       = aws_iam_role.runner_role.name
  policy_arn = data.aws_iam_policy.ecs_admin.arn
}

resource "aws_iam_instance_profile" "runner_profile" {
  name = "waypoint-runner-instance-profile"
  role = aws_iam_role.runner_role.name
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "runner_sg" {
  name        = "runner_sg"
  description = "Allow inbound traffic for Waypoint Runners"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "Liveness"
    from_port        = 1234
    to_port          = 1234
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "Runner"
    from_port        = 9701
    to_port          = 9701
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "Runner"
    from_port        = 9702
    to_port          = 9702
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_launch_configuration" "waypoint" {
  name_prefix   = "waypoint-runner"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t3.micro"
  
  associate_public_ip_address = true

  key_name = aws_key_pair.deployer.key_name
  
  security_groups = [aws_security_group.runner_sg.id]

  iam_instance_profile = aws_iam_instance_profile.runner_profile.name

  user_data_base64 = base64encode(
    templatefile(
      "${path.module}/cloud_init.tmpl",
      {
        waypoint_server_addr = var.waypoint_server_addr
        waypoint_server_token = var.waypoint_server_token
      }
    )
  )

  lifecycle {
    create_before_destroy = true
  }

  
}

resource "aws_autoscaling_group" "bar" {
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_configuration = aws_launch_configuration.waypoint.name

  vpc_zone_identifier = var.subnet_ids

  tag {
    key = "Name"
    value = "Waypoint Runner"
    propagate_at_launch = true
  }
}

output "runner_user" {
  value = "ec2-user"
}