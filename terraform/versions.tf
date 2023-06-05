terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
  required_version = "~> 1.4.6"

  backend "s3" {
    bucket         = "terraform-example-ec2-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dynamo-db-table-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}