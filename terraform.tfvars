# --- General ---
aws_region  = "ap-south-1"
environment = "dev"

# --- VPC ---
vpc_cidr             = "10.0.0.0/16"
vpc_name             = "my-vpc"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones   = ["ap-south-1a", "ap-south-1b"]

# --- EC2 ---
ami_id        = "ami-0f58b397bc5c1f2e8" # Ubuntu 22.04 LTS (ap-south-1)
instance_type = "t2.micro"
instance_name = "my-ec2-instance"
key_name    = "Mumbai.pem"            

# --- S3 ---
bucket_name       = "shaunak-s3-multirepo-bucket-2326"
enable_versioning = true

# --- RDS ---
db_identifier        = "my-database"
db_engine            = "mysql"
db_engine_version    = "8.0"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_name              = "myapp"
db_username          = "admin"
db_password          = "pass1234" # Use a secrets manager in production
db_multi_az          = false
