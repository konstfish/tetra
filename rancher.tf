resource "helm_release" "rancher" {
  name       = "rancher"
  repository = "https://releases.rancher.com/server-charts/latest"
  chart      = "rancher"
  namespace  = "cattle-system"
  create_namespace = true

  values = [
    file("${path.module}/cluster/helm/rancher/values.yml")
  ] 
}
