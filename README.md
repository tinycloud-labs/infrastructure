![Terragrunt Stack](https://github.com/tinycloud-labs/infrastructure/actions/workflows/terragrunt-managed-stack.yml/badge.svg) 
![Terragrunt Environment](https://github.com/tinycloud-labs/infrastructure/actions/workflows/terragrunt-deploy-env.yml/badge.svg) 
![License](https://img.shields.io/github/license/tinycloud-labs/infrastructure) 
![GitHub](https://img.shields.io/github/v/release/tinycloud-labs/infrastructure)
![Issues](https://img.shields.io/github/issues/tinycloud-labs/infrastructure)
 
# `homelab/infrastructure`

A Homelab Infrastructure as Code playground where I'm `uid=0`; i.e. I run the show: root access, full chaos. Powered by k3s, FluxCD, and  a questionable collection of tools that somehow still work together.

## Design Rationale

This repo uses [Terragrunt Explicit Stacks](https://docs.terragrunt.com/features/stacks#use-explicit-stacks-when) (with some opinionated design patterns) to provision VMs, install k3s and Flux, and do some basic setup. After that, Flux takes over to bootstrap the cluster and deploy apps, monitoring, and other stuff.

This repo won't work on anyone else's setup out of the box (that's intentional), but hopefully it gives you some ideas for using Terragrunt and Terraform together.

### Deployment

K3s deployed via [Ansible collection](https://github.com/k3s-io/k3s-ansible). Order of resource deployment is based on resource existence (dependency):

```
        ┌───────────────────────────────────────────┐
        │       Applications (Helm via Flux)        │
        └───────────────────┬───────────────────────┘
                            │ depends on
        ┌───────────────────▼───────────────────────┐
        │          Platform  (Kustomize/Flux)       │
        │      MetalLB, NFS CSI,  operators, etc    │
        └───────────────────┬───────────────────────┘
                            │ depends on
        ┌───────────────────▼──────────────────────┐
        │   Infrastructure (Terragrunt + Ansible)  │
        │           VMs + K3s + FluxCD             │
        └──────────────────────────────────────────┘
```

### Terragrunt 

Organized around the following logical hierarchy (using Terragrunt [stacks](https://terragrunt.gruntwork.io/docs/features/stacks/) and [units](https://terragrunt.gruntwork.io/docs/features/units/)):


## Automation and other stuff
- Github Actions: provisions/controlls Terragrunt stacks and units, as well as some helper workflows for code management.
- Renovate for automated dependency upgrades
- Applications deployment: Hosted in a [separated repo](https://github.com/tinycloud-labs/flux), deployed in a GitOps fashion by FluxCD.
- Helm Charts: Custom Helm charts released and hosted to Github Pages https://github.com/tinycloud-labs/helm

## Hardware/Networking (mostly not in code)
- Pfsense: Firewall, DNS, HAProxy, VLANs, VPN, and ACME cert-management and rotation.
- A bunch of potato hardware running the show, keeping a constantly pegged Proxmox alive (where engineering is about working within constraints, not just scaling with money!)
