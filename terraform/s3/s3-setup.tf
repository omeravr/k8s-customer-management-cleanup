provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-remote-state-ec2-test"
  acl    = "private"

  versioning {
    enabled = false
  }

  tags = {
    Name = "terraform-state"
  }
}

