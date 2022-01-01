output "vpc_id" {
  value = aws_vpc.jackson_chen_vpc.id
}

output "subnet_id_1" {
  value = aws_subnet.jackson_chen_subnet_1.id
}

output "subnet_id_2" {
  value = aws_subnet.jackson_chen_subnet_2.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.jackson_chen_gateway.id
}
