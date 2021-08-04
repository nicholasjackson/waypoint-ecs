# Terraform Waypoint Runner

Terraform configuration for creating a Waypoint remote runner on EC2 that can be used with a Waypoint server running in ECS Fargate.

This config creates the following resources:
* micro EC2 instance
* Security group to enable remote access to the runner
* AWS IAM policy to allow the runner to interact with ECR and to deploy applications to ECS

## Variables
**subnet_id** - The ID of the subnet that the EC2 instance will be created in, if using the `infra` Terraform config this id can be 
read from the Terraform output variables.  

**waypoint_server_addr** - The NLB address for the Waypoint server, this value is output after the `waypoint install` command has completed.  

**waypoint_server_token** - A valid Waypoint server token that can be used by the runner to connect to the Waypoint server. Can be generated  
using the `waypoint token` command.  

**ssh_public_key** - Public key that can be used to log onto the remote runner.  