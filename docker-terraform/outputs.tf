# Output the IP Address of the Container.
output "container_name" {
  # Splat [*].name identifies all resources names and prints them out.
  value       = module.container[*].container_name
  description = "The Name of the Container"
}

output "ip_and_port" {
  # join function joines ip and port and prints out on the output dashboard.
  value       = flatten(module.container[*].ip_and_port)
  description = "The IP address of the container"
}
