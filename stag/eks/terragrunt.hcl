terraform {
  source = "${get_parent_terragrunt_dir()}//common/eks"
}

include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "${get_parent_terragrunt_dir()}//stag/network"
  skip_outputs = false
}

inputs = {
   cluster_name        = "TF-Jackson-Chen-EKS-Cluster"
   eks_vpc_id          = dependency.network.outputs.vpc_id
   private_subnet_a    = dependency.network.outputs.private_subnet_a
   private_subnet_b    = dependency.network.outputs.private_subnet_b
}
