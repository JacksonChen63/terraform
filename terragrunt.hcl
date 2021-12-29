locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region           = "us-west-2"
  system_name      = "jackson-chen"
  tags = {
    "owner"       = "Jackson-Chen"
  }
}

generate "provider" {
  path      = "autogen_provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "autogen_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "${get_aws_account_id()}-${local.region}-${local.system_name}-terraform-state"
    key            = "${local.system_name}/${local.region}/${path_relative_to_include()}/${local.system_name}/terraform.tfstate"
    dynamodb_table = "${get_aws_account_id()}-${local.region}-${local.system_name}-infra-terraform-locks"
    region         = local.region
    encrypt        = true
  }
}

  inputs = merge(
  local.environment_vars.locals,
  {
    tags        = local.tags,
    region      = local.region,
    system_name = local.system_name
  },
)
