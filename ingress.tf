resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
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

// todo template this
resource "kubernetes_manifest" "letsencrypt_http_cluster_issuer" {
  manifest = yamldecode(file("${path.module}/cluster/cert-manager/ca.yml"))
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = "external-dns"
  create_namespace = true
  set {
    name  = "provider"
    value = "cloudflare"
  }

  set {
    name  = "cloudflare.apiToken"
    value = var.cloudflare_api_token
  }

  set {
    name  = "cloudflare.email"
    value = var.cloudflare_acount_email
  }

  set {
    name  = "cloudflare.proxied"
    value = false
  }
}