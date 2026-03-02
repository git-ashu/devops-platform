resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace        = "ingress-nginx"
  create_namespace = true
}

resource "helm_release" "mongodb" {
  name       = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"

  namespace        = "data"
  create_namespace = true

  set = [
    {
      name  = "auth.rootPassword"
      value = "admin123"
    },
    {
      name  = "persistence.storageClass"
      value = "gp2"
    },
    {
      name  = "persistence.size"
      value = "5Gi"
    }
  ]
}

