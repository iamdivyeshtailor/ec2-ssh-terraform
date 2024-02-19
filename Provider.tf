terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_vpc" "GetVPC" { 
 filter { 
     name = "tag:Name" 
     values = ["terraform-vpc"] 
     } 
 } 
 data "aws_subnet" "GetPublicSubnet" { 
 filter { 
     name = "tag:Name" 
     values = ["terraform-vpc-subnet"] 
     } 
 }

provider "aws" {
  region     = "ap-south-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_security_group" "ec2_sg" {
  name        = "allow_SSH"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.GetVPC.id

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "EXPERIMENT_1" {
  ami           = var.ami
  instance_type = "t2.micro"       
  key_name      = var.key_pair_name 
  security_groups = [aws_security_group.ec2_sg.id]
  subnet_id = "subnet-0c5f75d5698d16f3c"
}

