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
        tag        = "latest"
        repository = "hashicorp-dev-waypoint"

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
