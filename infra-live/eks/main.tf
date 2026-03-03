
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "enterprise-txn-tf-state-202603"
    key    = "network/terraform.tfstate"
    region = "ap-south-1"
  }
}

module "eks" {
  source = "../terraform/modules/eks"

  cluster_name      = "enterprise-eks"
  private_subnet_1  = data.terraform_remote_state.network.outputs.private_subnet_1_id
  private_subnet_2  = data.terraform_remote_state.network.outputs.private_subnet_2_id
}
