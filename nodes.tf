resource "hcloud_placement_group" "placement_group" {
  name   = "${var.cluster_name}-placement-group"
  type   = "spread"
  labels = var.hetzner_labels
}

resource "hcloud_server" "controller_nodes" {
  count       = var.cluster_controller_node_count
  name        = "${var.cluster_name}-ctl-${count.index}"
  image       = var.cluster_node_image
  server_type = var.cluster_controller_node_type
  location    = var.hetzner_location
  ssh_keys    = concat(keys(hcloud_ssh_key.default), [hcloud_ssh_key.ansible.name])

  firewall_ids = [hcloud_firewall.default.id]
  network {
    network_id = hcloud_network.default.id
    ip         = cidrhost(var.cluster_network_subnet_range, count.index + 11)
  }
  public_net {
    ipv4_enabled = var.cluster_node_public_net.ipv4_enabled
    ipv6_enabled = var.cluster_node_public_net.ipv6_enabled
  }

  placement_group_id = hcloud_placement_group.placement_group.id

  labels = merge(
    var.hetzner_labels,
    var.cluster_node_labels,
    {
      "cluster" = var.cluster_name
      "role"    = "controller"
    }
  )

  depends_on = [
    hcloud_network_subnet.cluster_network
  ]
}

resource "hcloud_server" "worker_nodes" {
  count       = var.cluster_node_count
  name        = "${var.cluster_name}-wrk-${count.index}"
  image       = var.cluster_node_image
  server_type = var.cluster_node_type
  location    = var.hetzner_location
  ssh_keys    = concat(keys(hcloud_ssh_key.default), [hcloud_ssh_key.ansible.name])

  firewall_ids = [hcloud_firewall.default.id]
  network {
    network_id = hcloud_network.default.id
    ip         = cidrhost(var.cluster_network_subnet_range, count.index + 21)
  }
  public_net {
    ipv4_enabled = var.cluster_node_public_net.ipv4_enabled
    ipv6_enabled = var.cluster_node_public_net.ipv6_enabled
  }

  placement_group_id = hcloud_placement_group.placement_group.id

  labels = merge(
    var.hetzner_labels,
    var.cluster_node_labels,
    {
      "cluster" = var.cluster_name
      "role"    = "worker"
    }
  )

  depends_on = [
    hcloud_network_subnet.cluster_network
  ]
}