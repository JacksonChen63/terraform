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
   cluster_name          = "TF-JacksonChen-Test"
   eks_vpc_id            = dependency.network.outputs.vpc_id
   private_subnet_a      = dependency.network.outputs.private_subnet_a
   private_subnet_b      = dependency.network.outputs.private_subnet_b
   region                = "ap-northeast-1"
   cluster_version       = "1.25"
   scaling_min_count     = 1
   scaling_max_count     = 4
   scaling_desired_count = 2
   instance_types        = ["t3.medium"]
   service_account       = "jacksonchen"
   aws_auth_roles = [
     {
       rolearn  = "arn:aws:iam::793821285439:role/AWSReservedSSO_Role-Jackson-DevOps_o7b3ba5e6awqg609"
       username = "Role-Jackson-DevOps"
       groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
     },
     {
       rolearn  = "arn:aws:iam::793821285439:role/role-jackson-devops"
       username = "role-jackson-devops"
       groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
     },
     {
       rolearn  = "arn:aws:iam::793821285439:role/AWSReservedSSO_Role-Jackson-Dev_kl9je83drea924c0c"
       username = "Role-Jackson-Dev"
       groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
     },
     {
       rolearn  = "arn:aws:iam::793821285439:role/AWSReservedSSO_Role-Jackson-DevOps_158a97a221a5n3b1"
       username = "Role-Jackson-DevOps"
       groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
     }
   ]
}

