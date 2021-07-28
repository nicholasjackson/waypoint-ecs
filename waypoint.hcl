project = "hello-world"

app "web" {
    build {
        #use "docker" {}
        use "docker-pull" {
          image = "nicholasjackson/fake-service"
          tag   = "v0.22.7"
        }

        #registry {
        #  use "aws-ecr" {
        #    region = "eu-west-1"
        #    repository = "938765688536.dkr.ecr.eu-west-1.amazonaws.com/dev-development-waypoint/hello-world"
        #    tag = "latest"
        #  }
        #}
    }

    deploy {
      use "aws-ecs" {
        region = "us-east-1"
        memory = 512
      }
    }
}