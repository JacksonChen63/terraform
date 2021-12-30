terraform {
  source = "${get_parent_terragrunt_dir()}//common/network"
}

include {
  path = find_in_parent_folders()
}

inputs = {
   availability_zone = "us-west-2a"
}
