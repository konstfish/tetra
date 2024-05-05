
// https://artifacthub.io/packages/helm/gatekeeper/gatekeeper

resource "helm_release" "olm" {
  name       = "gatekeeper"
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  version    = "3.15.1"

  namespace        = "gatekeeper-system"
  create_namespace = true
}