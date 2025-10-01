variable "db_username" {
  type    = string
  default = "todo_user"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_type" {
  type    = string
  default = "db.t3.micro"
}



variable "db_subnet_group_name" {
  type    = string 
  description = "Database subnet group name" 
}
variable "db_name" {
  type    = string
  default = "todo_db"
}

variable "vpc_security_group_ids" {
  description = "Security group id"
  type        = list(string)
}
variable "subnet_ids" {
  description = "List of database subnet IDs for rds"
  type        = list(string)
}
 