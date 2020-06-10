variable "ami" {
  description = "Amazon Machine Image(usually ubuntu 18.04)"
  type = string
}

variable "instance_type" {
  description = "instance tpye"
  type = string
}

variable "vpc_security_group_ids" {
  description = "use security group id"
  type = string
}


