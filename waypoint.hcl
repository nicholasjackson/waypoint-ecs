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
        tag        = "latest"
      }
    }
  }

  deploy {
    use "aws-ecs" {
      memory = 512
    }
  }
}
