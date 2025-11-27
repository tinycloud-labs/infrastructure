![GitHub](https://img.shields.io/github/v/release/tinycloud-labs/infrastructure) 
![Terragrunt Stack](https://github.com/tinycloud-labs/infrastructure/actions/workflows/terragrunt-stack-env.yml/badge.svg) 
![Terragrunt Environment](https://github.com/tinycloud-labs/infrastructure/actions/workflows/terragrunt-deploy-env.yml/badge.svg) 
![License](https://img.shields.io/github/license/tinycloud-labs/infrastructure) 
![Issues](https://img.shields.io/github/issues/tinycloud-labs/infrastructure)

# Homelab

A Homelab Infrastructure-as-Code playground where I'm `uid=0`; I run the show: root access, full chaos. Powered by K3s, Proxmox, and Helm, hosting a variety of self-hosted services deployed via FluxCD.

## Design Rationale

The IaC is constructed using the below K8s and Terragrunt logical design

### Kubernetes

K3s deployed via [Ansible collection](https://github.com/k3s-io/k3s-ansible). Order of resource deployment is based on resource existence (dependency), which determines the overall order of operations:

```
        ┌───────────────────────────────────────────┐
        │       Applications (FluxCD + Helm)        │
        └───────────────────┬───────────────────────┘
                            │ depends on
        ┌───────────────────▼───────────────────────┐
        │          Platform  (Terragrunt)           │
        │ MetalLB, Flux, Nginx ingress, runner, etc │
        └───────────────────┬───────────────────────┘
                            │ depends on
        ┌───────────────────▼──────────────────────┐
        │   Infrastructure (Terragrunt + Ansible)  │
        │       VMs + K3s + Github Actions         │
        └──────────────────────────────────────────┘
```

Each layer in the diagram is represented as a corresponding Terragrunt stack, [for example this one](https://github.com/stackgarage/homelab/tree/main/terraform/live/prod). Except the apps, they're managed separately by Flux.

### Terragrunt 

Organized around the following logical hierarchy, implemented using Terragrunt [stacks](https://terragrunt.gruntwork.io/docs/features/stacks/) and [units](https://terragrunt.gruntwork.io/docs/features/units/) primitives:

```
Environment (prod/dev) > Stack > Units
```


| Environment | a collection of stacks representing the full environment (platform + infrastructure layers) |
| --- | --- |
| **Stack** | **a collection of units representing a middleware or core platform layer (e.g., `gha-arc`, `cert-manager`, etc)** |
| **Unit** | **a Terraform module representing a specific tool or resource (e.g., `cert-manager`, VM, etc)**


## Terraform State

State files are dynamically generated on the first run (thanks to Terragrunt's `generate` blocks) and organized in S3 cleanly as:  `live/<env>/<stack>/.terragrunt-stack/<unit>` pretty much mirroring the repo's directory hierarchy (separation across boundaries). 

## Automation

- **Infrastructure**: GitHub Actions designed to handle deployments at both the Terragrunt stack and full-environment level, while supporting helper workflows and tools such as labelers, linters, and other code management and quality workflows.

- **Applications**: Hosted in a [separated repo](https://github.com/tinycloud-labs/flux), deployed in a GitOps fashion, managed by FluxCD.
