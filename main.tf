# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "cicd-jen-ter-buck"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# Use AWS Terraform provider
provider "aws" {
  region = "us-east-1"
}

# Create EC2 instance
resource "aws_instance" "Demo-Server" {
  ami                    = var.ami
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.Demo-SG.id]
  source_dest_check      = false
  instance_type          = var.instance_type

  tags = {
    Name = "Terraform-Demo-Server"
  }
}

# Create Security Group for EC2
resource "aws_security_group" "Demo-SG" {
  name = "Terraform-Demo-SG"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
