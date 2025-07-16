variable "env" {
  description = "Environment name"
  type = string
  default = "prod"
}

variable "eks_name" {
  description = "EKS Cluster name"
  type = string
  default = "bwt-eks"
}

variable "eks_version" {
  description = "EKS Cluster name"
  type = string
  default = "1.33"
}

variable "domain_name" {
  type = string
  description = "Public Domain to be created in Route53"
  default = "sarithe.online"
}

variable "ecr_repo" {
  type = string
  description = "ECR repo to store node-hostname docker images"
  default = "node-hostname"
}

variable "desired_size" {
  type = number
  description = "Desired Worker nodes"
  default = 2
}

variable "max_size" {
  type = number
  description = "Max Worker nodes"
  default = 5
}

variable "min_size" {
  type = number
  description = "Min Worker nodes"
  default = 1
}

variable "aws_lbc_version" {
  type = string
  description = "Helm chart version of AWS Load Balancer Controller"
  default = "1.9.2"
}