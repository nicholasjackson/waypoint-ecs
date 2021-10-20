project = "hello-world"

app "web" {
  build {
    use "pack" {
      builder            = "heroku/buildpacks:20"
      disable_entrypoint = false
    }

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