resource "helm_release" "mongodb_operator" {
  name             = "mongodb-operator"
  repository       = "https://mongodb.github.io/helm-charts"
  chart            = "community-operator"
  namespace        = "mongodb"
  create_namespace = true

  set {
    name  = "agent.name"
    value = "mongodb-agent-ubi"
  }

  depends_on = [
    local_file.ansible_inventory
  ]
}