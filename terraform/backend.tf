backend "s3" {
    bucket         = "peris-tf-flask-app-bucket"
    key            = "eks/terraform.tfstate"
    region         = var.aws_region
    use_lockfile   = true
    encrypt        = true
}