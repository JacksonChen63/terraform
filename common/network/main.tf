resource "aws_vpc" "jackson_chen_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.system_name}-vpc"
  }
}

resource "aws_internet_gateway" "jackson_chen_gateway" {
  vpc_id = aws_vpc.jackson_chen_vpc.id
}

resource "aws_subnet" "jackson_chen_subnet_1" {
  vpc_id            = aws_vpc.jackson_chen_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "${var.availability_zone}"
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.jackson_chen_gateway]
  tags = {
    Name = "${var.system_name}-subnet-1"
  }
}

resource "aws_subnet" "jackson_chen_subnet_2" {
  vpc_id            = aws_vpc.jackson_chen_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "${var.availability_zone}"
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.jackson_chen_gateway]
  tags = {
    Name = "${var.system_name}-subnet-2"
  }
}

resource "aws_route_table" "jackson_chen_route_table" {
  vpc_id = aws_vpc.jackson_chen_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jackson_chen_gateway.id
  }
  tags = {
    Name = "${var.system_name}-route-table"
  }
}

resource "aws_route_table_association" "jackson_chen_route_table_association_1" {
  subnet_id      = aws_subnet.jackson_chen_subnet_1.id
  route_table_id = aws_route_table.jackson_chen_route_table.id
}

resource "aws_route_table_association" "jackson_chen_route_table_association_2" {
  subnet_id      = aws_subnet.jackson_chen_subnet_2.id
  route_table_id = aws_route_table.jackson_chen_route_table.id
}

resource "aws_network_interface" "jackson_chen_netwrok_interface_1" {
  subnet_id       = aws_subnet.jackson_chen_subnet_1.id
}

resource "aws_network_interface" "jackson_chen_netwrok_interface_2" {
  subnet_id       = aws_subnet.jackson_chen_subnet_2.id
}

resource "aws_route" "jackson_chen_route_table_eks" {
  route_table_id = aws_route_table.jackson_chen_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.jackson_chen_gateway.id
}
