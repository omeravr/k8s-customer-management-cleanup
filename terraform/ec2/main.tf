provider "aws" {
  region = "eu-central-1"
}

# Create S3 bucket to store Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-test-ec2-s3-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "terraform-state"
    Environment = "Test"
  }
}

# EC2 Instance creation
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your preferred AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "TestInstance"
  }
}

# Store state in the created S3 bucket
terraform {
  backend "s3" {
    bucket = aws_s3_bucket.terraform_state.bucket
    key    = "terraform/ec2/state.tfstate"
    region = "eu-central-1"
    encrypt = true
  }
}

