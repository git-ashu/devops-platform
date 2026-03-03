module "vpc" {
  source = "../terraform/modules/vpc"

  vpc_cidr               = "10.0.0.0/16"
  public_subnet_cidr_1   = "10.0.1.0/24"
  public_subnet_cidr_2   = "10.0.2.0/24"
  private_subnet_cidr_1  = "10.0.3.0/24"
  private_subnet_cidr_2  = "10.0.4.0/24"

  az1 = "ap-south-1a"
  az2 = "ap-south-1b"
}
