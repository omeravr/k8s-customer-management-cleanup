provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-remote-state-ec2-test"
    key    = "ec2/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Example AMI (replace with your preferred AMI)
  instance_type = "t2.micro"

  tags = {
    Name = "TestEC2"
  }
}

