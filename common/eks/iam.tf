data "aws_iam_policy" "AmazonEKSClusterPolicy" {
  name = "AmazonEKSClusterPolicy"
}
data "aws_iam_policy" "AmazonEKSWorkerNodePolicy" {
  name = "AmazonEKSWorkerNodePolicy"
}
data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}
data "aws_iam_policy" "AmazonEKS_CNI_Policy" {
  name = "AmazonEKS_CNI_Policy"
}
data "aws_iam_policy_document" "jackson-chen-ec2-instance" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "jackson-chen-eks-instance" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "jackson-chen-eks-cluster" {
  name = "${var.cluster_name}-IAM-Role"
  assume_role_policy = data.aws_iam_policy_document.jackson-chen-eks-instance.json
  managed_policy_arns = [data.aws_iam_policy.AmazonEKSClusterPolicy.arn]
}
resource "aws_iam_role" "jackson-chen-eks-node" {
  name = "${var.cluster_name}-Node-IAM-Role"
  assume_role_policy = data.aws_iam_policy_document.jackson-chen-ec2-instance.json
  managed_policy_arns = [data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn, data.aws_iam_policy.AmazonEKS_CNI_Policy.arn, data.aws_iam_policy.AmazonEKSWorkerNodePolicy.arn]
}
