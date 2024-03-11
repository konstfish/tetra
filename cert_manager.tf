resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
    labels = {
      "field.cattle.io/projectId" = "system"
    }
    annotations = {
      "management.cattle.io/system-namespace" : "true"
    }
  }

  depends_on = [ local_file.ansible_inventory ]

  lifecycle {
    ignore_changes = [
      metadata.0.labels,
      metadata.0.annotations,
    ]
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [ kubernetes_namespace.cert_manager, helm_release.ingress_nginx ]
}

// todo template this
resource "kubernetes_manifest" "letsencrypt_http_cluster_issuer" {
  manifest = yamldecode(file("${path.module}/cluster/cert-manager/letsencrypt-http.yml"))

  depends_on = [ helm_release.cert_manager ]
}

resource "kubernetes_manifest" "letsencrypt_dns_cluster_issuer" {
  manifest = yamldecode(file("${path.module}/cluster/cert-manager/letsencrypt-dns.yml"))

  depends_on = [ helm_release.cert_manager, kubernetes_secret.cloudflare_api_token_secret ]
}

resource "kubernetes_secret" "cloudflare_api_token_secret" {
  metadata {
    name = "cloudflare-api-token-secret"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }

  type = "Opaque"

  data = {
    "api-token" = var.cloudflare_api_token
  }

  depends_on = [ helm_release.cert_manager ]
}