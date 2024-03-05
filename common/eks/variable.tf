variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "service_account" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_a" {
  type = string
}

variable "private_subnet_b" {
  type = string
}

variable "cluster_version" {
  type        = string
  description = "The eks cluster version"
}

variable "instance_types" {
  type = list(string)
}

variable "scaling_desired_count" {
  type        = number
  description = "The initial desired node count"
}

variable "scaling_min_count" {
  type        = number
  description = "The min node count"
}

variable "scaling_max_count" {
  type        = number
  description = "The max node count"
}

variable "aws_auth_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}
