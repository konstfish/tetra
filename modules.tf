// core

module "openpolicyagent" {
  source = "../terraform/openpolicyagent"

  depends_on = [local_file.ansible_inventory]
}

module "operators" {
  source = "../terraform/operators"

  depends_on = [local_file.ansible_inventory]
}

module "cert_manager" {
  source = "../terraform/cert_manager"

  cloudflare_api_token = var.cloudflare_api_token

  depends_on = [module.operators]
}

// storage

module "longhorn" {
  source = "../terraform/longhorn"

  longhorn_s3_access_key = var.longhorn_s3_access_key
  longhorn_s3_secret_key = var.longhorn_s3_secret_key
  longhorn_s3_endpoint   = var.longhorn_s3_endpoint
  longhorn_s3_bucket     = var.longhorn_s3_bucket

  depends_on = [local_file.ansible_inventory]
}

// ingress

module "ingress_cloudflare" {
  source = "../terraform/ingress_cloudflare"

  cloudflare_api_token   = var.cloudflare_api_token
  cloudflare_acount_id   = var.cloudflare_acount_id
  cloudflare_tunnel_name = "tetra"

  depends_on = [local_file.ansible_inventory]
}

module "ingress_nginx" {
  source = "../terraform/ingress_nginx"

  external_ip          = hcloud_load_balancer.lb.ipv4
  cloudflare_api_token = var.cloudflare_api_token
  use_proxy_protocol   = true
  cluster_domain       = join(".", [var.cluster_short_name, var.cluster_group, var.cloudflare_domain])

  depends_on = [local_file.ansible_inventory]
}

module "istio" {
  source = "../terraform/istio"

  // todo

  depends_on = [local_file.ansible_inventory]
}

// mgmt

module "rancher" {
  source = "../terraform/rancher"

  depends_on = [module.cert_manager, module.ingress_nginx]
}

// security

module "oauth_proxy_zero" {
  source = "../terraform/oauth_proxy"

  oauth_domain        = "sso.konst.fish"
  oauth_class         = "zero"
  oauth_client_id     = var.oauth_client_id_zero
  oauth_client_secret = var.oauth_client_secret_zero
  oauth_cookie_secret = var.oauth_cookie_secret_zero

  depends_on = [module.rancher]
}

module "oauth_proxy_negative" {
  source = "../terraform/oauth_proxy"

  oauth_domain        = "sson.konst.fish"
  oauth_class         = "negative"
  oauth_github_team   = "facultative"
  oauth_client_id     = var.oauth_client_id_negative
  oauth_client_secret = var.oauth_client_secret_negative
  oauth_cookie_secret = var.oauth_cookie_secret_negative

  depends_on = [module.rancher]
}

module "sealed_secrets" {
  source = "../terraform/sealed_secrets"

  depends_on = [local_file.ansible_inventory]
}