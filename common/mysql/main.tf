module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = var.system_name
  description = "Complete SqlServer example security group"
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      description = "SqlServer access from within VPC"
      cidr_blocks = "10.0.10.0/24"
    },
  ]

  tags = var.tags
}

################################################################################
# IAM Role for Windows Authentication
################################################################################

data "aws_iam_policy_document" "rds_assume_role" {
  statement {
    sid = "AssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_ad_auth" {
  name                  = "demo-rds-ad-auth"
  description           = "Role used by RDS for Active Directory authentication and authorization"
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.rds_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_directory_services" {
  role       = aws_iam_role.rds_ad_auth.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSDirectoryServiceAccess"
}

resource "aws_db_instance" "jackson_chen_db" {
  identifier           = "${var.system_name}-db"
  allocated_storage    = 50
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "JacksonChenDB"
  username             = "JacksonChen"
  password             = "jacksonchen"
  db_subnet_group_name = aws_db_subnet_group.default.name
  skip_final_snapshot  = true

  tags = var.tags
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [var.subnet_id_1, var.subnet_id_2]
  tags       = var.tags
}
