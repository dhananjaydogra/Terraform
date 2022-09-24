# Build Webserver using Bootstrap

provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {} // Need to be added to get the VPC id

resource "aws_instance" "myec2" {
  ami                    = "ami-05fa00d4c63e32376" //Amazon Linux 2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  user_data              = file("user_data.sh")

  tags = {
    "Name"  = "Webserver built by terraform"
    "Owner" = "Dhananjay"
  }

}

resource "aws_security_group" "my_sg" {
  name        = "webserver-SG"
  description = "Security group for webserver"

  ingress {
    description = "Allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"  = "Webserver SG by terraform"
    "Owner" = "Dhananjay"
  }

}