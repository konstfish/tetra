// namespace
resource "kubernetes_namespace" "hetzner" {
  metadata {
    name = "hetzner"
  }

  depends_on = [
    local_file.ansible_inventory
  ]

  lifecycle {
    ignore_changes = [
      metadata.0.labels,
      metadata.0.annotations,
    ]
  }
}

resource "helm_release" "hcloud_ccm" {
  name       = "hcloud-ccm"
  namespace  = "hetzner"
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-cloud-controller-manager"
  timeout    = 100

  depends_on = [
    kubernetes_namespace.hetzner,
    kubernetes_secret.hcloud_token
  ]
}

resource "helm_release" "hcloud_csi_driver" {
  name       = "hcloud-csi"
  namespace  = "hetzner"
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-csi"
  timeout    = 100

  set {
    name  = "controller.hcloudToken.value"
    value = var.hcloud_token
  }

  depends_on = [
    kubernetes_namespace.hetzner
  ]
}

resource "kubernetes_secret" "hcloud_token" {
  metadata {
    name      = "hcloud"
    namespace = "hetzner"
  }

  data = {
    "token" = var.hcloud_token
  }

  depends_on = [
    kubernetes_namespace.hetzner
  ]
}