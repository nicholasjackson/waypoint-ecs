variable "vpc_id" {
  description = "ID for the VPC to deploy the runner into"
  default = "vpc-07fd0deda705a5a82"
}

variable "subnet_id" {
  description = "ID for the Subnet to deploy the runner into"
  default = "subnet-0d62732839b45ae55"
}

variable "waypoint_server_addr" {
  description = "Address of the Waypoint server"
  default = "waypoint-server-nlb-2794f5b19684c187.elb.eu-west-1.amazonaws.com:9701"
}

variable "waypoint_server_token" {
  description = "Token to be used for accessing the Waypoint server"
  default = "bM152PWkXxfoy4vA51JFhR7LobrtRJp9RSso5fDx9uwJmXWxEv9YnbUTX9E51EhTWt2MGQyfEooa1gxcQeJR7VM9qtWgaz7JdFhoN"
}

variable "ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxszwBangHDUAK9K8dtlCFVrAoChaMgJvHdyhZOcjrby2g2vzp5Y9CppscGQ6kXAv0j+Ax1GuXpEcFVS3YSP3FA2uVAEg2XnzKV3xa/Un4FHDEX63N0kk+qjguN34KSg44e7xunCCYiJSMLCGwP1MR8qaKsuMir0k715mClfN6ACpRTRUVe6NpguUTxBoYAaqWD4OeMMLmpl94JAQ8ON3wRHf3A57aIRvOx6aeyJjUOeUq9KLApFZmq8HXO8iP0RDRDIR9RkT1UEefkvVCeppkYJ3MwzRXGquwX/F0b47OC3tsu0jsYIYjHYm2lDwCjUvO+PxBUlMIZIzgjwPGehjenjTVKyW8/kbkN/Ri7bzeGlsdM66HDLGJWWDUUIB3CgKD4suLSya36AZsJKH3ocLUkZajXD0R6OTLmXdt0OTKswDIJ6FWnHPYfipPscEfaoeYWtFCHMEL8Fc5AVsiElPJGAd1uD8PdmJPBRChuB2QbbBPzaeng0gaVeM6X//oQ0vqFfLcpwDuUyqmf3hS4+8uMRgLnmFTt5CbIAwYEv6p5GtEOuq6syr7MP0kl4ExRIBi2XLbga2NaK4UWn9/A4Z9Ux6aN56Vjv+q9tSXFn62F3/LS3Tq/HNyxhHswvoiaxx5ICKDk/h/QYn4kOTCOJoUOXejsV1NfLDQ95NfTxVnOw== cardno:000605033891"
}