provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "projectInstance" {
  identifier_prefix   = "terraform-project"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "projectInstance_database"
  username            = var.db_username
  password            = var.db_password
  
  skip_final_snapshot = true
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-myproject-state"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-myproject-locks"
    encrypt        = true
  }
}