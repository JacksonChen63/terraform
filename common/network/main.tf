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

resource "aws_subnet" "jackson_chen_subnet" {
  vpc_id            = aws_vpc.jackson_chen_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.jackson_chen_gateway]
  tags = {
    Name = "${var.system_name}-subnet"
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

resource "aws_route_table_association" "jackson_chen_route_table_association" {
  subnet_id      = aws_subnet.jackson_chen_subnet.id
  route_table_id = aws_route_table.jackson_chen_route_table.id
}

resource "aws_network_interface" "jackson_chen_netwrok_interface" {
  subnet_id       = aws_subnet.jackson_chen_subnet.id
#  security_groups = [aws_security_group.jackson_chen_sg.id]
}
