# Build Webserver using Bootstrap with External Template file

provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {} // Need to be added to get the VPC id

resource "aws_eip" "web-eip" {
  instance = aws_instance.myec2.id
  tags = {
    "Name"  = "EIP for Webserver built by terraform"
    "Owner" = "Dhananjay"
  }
}

resource "aws_instance" "myec2" {
  ami                    = "ami-05fa00d4c63e32376" //Amazon Linux 2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Dhananjay"
    l_name = "Dogra"
    names  = ["John", "Angel", "David", "Victor", "Melissa", "Kitana"]
  })
  user_data_replace_on_change = true                 # Added in the new AWS provider!!!
  tags = {
    "Name"  = "Webserver built by terraform"
    "Owner" = "Dhananjay"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_sg" {
  name        = "webserver-SG"
  description = "Security group for webserver"

  dynamic "ingress" {
    for_each =["80","443"]
    content {
      description = "Allow port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
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