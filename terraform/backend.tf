terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
  }

  backend "s3" {
    bucket       = "web-chat-app-terraform-state"
    key          = "state/dev/resource.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}