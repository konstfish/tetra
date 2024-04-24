resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [
    file("${path.module}/cluster/helm/nginx/values.yml"),
  ]

  set {
    name  = "controller.service.externalIPs[0]"
    value = hcloud_load_balancer.lb.ipv4
  }

  depends_on = [local_file.ansible_inventory]
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true
  set {
    name  = "provider"
    value = "cloudflare"
  }

  set {
    name  = "cloudflare.apiToken"
    value = var.cloudflare_api_token
  }
  set {
    name  = "cloudflare.proxied"
    value = false
  }

  /*set {
    name  = "cloudflare.email"
    value = var.cloudflare_acount_email
  }*/

  depends_on = [helm_release.ingress_nginx]
}