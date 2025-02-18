terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.55"
    }
  }

  backend "s3" {
    bucket = "alonit-netflix-infra-tfstate"
    key    = "tfstate.json"
    region = "us-west-2"
    # optional: dynamodb_table = "<table-name>"
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.region
  #  profile = "default"  # change in case you want to work with another AWS account profile
}

resource "aws_instance" "netflix_app" {
  #  ami           = "ami-09a9858973b288bdd"
  ami           = var.ami_id
  instance_type = "t3.micro"

  tags = {
    Name      = "alonit-tf-netflix-${var.env}"
    Terraform = "owned"
    Env       = var.env
  }
}


