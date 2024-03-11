resource "kubernetes_namespace" "teleport_cluster" {
  metadata {
    name = "teleport-cluster"
    labels = {
      "field.cattle.io/projectId" = "system"
    }
    annotations = {
      "management.cattle.io/system-namespace" : "true"
    }
  }

  depends_on = [ local_file.ansible_inventory ]

  lifecycle {
    ignore_changes = [
      metadata.0.labels,
      metadata.0.annotations,
    ]
  }
}

resource "helm_release" "teleport_cluster" {
  name       = "teleport-cluster"
  repository = "https://charts.releases.teleport.dev"
  chart      = "teleport-cluster"
  namespace  = "teleport-cluster"

  values = [
    file("${path.module}/cluster/helm/teleport/values.yml")
  ]

  timeout = 250

  depends_on = [
    local_file.ansible_inventory,
    kubernetes_namespace.teleport_cluster
  ]
}
