module "argocd" {
  source = "../terraform/modules/argocd"
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

resource "kubernetes_manifest" "argocd_root_app" {
  manifest = yamldecode(file("${path.module}/../../cluster-config/argocd/root-app.yaml"))
}
