resource "helm_release" "olm" {
  name       = "olm"
  repository = "oci://ghcr.io/cloudtooling/helm-charts"
  chart      = "olm"
  version    = "0.27.0"
}