---
k3s_cluster:
  children:
    server:
      hosts:
%{ for node in controller_nodes ~}
        "${node.name}":
          ansible_host: "${node.ansible_host}"
          ansible_ssh_host: "${node.ansible_ssh_host}"
          extra_server_args: "--advertise-address ${node.ansible_host} --node-ip ${node.ansible_host} --node-external-ip ${node.ansible_ssh_host} --tls-san ${cluster_lb_internal_ip} --disable=traefik --disable=servicelb --disable=local-storage {{ common_args }}"
%{ endfor ~}
    agent:
      hosts:
%{ for node in worker_nodes ~}
        "${node.name}":
          ansible_host: "${node.ansible_host}"
          ansible_ssh_host: "${node.ansible_ssh_host}"
          extra_agent_args: "--node-ip ${node.ansible_host} --node-external-ip ${node.ansible_ssh_host} {{ common_args }}"
          api_endpoint: "${cluster_lb_internal_ip}"
%{ endfor ~}

  vars:
    ansible_port: 22
    ansible_user: root
    user_name: david
    github_user: konstfish
    k3s_version: ${k3s_version}
    token: ${token}
    lb_public_address: ${lb_public_address}
    cluster_lb_internal_ip: ${cluster_lb_internal_ip}
    api_endpoint: "{{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}"
    extra_server_args: "--disable=traefik --disable=servicelb --disable=local-storage"
    extra_agent_args: ""

    internal_interface: enp7s0
    common_args: "--flannel-iface {{ internal_interface }} "
