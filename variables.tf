// Hetzner
variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

// Setup
variable "github_usernames" {
  description = "List of GitHub usernames"
  type        = list(string)
}

// Cluster Settings
/// General
variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
  default     = "tetra"
}

variable "cluster_k3s_version" {
  description = "Cluster version"
  type        = string
  default     = "v1.27.6+k3s1"
}

// REPLACE WITH YOUR OWN TOKEN
variable "cluster_token" {
  description = "Cluster token"
  type        = string
  default     = "asdf"
}

/// Nodes
variable "cluster_node_count" {
  description = "The number of worker nodes in the cluster."
  type        = number
  default     = 2
}

variable "cluster_controller_node_count" {
  description = "The number of controller nodes in the cluster."
  type        = number
  default     = 1
}

variable "cluster_node_type" {
  description = "The type of worker nodes in the cluster."
  type        = string
  default     = "cax11"
}

variable "cluster_controller_node_type" {
  description = "The type of controller nodes in the cluster."
  type        = string
  default     = "cax21"
}

variable "cluster_node_image" {
  description = "The image of worker nodes in the cluster."
  type        = string
  default     = "ubuntu-22.04"
}

variable "cluster_node_labels" {
  description = "The labels for the worker nodes in the cluster."
  type        = map(string)
  default     = {}
}

variable "cluster_node_public_net" {
  description = "The public network configuration for the worker nodes in the cluster."
  type        = map(string)
  default = {
    "ipv4_enabled" = true
    "ipv6_enabled" = true
  }
}

/// Network
variable "cluster_network_range" {
  description = "The CIDR for the cluster network."
  type        = string
  default     = "10.10.0.0/16"
}

variable "cluster_network_subnet_range" {
  description = "The CIDR for the cluster network."
  type        = string
  default     = "10.10.0.0/24"
}

/// Load Balancer
variable "cluster_load_balancer_type" {
  description = "The type of load balancer to create."
  type        = string
  default     = "lb11"
}

/// Firewall
variable "cluster_firewall_allow_ips" {
  description = "The list of ports to allow in the firewall."
  type        = list(string)
  default     = []
}

// Hetzner General
variable "hetzner_location" {
  description = "The location/region where the resources will be created."
  type        = string
  default     = "nbg1"
}

variable "hetzner_network_zone" {
  description = "The network zone where the resources will be created."
  type        = string
  default     = "eu-central"
}

variable "hetzner_labels" {
  description = "The labels for the worker nodes in the cluster."
  type        = map(string)
  default = {
    "created_by" = "terraform"
  }
}

// Cloudflare

// create with permissions specified in https://github.com/STRRL/cloudflare-tunnel-ingress-controller
variable "cloudflare_api_token" {
  description = "The API Token for Cloudflare."
  type        = string
  sensitive   = true
}

variable "cloudflare_acount_id" {
  description = "The Cloudflare Account ID."
  type        = string
}

variable "cloudflare_acount_email" {
  description = "The Cloudflare Account email"
  type        = string
}

variable "cloudflare_tunnel_name" {
  description = "The name for the Cloudflare Tunnel (will be created by helm chart)."
  type        = string
  default     = "hetzner-k8s"
}

// Optionals
variable "install_prometheus_stack" {
  description = "Install Prometheus Stack"
  type        = bool
  default     = true
}

variable "install_mongodb_operator" {
  description = "Install MongoDB Operator"
  type        = bool
  default     = false
}

variable "install_argocd" {
  description = "Install ArgoCD"
  type        = bool
  default     = false
}

variable "install_openshift_console" {
  description = "Install Tekton"
  type        = bool
  default     = false
}
variable "install_tekton" {
  description = "Install Tekton"
  type        = bool
  default     = false
}