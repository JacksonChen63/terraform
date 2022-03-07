resource "aws_security_group" "jackson_chen_sg" {

  name        = "${var.system_name}-sg"
  description = "${var.system_name}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.0.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "jackson-ec2" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  subnet_id            = var.subnet_id_1
  private_ip           = var.private_ip
  iam_instance_profile = aws_iam_instance_profile.jackson_chen_policy_profile.id
  vpc_security_group_ids = [
    "${aws_security_group.jackson_chen_sg.id}"
  ]
  root_block_device {
    volume_size = 60
  }

  tags = {
    Name = "${var.system_name}"
  }
}

resource "aws_eip" "this" {
  vpc      = true
  instance = aws_instance.jackson-ec2.id
  tags = {
    Name = "${var.system_name}-eip"
  }
}
