output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}
output "ebs_csi_role_arn" {
  value = aws_iam_role.ebs_csi_role.arn
}
