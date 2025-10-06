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

## GitHub Actions for Terraform

This project includes a GitHub Actions workflow to automate provisioning of AWS infrastructure (VPC, EKS, RDS).

### Required Secrets

To enable the workflow, add the following repository secrets under Settings → Secrets → Actions:

| Secret Name             | Purpose                                                       |
|-------------------------|---------------------------------------------------------------|
| `AWS_ACCESS_KEY_ID`     | AWS IAM user access key with permissions for Terraform       |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM user secret key                                       |
| `AWS_REGION`            | AWS region where resources will be created                   |
| `EKS_CLUSTER_NAME`      | Name of the EKS cluster to create/manage                     |
| `DB_PASSWORD`           | DB password for rds                                          |

Once these are set, pushing changes to the `terraform/` folder (excluding README.md) will automatically trigger the workflow.

## Challenges faced: 
  - Encountered dependency destruction issues during terraform apply and terraform destroy due to interlinked AWS resources (like subnets and NAT gateways) or when using VPC outputs for RDS and EKS. Fixed by adding appropriate depends_on blocks and improving destroy ordering. If you face similar issue you can also delete load balancers from console/UI directly
  - Faced challenges with secrets management — currently using exported environment variables and passing them to secrets.yaml for Kubernetes. This could be improved by integrating AWS Secrets Manager in future versions.
  - Ran into a Terraform state lock issue when running terraform commands - if you face this issue just ran: 
      ```bash
      terraform force-unlock <LOCK_ID>
      ```
  - (Note: EKS can be quite expensive to run since it’s not covered under AWS Free Tier!) 