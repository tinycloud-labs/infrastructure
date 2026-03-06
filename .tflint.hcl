# https://github.com/terraform-linters/tflint-ruleset-terraform/tree/main/docs/rules
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

config {
  disabled_by_default = false
}

rule "terraform_typed_variables" {
  enabled = true
}

# Providers are managed by Terragrunt which is outside of tflint's visibility
rule "terraform_required_providers" {
  enabled = false
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

# The following rules are disabled because
# of the use of dynamic variables popluation
# and providers generation via Terragrunt
rule "terraform_required_version" {
  enabled = false
}

rule "terraform_unused_declarations" {
  enabled = false
}
