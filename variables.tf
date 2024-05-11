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
variable "cloudflare_api_token" {
  description = "The API Token for Cloudflare."
  type        = string
  sensitive   = true
}

variable "cloudflare_acount_id" {
  description = "The Cloudflare Account ID."
  type        = string
}

// longhorn
variable "longhorn_s3_access_key" {
  description = "The Access Key ID for the Longhorn S3 backup."
  type        = string
  sensitive   = true
}

variable "longhorn_s3_secret_key" {
  description = "The Secret Key for the Longhorn S3 backup."
  type        = string
  sensitive   = true
}

variable "longhorn_s3_endpoint" {
  description = "The S3 endpoint to use for Longhorn backups."
  type        = string
}

variable "longhorn_s3_bucket" {
  description = "The S3 bucket to use for Longhorn backups."
  type        = string
}

// oauth proxy

/// zero
variable "oauth_client_id_zero" {
  description = "OAuth client ID"
  type        = string
}

variable "oauth_client_secret_zero" {
  description = "OAuth client secret"
  type        = string
  sensitive   = true
}

variable "oauth_cookie_secret_zero" {
  description = "OAuth cookie secret"
  type        = string
  sensitive   = true
}

/// negative
variable "oauth_client_id_negative" {
  description = "OAuth client ID"
  type        = string
}

variable "oauth_client_secret_negative" {
  description = "OAuth client secret"
  type        = string
  sensitive   = true
}

variable "oauth_cookie_secret_negative" {
  description = "OAuth cookie secret"
  type        = string
  sensitive   = true
}