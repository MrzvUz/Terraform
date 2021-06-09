output "IP_Address_And_Port" {
  value       = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
  description = "The IP address of the container"
}

output "Container_Name" {
  value       = docker_container.nodered_container.name
  description = "The Name of the Container"
}


# output "ips" { value = "${join(", ", docker_container.nodered_container.*.ip_address)}" }