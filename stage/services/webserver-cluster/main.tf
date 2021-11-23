provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  ami         = "ami-083654bd07b5da81d"
  server_text = "New server text v2"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "terraform-myproject-state"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 1
  max_size      = 1
  
}

#Exponer un puerto adicional, solo para realizar pruebas
resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}