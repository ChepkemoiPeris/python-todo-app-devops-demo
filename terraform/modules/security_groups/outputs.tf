output "eks_nodes_sg_id" {
  value = aws_security_group.eks_nodes_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
