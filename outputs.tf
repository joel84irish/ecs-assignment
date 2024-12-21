output "public_ip" {
  description = "Contains the public IP address"
  value       = aws_eip.NatGateway_eip.public_ip
}

output "public_dns" {
  description = "Public DNS associated with the Elastic IP address"
  value       = aws_eip.NatGateway_eip.public_dns
}


output "target_group_arn" {
  value = aws_lb_target_group.target_group.id
}
