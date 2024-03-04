
resource "hcloud_network" "default" {
  name     = "vcn-${var.cluster_name}"
  ip_range = var.cluster_network_range
  labels   = var.hetzner_labels
}

resource "hcloud_network_subnet" "cluster_network" {
  type         = "cloud"
  network_id   = hcloud_network.default.id
  network_zone = var.hetzner_network_zone
  ip_range     = var.cluster_network_subnet_range
}

data "http" "runner_public_ip" {
  url = "https://api.ipify.org"
}

resource "hcloud_firewall" "default" {
  name = "vcn-firewall-${var.cluster_name}"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      join("/", [hcloud_load_balancer_network.lb_network.ip, "32"])
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      join("/", [hcloud_load_balancer_network.lb_network.ip, "32"])
    ]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = concat(var.cluster_firewall_allow_ips, [join("/", [data.http.runner_public_ip.response_body, "32"])])
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "6443"
    source_ips = concat(var.cluster_firewall_allow_ips, [join("/", [hcloud_load_balancer_network.lb_network.ip, "32"]), join("/", [data.http.runner_public_ip.response_body, "32"])])
  }

}