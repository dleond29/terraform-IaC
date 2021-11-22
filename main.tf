#Selección del proveedor
provider "aws" {
  region = "us-east-1"
}

#Creación de servidor web
resource "aws_instance" "project-instance" {
  instance_type     = "t2.micro"
  ami               = "ami-083654bd07b5da81d"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = {
    Name = "terraform-project"
  }
}

#Grupo de seguridad para permitir el tráfico entrante o saliente
resource "aws_security_group" "instance" {
  name = "terraform-project-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

output "public_ip" {
  value       = aws_instance.project-instance.public_ip
  description = "The public IP address of the web server"
}