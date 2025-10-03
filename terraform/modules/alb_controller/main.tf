module "alb_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "alb-controller-irsa"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    eks = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.8.1"  
  timeout = 900
  
  set =[{
    name  = "clusterName"
    value = var.cluster_name
  },
  {
    name  = "serviceAccount.create"
    value = "true"
  },
  {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  },
   {
    name  = "region"
    value = var.aws_region
  },
   {
    name  = "vpcId"
    value = var.vpc_id
  }]
}
