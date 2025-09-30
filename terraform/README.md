# INFRASTRUCTURE PROVISIONING ON AWS USING TERRAFORM

## Prerequisites
- AWS Account: Create an AWS account if you don’t have one with required permissions. For this demo 
  you can use AdministratorAccess.
- IAM Access Keys: Set up access keys so you can connect to your AWS account.

- S3 Bucket: Create an S3 bucket to store your Terraform state files securely.

- AWS CLI: Install and configure the AWS CLI.

- Terraform: Make sure Terraform is installed on your local machine.
 
## Folder Structure
terraform/
├── backend.tf
├── main.tf
├── modules
│   ├── eks
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── rds
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── provider.tf
├── README.md
└── variables.tf

