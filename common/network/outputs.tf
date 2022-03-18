output "vpc_id" {
  description = "The ID of the VPC for EKS"
  value       = aws_vpc.this.id
}

output "private_subnet_a" {
  description = "The ID of the subnet_private_a for EKS"
  value       = aws_subnet.private_a.id
}

output "private_subnet_b" {
  description = "The ID of the private_subnet_b for EKS"
  value       = aws_subnet.private_b.id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway for private subnet"
  value       = aws_internet_gateway.this.id
}

output "cidr_block" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.this.id
}
