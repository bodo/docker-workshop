group "default" {
  targets = ["cli", "frontend", "backend", "test"]
  #targets = ["cli"]
}

target "cli" {
  context = "./cli"
  dockerfile = "Dockerfile"
  args = {
    GO_VERSION = "1.25.0"
  }
  tags = ["myapp/cli:latest"]
}

target "test" {
  context = "./test"
  dockerfile = "Dockerfile"
  args = {
    NODE_VERSION = "22"
  }
  tags = ["myapp/test:latest"]
}

target "frontend" {
  context = "./frontend"
  dockerfile = "Dockerfile"
  args = {
    NODE_VERSION = "22"
  }
  tags = ["myapp/frontend:latest"]
}


target "backend" {
  context = "./backend"
  dockerfile = "Dockerfile"
  args = {
    GO_VERSION = "1.25"
  }
  tags = ["myapp/backend:latest"]
}