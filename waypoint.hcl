project = "hello-world"

runner {
  enabled = true

  data_source "git" {
    url = "https://github.com/nicholasjackson/waypoint-ecs"
  }

  poll {
    enabled = true
  }
}

app "web" {
  build {
    use "docker" {}

    registry {
      use "aws-ecr" {
        region     = "eu-west-1"
        repository = "938765688536.dkr.ecr.eu-west-1.amazonaws.com/dev-development-waypoint"
        tag        = "latest"
      }
    }
  }

  deploy {
    use "aws-ecs" {
      region = "eu-west-1"
      memory = 512
    }
  }
}