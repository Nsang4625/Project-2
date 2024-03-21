variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "first_public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "second_public_subnet_cidr" {
  type    = string
  default = "10.0.4.0/24"
}
variable "first_private_subnet_web_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
variable "second_private_subnet_web_cidr" {
  type    = string
  default = "10.0.5.0/24"
}
variable "first_private_subnet_rds_cidr" {
  type    = string
  default = "10.0.3.0/24"
}
variable "second_private_subnet_rds_cidr" {
  type    = string
  default = "10.0.6.0/24"
}
