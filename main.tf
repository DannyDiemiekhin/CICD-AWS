provider "aws" {
    region = "ca-central-1"
  
}

terraform {
  backend "s3" {
    bucket = "ci-cd-terrafrom-backend"
    key = "build/terraform.tfstate"
    region = "ca-central-1"
}
    
}


resource "aws_default_vpc" "default" {}

data "aws_availability_zones" "availability_zones" {}

resource "aws_instance" "my-web" {
    ami = "ami-099effcf516c942b7"
    instance_type = "t2.micro"
    subnet_id = aws_default_subnet.web.id
    vpc_security_group_ids = [aws_security_group.ec2-SG.id]
    key_name = "Canada"
    user_data = file("install_tecmax.sh")

}

resource "aws_default_subnet" "web" {
    availability_zone = data.aws_availability_zones.availability_zones.names[0]  
}

resource "aws_security_group" "ec2-SG" {
    name = "ec2-security-group"
    vpc_id = aws_default_vpc.default.id

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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup"
    Owner = "Danny Dannettt"
  }
}