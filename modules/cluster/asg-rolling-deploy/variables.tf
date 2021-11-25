# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

#Dirige el asg-rolling-deploymódulo a las subredes en las que se implementará
variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "target_group_arns" {
  description = "The ARNs of ELB target groups in which to register Instances"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
  default     = "EC2"
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}

variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8090
}

#Esto es nuevo
variable "ec2_key_name" {
  default = "id_rsa"
}

variable "ec2_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9EWoEn4Hx2UGMPyb35iux90WSOcoweP3ICv9pfbDJNJLCHAv8f2nmFOnW5dL2xhPIMCxxbu2xpZ923Pye+sNznnf87OnV7MFa/PBrwvK2kTf2oOm17MTfYc+CdZy4vWGniz7IHKPZ93GQ6O3JeP1tGxx6Gx9ycLuierWVfaHhBz39iJSY02sXJdntOVJknn6alLKhfGRwj4Q4ZYFI/vFLEX9TClRW4TXYnmoxM9r/RjJyp5bMzS/WrHbUH9blx8G2I+XCRX3OmUgsrn4ksSMm/MtLbYsaTay4qbBZM2RaEA4seK6uJHxqBUfzkSERR5jsxicQS7GxFQdV65hUpzyabOiYVfL1M8h/8TbV/Of9o8Dbt5ZSTzffdqARa1ljc7ShVHe1XqN/nlV95IvcVZO60antmWN8VAxudRKb/YUrtiIZ4F5YjtbGr40jauMYxsz3nIp+hSTJ4ijFnUpzN38grnZkA8P/kqdoXF7dc+gHooyMi72d7FIESi1XlErHFfs= diego@LAPTOP-I48MMRNH"
}
variable "ec2_private_key_file_path" {
  default = "C:/Users/Diego/.ssh"
}