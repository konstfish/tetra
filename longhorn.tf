resource "kubernetes_namespace" "longhorn_system" {
  metadata {
    name = "longhorn-system"
    labels = {
      "field.cattle.io/projectId" = "system"
    }
    annotations = {
      "management.cattle.io/system-namespace" = "true"
    }
  }

  lifecycle {
    ignore_changes = [
      metadata.0.labels,
      metadata.0.annotations,
    ]
  }
}

resource "kubernetes_secret" "longhorn_backup_secret" {
  metadata {
    name      = "longhorn-backup-secret"
    namespace = "longhorn-system"
  }

  data = {
    AWS_ACCESS_KEY_ID     = var.longhorn_s3_access_key
    AWS_SECRET_ACCESS_KEY = var.longhorn_s3_secret_key
    AWS_ENDPOINTS         = var.longhorn_s3_endpoint
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.longhorn_system]
}

resource "helm_release" "longhorn" {
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  namespace  = "longhorn-system"

  set {
    name  = "defaultSettings.backupTarget"
    value = var.longhorn_s3_bucket
  }

  set {
    name  = "defaultSettings.backupTargetCredentialSecret"
    value = kubernetes_secret.longhorn_backup_secret.metadata[0].name
  }

  depends_on = [kubernetes_namespace.longhorn_system, kubernetes_secret.longhorn_backup_secret]
}

// variables
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