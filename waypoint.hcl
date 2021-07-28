project = "hello-world"

app "web" {
    build {
        use "docker" {}

        registry {
          use "aws-ecr" {
            region = "eu-west-1"
            tag = "latest"
          }
        }
    }

    deploy {
      use "aws-ecs" {
        region = "us-east-1"
        memory = 512
      }
    }
}