variable "ext_port" {
  type = number

  validation {
    condition     = var.ext_port <= 65535 && var.ext_port > 0
    error_message = "External port must in the valid port range 0 - 65535."
  }
}

variable "int_port" {
  type = number

  validation {
    condition     = var.int_port == 1880
    error_message = "Internal port must be 1880."
  }
}

variable "container_count" {
  type    = number
  default = 1
}