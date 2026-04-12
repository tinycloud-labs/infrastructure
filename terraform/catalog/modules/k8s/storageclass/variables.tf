variable "config_path" {
  description = "Path to the kubeconfig file (relative to execution directory)"
  type        = string
}

variable "config_context" {
  description = "Kubeconfig context to use"
  type        = string
}

variable "class_name" {
  description = "Name of the Kubernetes StorageClass"
  type        = string
}

variable "storage_provisioner" {
  description = "Provisioner name (e.g., nfs.csi.k8s.io). Must match the CSI driver"
  type        = string
}

variable "parameters" {
  description = "Provisioner-specific parameters (e.g., NFS server and share path)"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Additional annotations to apply to the StorageClass"
  type        = map(string)
  default     = {}
}

variable "is_default_class" {
  description = "Whether this StorageClass should be the cluster default"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels to apply to the StorageClass"
  type        = map(string)
  default     = {}
}

variable "mount_options" {
  description = "Mount options for the storage backend (e.g., NFS options)"
  type        = list(string)
  default     = []
}

variable "reclaim_policy" {
  description = "Reclaim policy for dynamically provisioned volumes (Retain or Delete)"
  type        = string

  validation {
    condition     = contains(["Retain", "Delete"], var.reclaim_policy)
    error_message = "reclaim_policy must be either \"Retain\" or \"Delete\"."
  }
}

variable "volume_binding_mode" {
  description = "Volume binding mode (Immediate or WaitForFirstConsumer)"
  type        = string

  validation {
    condition     = contains(["Immediate", "WaitForFirstConsumer"], var.volume_binding_mode)
    error_message = "volume_binding_mode must be \"Immediate\" or \"WaitForFirstConsumer\"."
  }
}

variable "allow_volume_expansion" {
  description = "Whether PersistentVolumeClaims can be resized"
  type        = bool
  default     = true
}
