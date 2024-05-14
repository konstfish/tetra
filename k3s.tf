locals {
  controller_nodes = [for i in range(var.cluster_controller_node_count) : {
    name             = hcloud_server.controller_nodes[i].name
    ansible_host     = hcloud_server.controller_nodes[i].network.*.ip[0]
    ansible_ssh_host = hcloud_server.controller_nodes[i].ipv4_address
  }]
  worker_nodes = [for i in range(var.cluster_node_count) : {
    name             = hcloud_server.worker_nodes[i].name
    ansible_host     = hcloud_server.worker_nodes[i].network.*.ip[0]
    ansible_ssh_host = hcloud_server.worker_nodes[i].ipv4_address
  }]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/k3s-ansible/inventory.tpl", {
    controller_nodes = local.controller_nodes,
    worker_nodes     = local.worker_nodes,

    ansible_user    = "root",
    ansible_ssh_key = "./artifacts/ssh_key",

    user_name   = "david",
    github_user = "konstfish",

    k3s_version  = var.cluster_k3s_version,
    k3s_token    = var.cluster_token,
    cluster_name = "tetra",
    cluster_type = "hetzner",

    lb_public_address   = hcloud_load_balancer.lb.ipv4
    lb_internal_address = hcloud_load_balancer_network.lb_network.ip
    lb_interface        = "enp7s0"
    lb_port             = 6443

    extra_server_args = ""
    cluster_cidr      = "10.44.0.0/16"
    service_cidr      = "10.45.0.0/16"
  })
  filename = "${path.module}/k3s-ansible/inventory.yml"

  provisioner "local-exec" {
    command     = <<EOT
      sleep 10 # wait for nodes to be ready
      echo "$SSH_PRIVATE_KEY" > artifacts/ssh_key && chmod 600 artifacts/ssh_key
      ansible-playbook -i inventory.yml playbook/install.yml --extra-vars "kubeconfig_localhost=true kubeconfig_localhost_ansible_host=false"
    EOT
    working_dir = "k3s-ansible"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "false"
      SSH_PRIVATE_KEY           = nonsensitive(tls_private_key.ansible.private_key_openssh)
    }
  }
}

output "controller_node_list" {
  value = local.controller_nodes
}

output "worker_node_list" {
  value = local.worker_nodes
}