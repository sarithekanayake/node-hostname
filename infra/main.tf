module "vpc" {
  source = "git::https://github.com/sarithekanayake/node-hostname.git//vpc?ref=v1.2.0"

  env = var.env
  no_of_pri_subs = 2
  no_of_pub_subs = 2
  eks_name = var.eks_name
}

module "eks" {
  source = "git::https://github.com/sarithekanayake/node-hostname.git//eks?ref=v1.2.0"

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
  source = "git::https://github.com/sarithekanayake/node-hostname.git//dns?ref=v1.1.0"

  domain_name = var.domain_name

  depends_on = [ module.eks ]
}