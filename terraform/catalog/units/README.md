# `catalog/units`
A collection of Terragrunt units representing concrete and opinionated implementations of Terraform modules.

That's a fancy way of saying: each unit here defines a specific way to use a Terraform module, with defaults and conventions already baked in.

If you're coming from Terraform-only or Terragrunt implicit stacks setups, this replaces the usual "wrapper module" pattern (TF modules that just call other modules). Instead of adding more Terraform layers, we keep Terraform modules generic and simple and move that opinionated configuration into Terragrunt unit for cleaner structure.
