terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --- VPC Module ---
module "vpc" {
  source = "github.com/Shaunak-ondare/terraform-aws-vpc"

  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# --- EC2 Module ---
module "ec2" {
  source = "github.com/Shaunak-ondare/terraform-aws-ec2"

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = var.ec2_security_group_ids
  instance_name      = var.instance_name
  key_name           = var.key_name
}

# --- S3 Module ---
module "s3" {
  source = "github.com/Shaunak-ondare/terraform-aws-s3"

  bucket_name       = var.bucket_name
  enable_versioning = var.enable_versioning

  tags = {
    Environment = var.environment
    Project     = var.vpc_name
  }
}

# --- RDS Module ---
module "rds" {
  source = "github.com/Shaunak-ondare/terraform-aws-rds"

  db_identifier          = var.db_identifier
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  subnet_ids             = module.vpc.private_subnet_ids
  vpc_security_group_ids = var.rds_security_group_ids
  multi_az               = var.db_multi_az
}
