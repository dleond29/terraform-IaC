provider "aws" {
  region = "us-east-1"
}

module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
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