resource "tls_private_key" "ansible" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "ansible" {
  name       = "ansible"
  public_key = tls_private_key.ansible.public_key_openssh
}

data "external" "github_ssh_keys" {
  for_each = toset(var.github_usernames)

  program = ["bash", "-c", "curl -s https://github.com/${each.key}.keys | head -n 1 | jq --raw-input '{ssh_key: .}'"]
}

resource "hcloud_ssh_key" "default" {
  for_each = data.external.github_ssh_keys

  name       = each.key
  public_key = each.value.result.ssh_key
}