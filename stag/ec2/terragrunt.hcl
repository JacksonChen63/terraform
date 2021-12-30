terraform {
  source = "${get_parent_terragrunt_dir()}//common/ec2"
}

include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "${get_parent_terragrunt_dir()}//stag/network"
  skip_outputs = false
}

inputs = {
   vpc_id              = dependency.network.outputs.vpc_id
   subnet_id           = dependency.network.outputs.subnet_id
   internet_gateway_id = dependency.network.outputs.internet_gateway_id
   private_ip          = "10.0.10.50"
   key_name            = "jackson_chen_studyaccount"
   instance_type       = "m4.large"
   ami                 = "ami-0892d3c7ee96c0bf7"
}
