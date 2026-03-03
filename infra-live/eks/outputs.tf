output "cluster_name" {
  value = module.eks.cluster_name
}

output "ebs_csi_role_arn" {
  value = module.eks.ebs_csi_role_arn
}
