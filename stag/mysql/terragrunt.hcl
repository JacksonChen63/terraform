terraform {
  source = "${get_parent_terragrunt_dir()}//common/mysql"
}

include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "${get_parent_terragrunt_dir()}//stag/network"
  skip_outputs = false
}

inputs = {
   vpc_id          = dependency.network.outputs.vpc_id
   subnet_id_1         = dependency.network.outputs.subnet_id_1
   subnet_id_2         = dependency.network.outputs.subnet_id_2
}
