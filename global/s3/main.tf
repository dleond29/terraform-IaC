provider "aws" {
  region = "us-east-1"
}

#Creación de bucket de S3 para almacenar estado
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-myproject-state"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#Implementación de DynamoDB para bloquear con Terraform
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-myproject-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

#----------------------#---------------------#
# Hacer primero init y apply antes de seguir #
#----------------------#---------------------#

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-myproject-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-myproject-locks"
    encrypt        = true
  }
}


# Si alguna vez quisiera eliminar el bucket de S3 y la tabla de DynamoDB, tendría que realizar este proceso de dos pasos a la inversa:

# Vaya al código de Terraform, elimine la backendconfiguración y vuelva terraform inita ejecutar para copiar el estado de Terraform en su disco local.

# Ejecutar terraform destroypara eliminar el bucket de S3 y la tabla de DynamoDB.