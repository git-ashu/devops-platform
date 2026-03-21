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

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = var.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  resolve_conflicts_on_create = "OVERWRITE"
}

resource "kubernetes_manifest" "default_storageclass" {
  manifest = {
    apiVersion = "storage.k8s.io/v1"
    kind       = "StorageClass"
    metadata = {
      name = "gp2"
      annotations = {
        "storageclass.kubernetes.io/is-default-class" = "true"
      }
    }
    provisioner = "ebs.csi.aws.com"
    volumeBindingMode = "WaitForFirstConsumer"
  }
}
