resource "aws_security_group" "jackson_chen_sg" {

  name        = "Jackson-Chen-sg"
  description = "Jackson-Chen-sg"
  vpc_id      = aws_vpc.jackson_chen_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_vpc" "jackson_chen_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Jackson-Chen-vpc"
  }
}

resource "aws_internet_gateway" "jackson_chen_gateway" {
  vpc_id = aws_vpc.jackson_chen_vpc.id
}

resource "aws_subnet" "jackson_chen_subnet" {
  vpc_id            = aws_vpc.jackson_chen_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.jackson_chen_gateway]
  tags = {
    Name = "Jackson_Chen_subnet"
  }
}

resource "aws_route_table" "jackson_chen_route_table" {
  vpc_id = aws_vpc.jackson_chen_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jackson_chen_gateway.id
  }
  tags = {
    Name = "Jackson-Chen"
  }
}

resource "aws_route_table_association" "jackson_chen_route_table_association" {
  subnet_id      = aws_subnet.jackson_chen_subnet.id
  route_table_id = aws_route_table.jackson_chen_route_table.id
}

resource "aws_network_interface" "jackson_chen_netwrok_interface" {
  subnet_id       = aws_subnet.jackson_chen_subnet.id
  security_groups = [aws_security_group.jackson_chen_sg.id]
}

resource "aws_instance" "jackson-ec2" {
  ami             = "ami-0892d3c7ee96c0bf7"
  instance_type   = "m4.large"
  key_name        = "jackson_chen_studyaccount"
  subnet_id       = aws_subnet.jackson_chen_subnet.id
  private_ip      = "10.0.10.50"
  iam_instance_profile = aws_iam_instance_profile.jackson_chen_policy_profile.id
  vpc_security_group_ids = [
    "${aws_security_group.jackson_chen_sg.id}"
  ]
  root_block_device{
      volume_size = 60
  }

  tags          = {
      Name = "Jackson_Chen"
  }
}

resource "aws_eip" "eip" {
  vpc = true
  instance                  = aws_instance.jackson-ec2.id
  depends_on                = [aws_internet_gateway.jackson_chen_gateway]
  tags          = {
      Name = "Jackson_Chen"
  }
}
