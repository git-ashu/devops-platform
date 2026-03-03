module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidr_1 = "10.0.10.0/24"
  public_subnet_cidr_2 = "10.0.11.0/24"

  private_subnet_cidr_1 = "10.0.2.0/24"
  private_subnet_cidr_2 = "10.0.3.0/24"

  az1 = "ap-south-1a"
  az2 = "ap-south-1b"
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id           = module.vpc.vpc_id
  key_name         = "enterprise-key-2"

  private_subnet_1 = module.vpc.private_subnet_1_id
  private_subnet_2 = module.vpc.private_subnet_2_id

  public_subnet_1  = module.vpc.public_subnet_1_id
  public_subnet_2  = module.vpc.public_subnet_2_id
}

module "eks" {
  source = "./modules/eks"

  cluster_name     = "enterprise-eks"

  private_subnet_1 = module.vpc.private_subnet_1_id
  private_subnet_2 = module.vpc.private_subnet_2_id
}

module "platform" {
  source = "./modules/platform"

  depends_on = [
    module.eks
  ]
}

module "kafka" {
  source = "./modules/kafka"

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.private_subnet_1_id
  key_name  = "enterprise-key"
}

module "argocd" {
  source = "./modules/argocd"

  depends_on = [
    module.eks
  ]
}
