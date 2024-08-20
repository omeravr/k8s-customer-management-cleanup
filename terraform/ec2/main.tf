provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "terraform-test-ec2-s3-state"  # Hardcoded bucket name for storing state
    key    = "terraform/ec2/state.tfstate"  # Path to store the state file in the bucket
    region = "eu-central-1"  # AWS region
    encrypt = true
  }
}

variable "aws_region" {
  type = string
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Hardcoded Amazon Linux 2 AMI ID
  instance_type = var.instance_type
}

output "instance_id" {
  value = aws_instance.ec2_instance.id
}

