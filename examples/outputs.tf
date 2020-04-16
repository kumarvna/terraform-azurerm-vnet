# Resource Group
output "resource_group_name" {
  description = "The name of the resource group in which resources are created"  
  value = module.virtualnetwork.resource_group_name
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"  
  value = module.virtualnetwork.resource_group_id
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"  
  value = module.virtualnetwork.resource_group_location
}

#VNet and Subnets 
output "virtual_network_name" {
  description = "The name of the virtual network"  
  value = module.virtualnetwork.virtual_network_name
}

output "virtual_network_id" {
  description = "The id of the virtual network"  
  value = module.virtualnetwork.virtual_network_id
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value = module.virtualnetwork.virtual_network_address_space
}

output "subnet_ids" {
  description = "List of IDs of subnets"  
  value = module.virtualnetwork.subnet_ids
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"  
  value = module.virtualnetwork.subnet_address_prefixes
}

# DDoS Protection plan
output "ddos_protection_plan" {
  description = "Ddos protection plan details"
  value       = module.virtualnetwork.ddos_protection_plan
}

# Network Watcher
output "network_watcher_id" {
  description = "ID of Network Watcher"
  value = module.virtualnetwork.network_watcher_id
}

# Firewall
output "firewall_id" {
  description = "The Resource ID of the Azure Firewall"
  value       = module.virtualnetwork.firewall_id
}

output "firewall_subnet_ids" {
  description = "List of IDs of firewall subnets"
  value       = module.virtualnetwork.firewall_subnet_ids
}

output "firewall_subnet_address_prefixes" {
  description = "List of address prefix for firewall subnets"
  value       = module.virtualnetwork.firewall_subnet_address_prefixes
}

output "firewall_public_ip_address" {
  description = "Public IP of firewall"
  value       = module.virtualnetwork.firewall_public_ip_address
}
