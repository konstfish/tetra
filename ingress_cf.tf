resource "kubernetes_namespace" "cloudflare_tunnel_ingress_controller" {
  metadata {
    name = "cloudflare-tunnel-ingress-controller"
    labels = {
      "field.cattle.io/projectId" = "system"
    }
    annotations = {
      "management.cattle.io/system-namespace" : "true"
    }
  }

  depends_on = [ local_file.ansible_inventory ]
}

resource "helm_release" "cloudflare_tunnel_ingress_controller" {
  name       = "cloudflare-tunnel-ingress-controller"
  repository = "https://helm.strrl.dev"
  chart      = "cloudflare-tunnel-ingress-controller"
  namespace  = "cloudflare-tunnel-ingress-controller"

  set {
    name  = "cloudflare.apiToken"
    value = var.cloudflare_api_token
  }

  set {
    name  = "cloudflare.accountId"
    value = var.cloudflare_acount_id
  }

  set {
    name  = "cloudflare.tunnelName"
    value = var.cloudflare_tunnel_name
  }

  timeout = 100

  depends_on = [
    local_file.ansible_inventory,
    kubernetes_namespace.cloudflare_tunnel_ingress_controller
  ]
}

// variables
// create with permissions specified in https://github.com/STRRL/cloudflare-tunnel-ingress-controller
variable "cloudflare_api_token" {
  description = "The API Token for Cloudflare."
  type        = string
  sensitive   = true
}

variable "cloudflare_acount_id" {
  description = "The Cloudflare Account ID."
  type        = string
}

variable "cloudflare_tunnel_name" {
  description = "The name for the Cloudflare Tunnel (will be created by helm chart)."
  type        = string
  default     = "tetra"
}