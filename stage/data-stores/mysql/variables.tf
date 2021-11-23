variable "db_username" {
  description = "The password for the database"
  type        = string
  sensitive = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive = true

#Pasar el admin y pass por variables de entorno
#  $Env:TF_VAR_db_username = "admin"; $Env:TF_VAR_db_password = "adifferentpassword"
}