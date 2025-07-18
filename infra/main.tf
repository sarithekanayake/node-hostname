locals {
  account_id    = data.aws_caller_identity.current.account_id
  region        = data.aws_region.current.name
  ecr_repo      = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${var.repo_name}"
  iam_user_arn  = "arn:aws:iam::${local.account_id}:user/sarithe"
}

module "vpc" {
  source = "git::https://github.com/sarithekanayake/bwt-tf-modules.git//vpc?ref=v1.4.1"

  env = var.env
  no_of_pri_subs = 2
  no_of_pub_subs = 2
  eks_name = var.eks_name
}

module "eks" {
  source = "git::https://github.com/sarithekanayake/bwt-tf-modules.git//eks?ref=v1.4.1"

  env = var.env
  eks_name = var.eks_name
  eks_version = var.eks_version

  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size
  aws_lbc_version = var.aws_lbc_version

  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids

  depends_on = [ module.vpc ]

}

module "dns" {
  source = "git::https://github.com/sarithekanayake/bwt-tf-modules.git//dns?ref=v1.4.1"

  domain_name = var.domain_name

  depends_on = [ module.eks ]
}

resource "helm_release" "node-hostname" {
  name = "node-hostname"
  chart = "../helm/node-hostname"
  namespace = "default"
  values = [sensitive(templatefile("./base_values/values.yaml",
  {
    "replicas"        = "2"
    "cert_arn"        = "${module.dns.ssl_cert}"
    "public_subnets"  = join(",", module.vpc.public_subnet_ids)
    "security_groups" = join(",", [module.eks.alb_sg, module.eks.cluster_sg])
    "domain_name"     = "${var.domain_name}"
    "repo"            = "${local.ecr_repo}"
    "image_tag"       = "${var.image_tag}"
  }
  ))]
  depends_on = [ module.dns ]
}

resource "aws_eks_access_entry" "iam_user" {
  cluster_name  = data.aws_eks_cluster.eks.name
  principal_arn = "${local.iam_user_arn}"
  type          = "STANDARD" 

  depends_on = [ helm_release.node-hostname ]
}

resource "aws_eks_access_policy_association" "iam_user" {
  cluster_name  = data.aws_eks_cluster.eks.name
  principal_arn = "${local.iam_user_arn}"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
  depends_on = [ helm_release.node-hostname ]
}