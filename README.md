# Terraform AWS Root Module

Root Terraform configuration that provisions a complete AWS infrastructure by consuming 4 reusable module repositories.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     terraform-aws-root                      │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   VPC Module  │  │  EC2 Module  │  │  S3 Module   │      │
│  │  (public repo)│  │ (public repo)│  │ (public repo)│      │
│  └──────┬───────┘  └──────┬───────┘  └──────────────┘      │
│         │   subnet_ids    │                                  │
│         └────────────────►│                                  │
│         │                                                    │
│         │  ┌──────────────┐                                  │
│         │  │  RDS Module  │                                  │
│         │  │ (public repo)│                                  │
│         │  └──────┬───────┘                                  │
│         │ subnet_ids      │                                  │
│         └────────────────►│                                  │
└─────────────────────────────────────────────────────────────┘
```

## Module Repositories

| Module | Repository | Description |
|--------|------------|-------------|
| VPC | [terraform-aws-vpc](https://github.com/Shaunak-ondare/terraform-aws-vpc) | VPC, subnets, IGW, NAT GW, route tables |
| EC2 | [terraform-aws-ec2](https://github.com/Shaunak-ondare/terraform-aws-ec2) | EC2 instance |
| S3 | [terraform-aws-s3](https://github.com/Shaunak-ondare/terraform-aws-s3) | S3 bucket with versioning & encryption |
| RDS | [terraform-aws-rds](https://github.com/Shaunak-ondare/terraform-aws-rds) | RDS instance with DB subnet group |
| Root | [terraform-aws-root](https://github.com/Shaunak-ondare/terraform-aws-root) | Root repo consuming all 4 modules |

## Resources Created (21 total)

| Module | Resources |
|--------|-----------|
| **VPC** | VPC, 2 public subnets, 2 private subnets, IGW, NAT GW, EIP, 2 route tables, 4 route table associations |
| **EC2** | 1 EC2 instance (Ubuntu 22.04, `t2.micro`, public subnet) |
| **S3** | S3 bucket, versioning, server-side encryption (AES256), public access block |
| **RDS** | DB subnet group, RDS instance (MySQL 8.0, `db.t3.micro`, private subnets) |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- AWS CLI configured with valid credentials (`aws configure`)
- S3 bucket `multi-repo-git-terraform-backend-shaunak` created in `ap-south-1` for state storage
- EC2 key pair `Mumbai.pem` created in `ap-south-1`

## Quick Start

```bash
# Clone the repo
git clone https://github.com/Shaunak-ondare/terraform-aws-root.git
cd terraform-aws-root

# Initialize (fetches modules from GitHub + configures S3 backend)
terraform init

# Preview resources
terraform plan

# Deploy
terraform apply

# Destroy when done
terraform destroy
```

## Configuration

Edit `terraform.tfvars` to customize:

```hcl
aws_region  = "ap-south-1"
environment = "dev"

# VPC
vpc_cidr             = "10.0.0.0/16"
vpc_name             = "my-vpc"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones   = ["ap-south-1a", "ap-south-1b"]

# EC2
ami_id        = "ami-0f58b397bc5c1f2e8"  # Ubuntu 22.04
instance_type = "t2.micro"
instance_name = "my-ec2-instance"
key_name      = "Mumbai.pem"

# S3
bucket_name       = "my-unique-bucket-name-12345"
enable_versioning = true

# RDS
db_identifier        = "my-database"
db_engine            = "mysql"
db_engine_version    = "8.0"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_name              = "myapp"
db_username          = "admin"
db_password          = "change-me-please!"
db_multi_az          = false
```

## Backend

State is stored remotely in S3:

| Setting | Value |
|---------|-------|
| Bucket | `multi-repo-git-terraform-backend-shaunak` |
| Key | `dev/terraform.tfstate` |
| Region | `ap-south-1` |

## Outputs

| Output | Description |
|--------|-------------|
| `vpc_id` | ID of the VPC |
| `public_subnet_ids` | Public subnet IDs |
| `private_subnet_ids` | Private subnet IDs |
| `ec2_instance_id` | EC2 instance ID |
| `ec2_public_ip` | Public IP of the EC2 instance |
| `ec2_private_ip` | Private IP of the EC2 instance |
| `s3_bucket_id` | S3 bucket name |
| `s3_bucket_arn` | S3 bucket ARN |
| `rds_endpoint` | RDS connection endpoint |
| `rds_arn` | RDS instance ARN |

## Cost Estimate

| Resource | Approx. Monthly Cost |
|----------|---------------------|
| NAT Gateway | ~$32 |
| RDS `db.t3.micro` | ~$12–15 |
| EC2 `t2.micro` | Free tier eligible |
| S3 | Negligible |

> ⚠️ Remember to run `terraform destroy` when you're done to avoid ongoing charges.
