waypoint_version = 0.6.1

install_waypoint:
	waypoint server install -accept-tos \
	-platform=ecs \
	-ecs-server-image=hashicorp/waypoint:${waypoint_version} \
	-ecs-odr-image=hashicorp/waypoint-odr:${waypoint_version} \
	-ecs-cluster=waypoint-server \
	-ecs-cpu=512 \
	-ecs-mem=1024 \
	-ecs-execution-role-name=waypoint-server-execution-role \
	-ecs-region=eu-west-1 \
	-ecs-server-image=hashicorp/waypoint:latest \
	-ecs-subnets="$(shell terraform output --raw ecs_subnet_1),$(shell terraform output --raw ecs_subnet_2)" 

uninstall_waypoint:
	waypoint server uninstall \
	-ecs-region=eu-west-1 \
	-auto-approve \
	-platform=ecs