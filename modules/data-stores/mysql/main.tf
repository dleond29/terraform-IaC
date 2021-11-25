# terraform {
#   required_version = ">= 0.12, < 0.13"
# }

resource "aws_db_instance" "projectInstance" {
  identifier_prefix   = "terraform-project"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = var.db_name
  username            = var.db_username
  password            = var.db_password
  publicly_accessible = true
  skip_final_snapshot = true
}