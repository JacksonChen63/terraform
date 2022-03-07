variable "vpc_id" {
  type = string
}
variable "subnet_id_1" {
  type = string
}

variable "subnet_id_2" {
  type = string
}
variable "system_name" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
