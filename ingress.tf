resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://helm.nginx.com/stable"
  chart            = "nginx-ingress"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [
    file("${path.module}/cluster/helm/nginx/values.yml"),
  ]

  depends_on = [ local_file.ansible_inventory ]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace = "cert-manager"
    create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}
