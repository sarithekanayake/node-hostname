data "aws_eks_cluster_auth" "eks" {
  name = var.eks_name
}

data "aws_caller_identity" "current" {}