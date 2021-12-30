output "vpc_id" {
  value = aws_vpc.jackson_chen_vpc.id
}

output "subnet_id" {
  value = aws_subnet.jackson_chen_subnet.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.jackson_chen_gateway.id
}
