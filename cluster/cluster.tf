
resource "helm_release" "hcloud_csi_driver" {
  name       = "hcloud-csi"
  namespace  = "kube-system"
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-csi"
  timeout    = 100

  set {
    name  = "controller.hcloudToken.value"
    value = var.hcloud_token
  }

  depends_on = [
    local_file.ansible_inventory
  ]
}

// wip 0 clue
/*resource "helm_release" "hcloud_cloud_controller_manager" {
  name       = "hcloud-cloud-controller-manager"
  namespace  = "kube-system"
  repository = "https://helm-charts.mlohr.com/"
  chart      = "hcloud-cloud-controller-manager"

  set {
    name  = "secret.hcloudApiToken"
    value = var.hcloud_token
  }

  set {
    name  = "deployment.image"
    value = "hetznercloud/hcloud-cloud-controller-manager:v1.19.0"
  }

  set {
    name  = "config.privateNetworks.enabled"
    value = "true"
  }

  set {
    name  = "config.privateNetworks.id"
    value = hcloud_network.default.id
  }

  set {
    name  = "config.privateNetworks.subnet"
    value = hcloud_network.default.ip_range
  }

  set {
    name  = "config.loadBalancers.enabled"
    value = false
  }

  depends_on = [
    local_file.ansible_inventory
  ]
}*/