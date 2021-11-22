terraform {
  required_version = "> 0.7.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "project-instance" {
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  ami               = "ami-083654bd07b5da81d"
  
  tags = {
    Name = "terraform-project"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo service apache2 start
              EOF
}
