provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.endpoint
    cluster_ca_certificate = base64decode(module.eks.ca_data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

terraform {
  backend "s3" {}
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
    helm = {

    }
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = var.eks_name
}

