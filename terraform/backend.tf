terraform {
    backend "s3" {
    bucket         = "peris-tf-flask-app-bucket"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
}
}