terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.44"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.2"
    }
  }
}

provider "http" {}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/k3s-ansible/artifacts/tetra.yml"
    insecure    = "true"
  }
}

provider "kubernetes" {
  config_path = "${path.module}/k3s-ansible/artifacts/tetra.yml"
  insecure    = "true"
}


provider "hcloud" {
  token = var.hcloud_token
}