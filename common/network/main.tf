resource "aws_vpc" "this" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.system_name}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.system_name}-internet-gateway"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.this]
  tags = {
    Name = "${var.system_name}-private-subnet"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.20.0/24"
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.this]
  tags = {
    Name = "${var.system_name}-private-subnet"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.system_name}-route-table"
  }
}

resource "aws_route_table_association" "subnet_private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "subnet_private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.this.id
}

resource "aws_network_interface" "subnet_private_a" {
  subnet_id = aws_subnet.private_a.id
  tags = {
    Name = "${var.system_name}-network-interface"
  }
}

resource "aws_network_interface" "subnet_private_b" {
  subnet_id = aws_subnet.private_b.id
  tags = {
    Name = "${var.system_name}-network-interface"
  }
}

resource "aws_route" "eks" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}
