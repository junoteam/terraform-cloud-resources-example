provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  user_data = file("./init.yaml")

  # user_data = <<-EOT
  #   #!/bin/bash
  #   echo "Hello Terraform!"
  #   mkdir ~/.ssh/ 
  #   touch touch ~/.ssh/authorized_keys
  #   echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDyQd3GtSqa9baNUZyrTN8pWBxV5wHEUoHxeE1z5Yi66szMbT1tRjt/vOMLpHFzyb3Zbn0mdDGvcyrJocS0lP00ZQKTJi5e5WnVPaeGKU9nAy09aV33NsmuIi3y4jNExft4KXBUM6dfMWVu4oBWPL4kCuHqtupzYmlnoGHheq2xbaoqAVQAEJs3ulmKbXxoqzIua5J0A1qo60UYQrLqjlVOV1qLXMcpJtshcGeDb9myZAttamNmFM5AMLZProMY8A3yO/V3aQtCoBzl4xdtlCEQpzlBJOr85lbGTyEh63NqEyW980D65AJHXuwrjJq9UJ8jNcX8VIyC9U6kiQsVwZAZFr9Q6h0E5z/l283yk3vdNTOJu6WR3Hsu7YCKU2+T7QcP31Qdc8bCwbOOF5UqCDcvDn1P+ip5o9j+sGv/u3k6bzIQWo8QKJOaoBiTKzhnSUfJhLuPWPNFylx69TgDaCd20ejwm4DSre+WSitPhS86tdCN2zo/6YupDArvzvwC4Ll9PeVNz9a8wE2kTOfcPd8pkb8rNRSiDyPTYnZ/iYlQre4z/w+NNH7ZVaVzCytsinWQer0jnSV1ogxm8ZTWnkLckt/demAOUzT/y6dhjrjcaxhcpm84WohCHxcMWudSDzsuS/qDxXevjLKp2YP/QzmW8quGu75iHYkq1pgkYRyJ4Q== alex@Alexs-MacBook-Pro.local >> ~/.ssh/authorized_keys"
  #   chmod 600 ~/.ssh/authorized_keys
  # EOT

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ec2-instance"
  }
}

################################################################################
# EC2 Module
################################################################################

module "ec2_complete" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  name = local.name

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true
  disable_api_stop            = false

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true

  #cpu_core_count       = 2 # default 4
  #cpu_threads_per_core = 1 # default 2

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  tags = local.tags
}

resource "aws_eip" "this" {
  vpc      = true
  instance = "${module.ec2_complete.id[0]}"
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0.2"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  tags = local.tags

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true
}

################################################################################
# Security Group Module
################################################################################
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.17.2"

  name        = local.name
  description = "Security group for example usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = local.tags
}
