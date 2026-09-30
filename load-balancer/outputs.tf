output "ip_address" {
  description = "Global external IPv4 address of the load balancer."
  value       = module.load_balancer.ip_address
}

output "forwarding_rule_id" {
  description = "HTTP forwarding-rule resource ID."
  value       = module.load_balancer.forwarding_rule_id
}

output "target_http_proxy_id" {
  description = "Target HTTP proxy resource ID."
  value       = module.load_balancer.target_http_proxy_id
}

output "url_map_id" {
  description = "URL map resource ID."
  value       = module.load_balancer.url_map_id
}

output "backend_service_id" {
  description = "Backend service resource ID."
  value       = module.load_balancer.backend_service_id
}

output "health_check_id" {
  description = "Load-balancer health-check resource ID."
  value       = module.load_balancer.health_check_id
}
