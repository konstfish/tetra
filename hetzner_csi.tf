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