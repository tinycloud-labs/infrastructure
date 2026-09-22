resource "proxmox_virtual_environment_role" "csi" {
    role_id = "Kubernetes-CSI"

    privileges = [
        "VM.Audit",
        "VM.Config.Disk",
        "Datastore.Allocate",
        "Datastore.AllocateSpace",
        "Datastore.Audit",
    ]
}

resource "proxmox_virtual_environment_user" "kubernetes" {
    comment = "Kubernetes"
    user_id = "kubernetes-csi@pve"
}

# Assign the CSI role to the Kubernetes user.
resource "proxmox_acl" "csi_user" {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.csi.role_id
    user_id   = proxmox_virtual_environment_user.kubernetes.user_id
}

# Create the Kubernetes CSI API token.
resource "proxmox_user_token" "csi" {
    comment    = "Kubernetes CSI"
    token_name = "csi"
    user_id    = proxmox_virtual_environment_user.kubernetes.user_id
}

# Assign the CSI role to the API token.
resource "proxmox_acl" "csi_token" {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.csi.role_id
    token_id  = proxmox_user_token.csi.id
}
