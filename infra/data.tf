data "aws_eks_cluster_auth" "eks" {
  name = var.eks_name
}
data "aws_eks_cluster" "eks" {
  name = var.eks_name

  depends_on = [ module.eks ]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}