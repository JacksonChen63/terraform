resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-sg"
  description = "Allow local vpc"
  vpc_id      = var.eks_vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  tags = {
    Name = "${var.cluster_name}"
  }
}
resource "aws_security_group" "eks_node_group" {
  name        = "${var.cluster_name}-node-sg"
  description = "Allow local vpc"
  vpc_id      = var.eks_vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  tags = {
    Name = "${var.cluster_name}-node-group"
  }
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    subnet_ids         = [var.private_subnet_a, var.private_subnet_b]
    security_group_ids = [aws_security_group.eks_cluster.id]
  }
  tags = {
    Name = "${var.cluster_name}"
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-Node"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = [var.private_subnet_a, var.private_subnet_b]
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  depends_on = [
    data.aws_iam_policy.AmazonEKSWorkerNodePolicy,
    data.aws_iam_policy.AmazonEKS_CNI_Policy,
    data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name = "${var.cluster_name}-node"
  }
}
