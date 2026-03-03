module "argocd" {
  source = "../terraform/modules/argocd"
}

module "platform" {
  source = "../terraform/modules/platform"
  ebs_csi_role_arn = data.terraform_remote_state.eks.outputs.ebs_csi_role_arn
}
