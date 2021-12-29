terraform {
  source = "${get_parent_terragrunt_dir()}//common/ec2"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  service_key = "Jackson-Chen"
}
