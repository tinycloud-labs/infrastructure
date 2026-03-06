resource "kubernetes_storage_class_v1" "nfs" {
  metadata {
    name = var.class_name
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
    annotations = {
      "storageclass.kubernetes.io/is-default-class" : "true"
    }
  }

  storage_provisioner = "nfs.csi.k8s.io"

  parameters = {
    server = var.server
    share  = var.share
  }

  reclaim_policy         = "Retain"
  volume_binding_mode    = "Immediate"
  allow_volume_expansion = true

  mount_options = [
    "nfsvers=4.1",
    "hard",
    "timeo=600",
    "retrans=5"
  ]
}
