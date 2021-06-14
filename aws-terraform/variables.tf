# --- root/variable.tf ---
variable "aws_region" {
  default = "us-east-1" # giving aws_region info to root/providers.tf
}

variable "access_ip" {
  type = string
}


# --- database variables ---

variable "dbname" {
  type = string
}

variable "dbuser" {
  type      = string
  sensitive = true
}

variable "dbpassword" {
  type      = string
  sensitive = true
}

