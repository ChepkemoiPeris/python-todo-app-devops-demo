module "rds" {
  source = "terraform-aws-modules/rds/aws"
  

  identifier        = "flask-todo-app"
  engine            = "mysql"
  engine_version    = "8.0"
  major_engine_version = "8.0"
  family = "mysql8.0"
  instance_class    = var.db_instance_type 
  allocated_storage = 5
  db_subnet_group_name= var.db_subnet_group_name 
  manage_master_user_password = false

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = "3306"

  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_ids             = var.subnet_ids
  skip_final_snapshot = true 
}
