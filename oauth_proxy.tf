// OAuth Zero
resource "helm_release" "oauth2_proxy_zero" {
  name             = "oauth2-proxy-zero"
  repository       = "https://oauth2-proxy.github.io/manifests"
  chart            = "oauth2-proxy"
  namespace        = "oauth-proxy"
  create_namespace = true

  values = [
    file("${path.module}/cluster/helm/oauth/zero.yml"),
  ]

  set {
    name  = "config.clientID"
    value = var.oauth_client_id_zero
  }

  set {
    name  = "config.clientSecret"
    value = var.oauth_client_secret_zero
  }

  set {
    name  = "config.cookieSecret"
    value = var.oauth_cookie_secret_zero
  }

  depends_on = [local_file.ansible_inventory]
}

variable "oauth_client_id_zero" {
  description = "OAuth client ID"
  type        = string
}

variable "oauth_client_secret_zero" {
  description = "OAuth client secret"
  type        = string
  sensitive   = true
}

variable "oauth_cookie_secret_zero" {
  description = "OAuth cookie secret"
  type        = string
  sensitive   = true
}

// OAuth Negative
resource "helm_release" "oauth2_proxy_negative" {
  name             = "oauth2-proxy-negative"
  repository       = "https://oauth2-proxy.github.io/manifests"
  chart            = "oauth2-proxy"
  namespace        = "oauth-proxy"

  values = [
    file("${path.module}/cluster/helm/oauth/negative.yml"),
  ]

  set {
    name  = "config.clientID"
    value = var.oauth_client_id_negative
  }

  set {
    name  = "config.clientSecret"
    value = var.oauth_client_secret_negative
  }

  set {
    name  = "config.cookieSecret"
    value = var.oauth_cookie_secret_negative
  }

  depends_on = [local_file.ansible_inventory, helm_release.oauth2_proxy_zero]
}

variable "oauth_client_id_negative" {
  description = "OAuth client ID"
  type        = string
}

variable "oauth_client_secret_negative" {
  description = "OAuth client secret"
  type        = string
  sensitive   = true
}

variable "oauth_cookie_secret_negative" {
  description = "OAuth cookie secret"
  type        = string
  sensitive   = true
}