resource "aws_iam_role" "create_ec2_role" {
  name               = "Jackson-IAM-Role"
  assume_role_policy = data.aws_iam_policy_document.create_ec2_assume_role_policy.json
  tags = {
      Name = "Jackson-Chen-IAM-Role"
  }
}


data "aws_iam_policy_document" "create_ec2_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com","codebuild.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole",
    ]
  }
}


resource "aws_iam_role_policy" "jackson_chen_ec2_policy" {
  name = "Jackson_Chen_ec2_policy"
  role = aws_iam_role.create_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "ec2:RunInstances",
          "ec2:AssociateIamInstanceProfile"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_instance_profile" "jackson_chen_policy_profile" {
  name = "create_jenkins_chen_profile"
  role = aws_iam_role.create_ec2_role.name
}
