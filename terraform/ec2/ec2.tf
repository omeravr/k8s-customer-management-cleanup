provider "aws" {
  region = "eu-central-1"
}

# EC2 instance creation
resource "aws_instance" "example" {
  ami           = "ami-0d1ddd83282187d18"
  instance_type = "t2.micro"
  subnet_id     = "subnet-044d911bc82994ac6"  # Specify the Subnet ID

  tags = {
    Name = "Test-EC2-Instance"
  }
}

# Output the public IP
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

