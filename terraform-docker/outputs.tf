output "IP-Address" {
  value       = "${docker_container.nodered_container.ip_address}"
  description = "The IP address of the container"
}

output "Container-Name" {
  value       = "${docker_container.nodered_container.name}"
  description = "The Name of the Container"
}
# output "ips" { value = "${join(", ", docker_container.nodered_container.*.ip_address)}" }