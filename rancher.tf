resource "helm_release" "rancher" {
  name             = "rancher"
  repository       = "https://releases.rancher.com/server-charts/latest"
  chart            = "rancher"
  namespace        = "cattle-system"
  create_namespace = true

  values = [
    file("${path.module}/cluster/helm/rancher/values.yml")
  ]

  depends_on = [
    helm_release.cert_manager,
    helm_release.cert_manager_issuers,
    helm_release.external_dns,
    helm_release.ingress_nginx
  ]
}
