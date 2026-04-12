# NFS CSI Unit deployment - Generic pointing to the main NFS server
# NFS share mount point is environment specific (dev/prod mount points)
include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/terraform/catalog/modules/k8s/storageclass"
}

inputs = {
  # must patch what the driver is specifying
  storage_provisioner = "nfs.csi.k8s.io"
  parameters = {
    server = "10.10.50.38"
    share  = values.share
  }
  volume_binding_mode = "Immediate"
  mount_options = [
    "nfsvers=4.1",
    "hard",
    "timeo=600",
    "retrans=5"
  ]
  # values passed from the stack
  config_path      = values.config_path
  config_context   = values.config_context
  class_name       = values.class_name
  is_default_class = values.is_default_class
  reclaim_policy   = values.reclaim_policy
}
