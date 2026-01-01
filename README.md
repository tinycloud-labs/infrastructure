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

K3s deployed via [Ansible collection](https://github.com/k3s-io/k3s-ansible). Order of resource deployment is based on resource existence (dependency):

```
        ┌───────────────────────────────────────────┐
        │       Applications (FluxCD + Helm)        │
        └───────────────────┬───────────────────────┘
                            │ depends on
        ┌───────────────────▼───────────────────────┐
        │          Platform  (Terragrunt)           │
        │          MetalLB, Flux,  etc              │
        └───────────────────┬───────────────────────┘
                            │ depends on
        ┌───────────────────▼──────────────────────┐
        │   Infrastructure (Terragrunt + Ansible)  │
        │                VMs + K3s.                │
        └──────────────────────────────────────────┘
```

Each layer in the diagram is represented as a corresponding Terragrunt stack, [for example this one](https://github.com/stackgarage/homelab/tree/main/terraform/live/prod). Except the apps, they're managed separately by Flux.

### Terragrunt 

Organized around the following logical hierarchy (using Terragrunt [stacks](https://terragrunt.gruntwork.io/docs/features/stacks/) and [units](https://terragrunt.gruntwork.io/docs/features/units/)):

```
Environment (prod/dev) > Stack > Units
```


| Environment | a collection of stacks representing the full environment (platform + infrastructure layers) |
| --- | --- |
| **Stack** | **a collection of units representing a complete middleware  layer (e.g., `terraform/live/prod/infra/`, etc)** |
| **Unit** | **a Terragrunt thin wrapper around a Terraform module representing a specific tool or resource (e.g., `terraform/catalog/units/loadbalancer/`)**


## Terraform State

State files are dynamically generated on the first run (thanks to Terragrunt's `generate` blocks), constructed via the `terraform/root.hcl` and organized in S3 cleanly as:  `live/<env>/<stack>/.terragrunt-stack/<unit>` pretty much mirroring the repo's directory hierarchy (separation across boundaries).

## Automation and other stuff

- Infrastructure: GitHub Actions to handle Terragrunt stacks and full-environment, as well as some helper workflows for code management.
- Applications deployment: Hosted in a [separated repo](https://github.com/tinycloud-labs/flux), deployed in a GitOps fashion by FluxCD.
- Helm Charts: Custom Helm charts released and hosted to Github Pages https://github.com/tinycloud-labs/helm

## Networking (not in code)
- Pfsense: Firewall, DNS, HAProxy, VLANs, VPN, and ACME cert-management and rotation.
