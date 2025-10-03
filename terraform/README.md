# INFRASTRUCTURE PROVISIONING ON AWS USING TERRAFORM

## Prerequisites
- AWS Account: Create an AWS account if you don’t have one with required permissions. For this demo 
  you can use AdministratorAccess.
- IAM Access Keys: Set up access keys so you can connect to your AWS account.
- S3 Bucket: Create an S3 bucket to store your Terraform state files securely.Enable versioning on 
  the bucket so you can track state file history.
- AWS CLI: Install and configure the AWS CLI.
- Terraform: Make sure Terraform is installed on your local machine.
- Database Password (Environment Variable) - Export database credentials before running Terraform 
  so they’re injected securely or enter password during runtime for terraform plan
  ```bash
  export TF_VAR_db_password="yourdbpassword"
  ```
 
## Folder Structure
```bash
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
│   ├── security_groups
│   │   ├── outputs.tf
│   │   ├── security_group.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── provider.tf
├── README.md
└── variables.tf
```
## Run terraform
1. Connect to AWS
    ```bash
    aws configure
    ```
   Make sure your credentials and default region are set.

2. Initialize Terraform
  This downloads required providers and configures the backend (S3).
  ```bash
  terraform init
  ```

3. Validate configuration(Optional)
   Check syntax and confirm if there are errors on the configuration
    ```bash
    terraform validate
    ```

4. Preview changes
   This outputs what infrastructure be created, modified or destroyed
   ```bash
   terraform plan
   ```
5. Apply changes
   To deploy infrastructure(modify/create) run:
   ```bash
   terraform apply
   ```

6. Destroy resources
   To cleanup/remove resources after you are done run:
   ```bash
   terraform destroy

## Notes

- Remote state is stored in S3 (peris-tf-flask-app-bucket) with locking enabled and versioning enabled.

- VPC, Security Groups, EKS cluster, and RDS are modularized for clarity and reusability. 

** Improvements: **

- Use aws secrets manager to store secrets.

- Add separate workspaces for dev/staging/prod.

- Automate deployments via GitHub Actions CI/CD pipeline.