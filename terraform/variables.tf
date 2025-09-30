variable "aws_region" {
  default = "us-east-1"
}
variable "project_name" {
  default = "todo-app"
}

# VPC Name
variable "vpc_name" {
  description = "todo-app-vpc"
  type = string 
  default     = "todo-app-vpc"
}

# VPC Tags
variable "vpc_tags" {
  description = "todo-app-vpc"
  type        = map(string)
  default     = {
    Name = "todo-app-vpc"
    Project = "todo-app"
    Env = "dev"
  }
}


# VPC Public Subnets
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

# VPC Private Subnets
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# VPC Database Subnets
variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type = list(string)
  default = ["10.0.151.0/24", "10.0.152.0/24"]
}