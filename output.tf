output "elb_dns_name" {
  description = "DNS Name of the ELB"
  value       = module.elb.elb_dns_name
}
