module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.20.0"

  cluster_version                = var.cluster_version
  cluster_name                   = var.cluster_name
  cluster_endpoint_public_access = true
  enable_irsa                    = true
  create_cloudwatch_log_group    = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = [var.private_subnet_a, var.private_subnet_b]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    rctboekstest01 = {
      min_size       = var.scaling_min_count
      max_size       = var.scaling_max_count
      desired_size   = var.scaling_desired_count
      instance_types = var.instance_types
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true
  aws_auth_roles            = var.aws_auth_roles

  tags = {
    Name      = "${var.cluster_name}"
    Terraform = "true"
  }
}
