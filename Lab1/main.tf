provider "aws" {
  region = "us-east-1"
}
 
resource "aws_instance" "myAmazon" {
  #ami           = data.aws_ami.ubuntu.id
  ami           = "ami-02538f8925e3aa27a"
  instance_type = "t2.micro"
  tags = {
    Name  = "My Amazon EC2"
    Owner = "Dhananjay Dogra"
    project = "My Terrafrom IT"
  }
}