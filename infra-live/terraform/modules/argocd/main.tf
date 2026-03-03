resource "helm_release" "argocd" {
  name             = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.11"

  values = [
    file("${path.module}/values.yaml")
  ]

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}
