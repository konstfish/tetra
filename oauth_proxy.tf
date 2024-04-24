resource "helm_release" "oauth2_proxy" {
  name             = "oauth2-proxy"
  repository       = "https://oauth2-proxy.github.io/manifests"
  chart            = "oauth2-proxy"
  namespace        = "oauth-proxy"
  create_namespace = true

  values = [
    file("${path.module}/cluster/helm/oauth/values.yml"),
  ]

  set {
    name  = "config.clientID"
    value = var.oauth_client_id
  }

  set {
    name  = "config.clientSecret"
    value = var.oauth_client_secret
  }

  set {
    name  = "config.cookieSecret"
    value = var.oauth_cookie_secret
  }

  depends_on = [local_file.ansible_inventory]
}

// OAuth
variable "oauth_client_id" {
  description = "OAuth client ID"
  type        = string
}

variable "oauth_client_secret" {
  description = "OAuth client secret"
  type        = string
  sensitive   = true
}

variable "oauth_cookie_secret" {
  description = "OAuth cookie secret"
  type        = string
  sensitive   = true
}