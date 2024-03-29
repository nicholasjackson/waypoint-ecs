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
        repository = "hashicorp-dev-hello-world"
        region     = "eu-west-1"
        tag        = "v1"
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
