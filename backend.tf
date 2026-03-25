terraform {
  backend "s3" {
    bucket = "multi-repo-git-terraform-backend-shaunak"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}
