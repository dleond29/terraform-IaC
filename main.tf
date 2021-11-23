#Selección del proveedor
provider "aws" {
  region = "us-east-1"
}

#Configuración de la instancia
resource "aws_launch_configuration" "project-instance" {
  image_id        = "ami-083654bd07b5da81d"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

    # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

#Fuente de datos para buscar la VPC predeterminada
data "aws_vpc" "default" {
  default = true
}

#Fuente de datos para buscar subredes dentro de la VPC predeterminada
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

#Creación grupo de autoescalado
resource "aws_autoscaling_group" "project-instance" {
  launch_configuration = aws_launch_configuration.project-instance.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 1
  max_size = 1

  tag {
    key                 = "Name"
    value               = "terraform-asg-project-instance"
    propagate_at_launch = true
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

#Creación balanceador de carga de aplicaciones
resource "aws_lb" "project-instance" {
  name               = "terraform-asg-project-instance"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.alb.id]
}

#Definición del oyente para el balanceador de carga de aplicaciones
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.project-instance.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

#Creación de reglas de escucha
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

#Creación grupo de seguridad para el balanceador de carga de aplicaciones
resource "aws_security_group" "alb" {
  name = "terraform-project-instance-alb"

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Creación de grupo objetivo para el grupo de autoescalado
resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-project-instance"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

output "alb_dns_name" {
  value       = aws_lb.project-instance.dns_name
  description = "The domain name of the load balancer"
}
