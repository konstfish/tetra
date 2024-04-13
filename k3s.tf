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
  content = templatefile("${path.module}/ansible/inventory.tpl", {
    controller_nodes       = local.controller_nodes,
    worker_nodes           = local.worker_nodes,
    k3s_version            = var.cluster_k3s_version,
    token                  = var.cluster_token,
    lb_public_address      = hcloud_load_balancer.lb.ipv4
    cluster_lb_internal_ip = hcloud_load_balancer_network.lb_network.ip
  })
  filename = "${path.module}/ansible/inventory.yml"

  provisioner "local-exec" {
    command     = <<EOT
      sleep 10 # wait for nodes to be ready
      echo "$SSH_PRIVATE_KEY" > ssh_key && chmod 600 ssh_key
      ansible-playbook -i inventory.yml playbook.yml -u root --private-key=./ssh_key --extra-vars "kubeconfig_localhost=true kubeconfig_localhost_ansible_host=false"
      rm ssh_key
    EOT
    working_dir = "ansible"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "false"
      SSH_PRIVATE_KEY           = nonsensitive(tls_private_key.ansible.private_key_openssh)
    }
  }

  depends_on = [ hcloud_load_balancer_service.lb_service_6443 ]
}

output "controller_node_list" {
  value = local.controller_nodes
}

output "worker_node_list" {
  value = local.worker_nodes
}