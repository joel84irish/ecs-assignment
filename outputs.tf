output "dns_name" {
  description = "The DNS name of the created ELB."
  value = aws_alb.application_load_balancer.dns_name
}    
