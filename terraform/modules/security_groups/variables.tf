variable "vpc_id" {
  description = "The ID of the VPC where security groups will be created"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "vpc_private_subnets" {
  description = "Private subnets associated with the VPC"
  type        = list(string)
}
