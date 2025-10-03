# Kubernetes Deployment to EKS
 This folder contains Kubernetes manifests to deploy the Todo App on an EKS cluster.
## Prerequisites
- AWS account with appropriate permissions (AdministratorAccess is fine for demo purposes).
- AWS CLI installed and configured.
- `kubectl` installed.
- An EKS cluster already created using Terraform or even console or AWS CLI (see `/terraform` folder).
 
 
## Setup
1. **Configure AWS CLI**  
   Make sure your credentials are set:
   ```bash
   aws configure
   ```

2. **Update kubeconfig**
   Connect your local kubectl to the EKS cluster:
   ```bash
   aws eks --region <your-region> update-kubeconfig --name <your-eks-cluster-name>
   ```

3. **Verify connection**:
   Ensure you can reach your cluste
    ```bash
    kubectl get nodes
   ```
4. **Update configuration**
   - Edit configmap.yaml - update db_host and db_name to match your rds_endpoint.
   
   To encode values run this on your terminal:
   ```bash
   echo -n 'admin' | base64      # db username of your choice
   echo -n 'mypassword' | base64 # db password of your choice
   ```
   - Edit secret.yaml - set your encoded DB username and password. 

5. **Deploy resources**: 
   ```bash
   kubectl apply -f secret.yaml
   kubectl apply -f configmap.yaml
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   kubectl apply -f ingress.yaml
   ```
6. **Verify deployment**
   Check pods and logs:
   ```bash
   kubectl get pods
   kubectl logs <your-app-pod>
   ```

7. **Access the app**
   Get the Ingress hostname
   ```bash
   kubectl get ingress
   ```
   The output will include an address like xxxx.elb.amazonaws.com.
   Open this in your browser to access the app.

## Notes
 - It may take a few minutes for the LoadBalancer/Ingress to become active and receive a public DNS name.
 - For production, use proper secrets management (e.g., AWS Secrets Manager) instead of plain 
   Kubernetes secrets.