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
  subnet_id = module.netflix_app_vpc.public_subnets[0]

  tags = {
    Name      = "alonit-tf-netflix-${var.env}"
    Terraform = "owned"
    Env       = var.env
  }
}

module "netflix_app_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "alonit-netflix-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.vpc_azs
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets  = ["10.0.2.0/24", "10.0.3.0/24"]

  enable_nat_gateway = false

  tags = {
    Env         = var.env
  }
}


