# Avoid Terraform version surprises regardless of where we run Terragrunt
terraform_version_constraint = "~> 1.14.0"

remote_state {
  backend = "s3"
  config = {
    bucket  = "tfstate.shakir.cloud"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

generate "terraform" {
  path      = "terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "~> 1.14.0"

  # Required stub-backend, real backend config is injected above
  backend "s3" {}
}
EOF
}
