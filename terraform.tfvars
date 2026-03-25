# --- General ---
aws_region  = "us-east-1"
environment = "dev"

# --- VPC ---
vpc_cidr             = "10.0.0.0/16"
vpc_name             = "my-vpc"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# --- EC2 ---
ami_id        = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
instance_type = "t2.micro"
instance_name = "my-ec2-instance"
# key_name    = "my-key-pair"            # Uncomment and set your key pair

# --- S3 ---
bucket_name       = "my-unique-bucket-name-12345"
enable_versioning = true

# --- RDS ---
db_identifier        = "my-database"
db_engine            = "mysql"
db_engine_version    = "8.0"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_name              = "myapp"
db_username          = "admin"
db_password          = "change-me-please!" # Use a secrets manager in production
db_multi_az          = false
