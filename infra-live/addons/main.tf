module "argocd" {
  source = "../terraform/modules/argocd"
}

module "platform" {
  source = "../terraform/modules/platform"
  ebs_csi_role_arn = data.terraform_remote_state.eks.outputs.ebs_csi_role_arn
}

resource "helm_release" "prometheus_crds" {
  name       = "prometheus-crds"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "55.5.0"

  namespace        = "monitoring"
  create_namespace = true

  skip_crds = false

  values = [
  <<-EOF
  prometheus:
    enabled: false
  grafana:
    enabled: false
  alertmanager:
    enabled: false
  nodeExporter:
    enabled: false
  kubeStateMetrics:
    enabled: false
  EOF
  ]
  timeout = 600
}
