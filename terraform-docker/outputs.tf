output "Container_Name" {
  # Splat [*].name identifies all resources names and prints them out.
  value       = docker_container.nodered_container[*].name
  description = "The Name of the Container"
}

output "IP_Address_And_Port" {
  # join function joines ip and port and prints out on the output dashboard.
  value       = [for i in docker_container.nodered_container[*] : join(" : ", [i.ip_address], i.ports[*]["external"])]
  description = "The IP address of the container"
}
