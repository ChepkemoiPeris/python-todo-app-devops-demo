output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}


output "rds_port" {
  value = module.rds.db_instance_port
}

output "rds_host" {
  value = module.rds.db_instance_address
}