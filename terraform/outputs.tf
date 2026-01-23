output "alb_dns" {
  description = "Application Load Balancer DNS"
  value       = module.compute.alb_dns
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.compute.asg_name
}
